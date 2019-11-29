#!/usr/bin/php
<?php

$filePath = '/tmp/t';

if (isset($argv[1])){
    $filePath = $argv[1];
}

$fileText = file_get_contents($filePath);

echo urldecode($fileText) . "\n";
