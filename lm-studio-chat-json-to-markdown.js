#!/usr/bin/env -S deno run --allow-read

/** [IonicaBizau/json2md: :pushpin: A JSON to Markdown converter.](https://github.com/IonicaBizau/json2md) */
import json2md from "npm:json2md";

// console.log(Deno.args);

const inputFilePath = Deno.args[0];

if (!inputFilePath) {
  throw new Error("JSON file path required");
}

const decoder = new TextDecoder("utf-8");
const data = Deno.readFileSync(inputFilePath);
const text = decoder.decode(data);
const _json = JSON.parse(text);
const mdJson = [];

const { name, messages } = _json;

mdJson.push({ h1: name })

for (let messageIndex in messages) {
  const msg = messages[messageIndex];
  const messageNum = parseInt(messageIndex) + 1;

  const { versions } = msg;
  const { role, steps, content } = versions[0];

  console.error(`msg #{messageNum}`, msg);

  if (role === 'user') {
    mdJson.push({ h2: `Message #${messageNum} from user` });
    mdJson.push({ p: content[0].text });
  }
  else {
    const step = steps[0];
    mdJson.push({ h2: `Message #${messageNum} from LLM` });
    mdJson.push({ p: step.content[0].text });
  }
}

// console.log(text);
const md = json2md(mdJson);


console.log(md);
