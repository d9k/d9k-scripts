#!/usr/bin/php
<?php

$filePath = '/tmp/t';

if (isset($argv[1])){
    $filePath = $argv[1];
}

$fileText = file_get_contents($filePath);
$decodedArray = json_decode($fileText, 1);

var_export($decodedArray);
echo "\n";
