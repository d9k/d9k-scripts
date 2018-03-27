#!/usr/bin/env
<?php

$shortArrayOnOneString = false;
$maxArrayOnOneStringLen = 60;
$convertToNumberIfPossible = false;
$pipeMode = false;

function _arrayLinesToString($lines, $indent){
    global $maxArrayOnOneStringLen;
    global $shortArrayOnOneString;
    $totalLen = 0;
    $trimmedLines = [];
    foreach ($lines as $line){
        if ($totalLen > 0){
            $totalLen += 2; //", " - 2 symbols len
        }
        $trimmedLine = trim($line);
        $trimmedLines[] = $trimmedLine;
        $totalLen += strlen($trimmedLine);
        if ($totalLen > $maxArrayOnOneStringLen){
            break;
        }
    }
    return ($shortArrayOnOneString && $totalLen < $maxArrayOnOneStringLen) ?
          "[" . implode(", ", $trimmedLines) . "]"
        : "[\n" . implode(",\n", $lines) . "\n" . $indent . "]";
}

function var_export54($var, $indent="") {
    global $convertToNumberIfPossible;
    switch (gettype($var)) {
        case "string":
            if ($convertToNumberIfPossible && is_numeric($var)){
                if ((($t = filter_var($var, FILTER_VALIDATE_INT)) !== false)
                 || (($t = filter_var($var, FILTER_VALIDATE_FLOAT)) !== false)){
                    //don't strip leading zeroes or whitespaces
                    if (strlen((string)$t) == strlen($var)){
                        return (string)$t;
                    }
                }
            }
            return '"' . addcslashes($var, "\\\$\"\r\n\t\v\f") . '"';
        case "array":
            $indexed = array_keys($var) === range(0, count($var) - 1);
            $lines = [];
            foreach ($var as $key => $value) {
                $lines[] = "$indent    "
                     . ($indexed ? "" : var_export54($key) . " => ")
                     . var_export54($value, "$indent    ");
            }
            return _arrayLinesToString($lines, $indent);
        case "boolean":
            return $var ? "TRUE" : "FALSE";
        case "double": //fix precision break issue
            return (string)$var;
        default:
            return var_export($var, TRUE);
    }
}

function q($s){
	return '"' . $s . '"';
}

$outputToSameFile = false;
$filePath = null;

class ArgType{
    const INT = 'int';
}

function getNextArg($n, $argType=ArgType::INT){
    global $argv;
    if (!isset ($argv[$n+1])){
        return null;
    }
    $rawValue = $argv[$n+1];
    $value = null;
    if (is_string($rawValue) && $rawValue[0] == '-'){
        return;
    }
    switch ($argType){
        case ArgType::INT:
            if (is_numeric($rawValue)){
                if ($rawValue = filter_var($rawValue, FILTER_VALIDATE_INT)){
                    $value = $rawValue;
                }
            };
            break;
        default:
            return null;
    }
    return $value;
}

function echoUsage(){
    echo <<<'USAGE'
This util exports php var from file to square-bracketed php 5.4 style array
Usage: var-export [params] path_to_file'
Args:
-h : echo this help
-n : numeric mode - convert strings to numbers if possible
-s columns_num: shortmode. Write array on one line if it's short. Default columns num is {$maxArrayOnOneStringLen}
-o: overwrite original file
-p: pipe mode (STDIN/STDOUT)

USAGE;
}

$n = 1;
while ($n < $argc) {
    $arg = $argv[$n];
    if ($arg == '-h') {
        echoUsage();
        exit();
    } else if ($arg == '-s'){
        $shortArrayOnOneString = true;
        if ($t = getNextArg($n, ArgType::INT)){
            $maxArrayOnOneStringLen = $t;
            $n++;
        }
    } else if ($arg == '-n') {
        $convertToNumberIfPossible = true;
    } else if ($arg == '-p') {
        $pipeMode = true;
    } else if ($arg == '-o') {
        $outputToSameFile = true;
    } else if ($arg[0] != '-') {
        $filePath = $arg;
    }
    $n++;
}

if($pipeMode || !$filePath) {
    if (!$pipeMode) {
        echo 'filepath not specified. pipemode (STDIN mode). Ctrl+C for exit. Rerun with -h for help' . "\n";
        echo 'For processing paste block of code here, then press Enter, Ctrl-D:'."\n";
    }
    $fileText = '';
    while (FALSE !== ($line = fgets(STDIN))) {
        $fileText .= $line;
    }
} else {
    echo 'processing ' . q($filePath)."\n\n";
    if (!file_exists($filePath)){
        echo 'Can\'t find file '.q($filePath);
        exit(1);
    }

    if (!is_readable($filePath)){
        echo 'Can\'t read file '.q($filePath);
        exit(1);
    }

    $fileText = file_get_contents($filePath);
}

$a = eval('return '.$fileText.';');

if ( $a === false && ( $error = error_get_last() ) ) {
    // echo $error['type'], $error['message'], $error['file'], $error['line'], null );
    echo 'While input code parsing: '.$error['message']."\n";
    exit(1);
}

$exported = var_export54($a);
echo $exported;
if (!$pipeMode) {
    echo "\n";
}

if (!$pipeMode && $filePath && $outputToSameFile){
    if (!is_writable($filePath)){
        echo 'Can\'t write to file ' . q($filePath);
        exit(1);
    }
    file_put_contents($filePath, $exported);
    echo 'written to '.q($filePath);
}