#!/usr/bin/php
<?php
if(!function_exists('apc_clear_cache')) {
echo "no fun";
return;
}

apc_clear_cache();
apc_clear_cache('user');
apc_clear_cache('opcode');