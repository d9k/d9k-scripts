#!env deno

import { Html5Entities } from "https://deno.land/x/html_entities@v1.0/mod.js";
console.log(Html5Entities.decode('&lt;&gt;&quot;&amp;&copy;&reg;'));
