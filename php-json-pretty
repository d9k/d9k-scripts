#!/usr/bin/php
<?php

$filePath = '/tmp/t';

if (isset($argv[1])){
    $filePath = $argv[1];
}

$fileText = file_get_contents($filePath);
$decodedArray = json_decode($fileText, 1);

echo json_encode(
  $decodedArray,
  JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE
)
. "\n";
