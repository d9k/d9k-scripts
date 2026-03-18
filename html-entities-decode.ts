#!/bin/env deno

import { Html5Entities } from "https://deno.land/x/html_entities@v1.0/mod.js";
import { stdout } from 'node:process';

const pipeInputLines = [];

const decoder = new TextDecoder();
for await (const chunk of Deno.stdin.readable) {
  const text = decoder.decode(chunk);
  pipeInputLines.push(text);
}

const pipeInputString = pipeInputLines.join("\n");
// console.log(Html5Entities.decode(pipeInputString));
stdout.write(Html5Entities.decode(pipeInputString));
