#!/usr/bin/awk BEGIN{system("deno run "ARGV[1]"  "ARGV[2]" "ARGV[3]" "ARGV[4]" "ARGV[5])}

// Ported from https://github.com/rstrobl/sqldump-converter on Python to Deno Typescript with DeepSeek 2025.11.25
// Example usage with clipboard content:
// `xclip -selection clipboard -o | sql2json.ts`

interface RowData {
  [key: string]: string;
}

function parseSQLDump(
  sqlInsertInputString: string,
  prettyPrint: boolean = true,
): string {
  // Regex to match INSERT statements
  const regex = /INSERT INTO [`'"]?(\w+)[`'"]? \((.+)\) VALUES[\s]*\((.+)\)/g;
  const rows: RowData[] = [];
  // console.log(sqlInsertInputString);

  const matches = sqlInsertInputString.matchAll(regex);

  for (const match of matches) {
    if (!match.length) {
      continue;
    }

    // console.log(match);
    const table = match[1];

    // Split parameters and remove their leading and trailing `-tags and whitespaces
    const keys = match[2].split(",").map((w) =>
      w.trim().replace(/^[ `'"]+|[ `'"]+$/g, "")
    );
    const values = match[3].split(",").map((w) =>
      w.trim().replace(/^[ `'"]+|[ `'"]+$/g, "")
    );

    // Convert data to dictionary and append to results
    const row: RowData = {};
    keys.forEach((key, index) => {
      row[key] = values[index];
    });
    rows.push(row);
  }

  return JSON.stringify(rows, null, prettyPrint ? "  " : undefined);
}

const pipeInputLines = [];

const decoder = new TextDecoder();
for await (const chunk of Deno.stdin.readable) {
  const text = decoder.decode(chunk);
  pipeInputLines.push(text);
}

const pipeInputString = pipeInputLines.join("\n");

const jsonOutput: string = parseSQLDump(pipeInputString);
console.log(jsonOutput);
