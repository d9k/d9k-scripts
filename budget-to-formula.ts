#!/usr/bin/awk BEGIN{system("deno run --unstable --allow-read --allow-run "ARGV[1]"  "ARGV[2]" "ARGV[3]" "ARGV[4]" "ARGV[5])}

import * as path from "https://deno.land/std@0.96.0/path/mod.ts";
import { exec } from "https://deno.land/x/execute@v1.1.0/mod.ts";
import util from "https://deno.land/std@0.100.0/node/util.ts";

util.inspect.defaultOptions.maxArrayLength = 10000;

// import makeloc from 'https://deno.land/x/dirname@1.1.2/mod.ts'

//TODO awk loop concat

const decoder = new TextDecoder('utf-8');

function readFileSync(filePath: string): string {
  // return fs.readFileSync(filePath, 'utf8')
  return decoder.decode(Deno.readFileSync(filePath));
}

let scriptPath = path.fromFileUrl(import.meta.url);
let scriptFile = path.basename(scriptPath);

if (Deno.args.length < 1) {
  console.log(
`Usage:
    ${scriptFile} [BUDGET_FILE_NAME]`
  );
  Deno.exit(1);
}

let budgetFilePath = Deno.args[0]

console.log(budgetFilePath);
let budgetFileContents = readFileSync(budgetFilePath)

let budgetLinesRaw: string[] = budgetFileContents.match(/[^\r\n]+/g) || [];

let budgetLines: string[] = budgetLinesRaw.filter((line: string) => {
  return !line.match(/^(\#|\/|\()/)
})

let summandsRaw: Array<string|undefined> = budgetLines.map((line: string) => {
  let match = line.match('[0-9\+\-]+[\s\?]*$')
  if (match) {
    return match[0];
  }
})

let summandsFiltered: string[] = summandsRaw.filter(
  (x) => x != undefined
) as string[];

let summands: string[] = summandsFiltered.map((summand: string) => {
  summand = summand.replace(/[\s\?]*$/, '');
  let match = summand.match(/^[\+\-]/)
  return match ? summand : '+' + summand;
})

// map((line?: string) => {
//   return line ;
// })

// const { __dirname,  __filename } = makeloc(import.meta)

let formula = summands.join('')

formula = formula.replace(/^\+/, '')

let formulaWithPrefix = '= ' + formula

// let command = `sh -c 'echo "${formula}" | bc -l'`
// let command = `sh -c 'echo "1+1" | bc -l'`
// let command = `sh -c "echo '1+1' | bc -l"`
// let command = ['sh', '-c', 'echo 1']
let command = ['sh', '-c', `echo "${formula}" | bc -l`]

// console.log(budgetLines);
console.log(summandsRaw);
console.log(util.inspect(summandsRaw))
// console.log(summands);
console.log(formulaWithPrefix);
// console.log(command)

console.log()
console.log(await exec(command))

// console.log(__filename);
