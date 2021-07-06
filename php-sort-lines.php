#!/usr/bin/php
<?php

$filePath = '/tmp/t';

if (isset($argv[1])){
    $filePath = $argv[1];
}

$lines = file($filePath);
natsort($lines);

echo implode("", $lines);
