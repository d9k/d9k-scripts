#!/usr/bin/awk BEGIN{system("deno run --unstable --allow-read --allow-write --allow-env "ARGV[1])}
// https://unix.stackexchange.com/a/551025/48167

// https://stackoverflow.com/a/61821141/1760643
// import { createRequire } from "https://deno.land/std/node/module.ts";

// import * as fs from "https://deno.land/std/fs/mod.ts";
import * as path from "https://deno.land/std/path/mod.ts";

// import { findNearestPackageJsonSync } from "https://jspm.dev/find-nearest-package-json@2.0.1";
import editPackageJson from "https://jspm.dev/edit-package-json@0.1.36";
import { exists } from "https://deno.land/std/fs/mod.ts"

const decoder = new TextDecoder('utf-8');

// console.dir(fs)

function readFileSync(filePath: string): string {
  // return fs.readFileSync(filePath, 'utf8')
  return decoder.decode(Deno.readFileSync(filePath));
}

/** Modified "https://jspm.dev/find-nearest-package-json@2.0.1"; */
function findNearestPackageJsonSync(
  directoryPath: string = path.resolve()
): { path: string, data: any, text: string }  {
  try {
    const packageJsonPath = path.join(directoryPath, 'package.json')
    const packageJsonText = readFileSync(packageJsonPath);
    const packageJsonData = JSON.parse(packageJsonText);
    return {
      path: packageJsonPath,
      data: packageJsonData,
      text: packageJsonText,
    }
  } catch (error) {
    const parentDirectoryPath = path.dirname(directoryPath)
    if (parentDirectoryPath === directoryPath) {
      throw new Error('No package.json files found')
    }
    return findNearestPackageJsonSync(parentDirectoryPath)
  }
}

//console.log(msg);

let cwd = Deno.cwd();

// console.log(cwd);

const packageJson = findNearestPackageJsonSync(cwd)

console.log("Found package.json at: " + packageJson.path)

let version = packageJson.data.version;

// console.log(packageJsonString)
console.log("current version: ", version);

const [ patchStr, majorStr, minorVer ] = version.split(".");

const [ minorStr, minorSuffix ] = minorVer.split("-")

const [ patch, major, minor ] = [patchStr, majorStr, minorStr].map(numStr => parseInt(numStr));

console.log("patch version: ", patch);
console.log("major version: ", major);
console.log("minor version: ", minor);
console.log("minor suffix: ", minorSuffix);

const newVersion = [
  patch,
  major,
  [minor + 1, minorSuffix].join("-")
].join(".")

console.log("new version: ", newVersion);

const packageJsonTextModded = editPackageJson.set(packageJson.text, "version", newVersion);

// console.log(packageJsonTextModded);

Deno.writeTextFileSync(packageJson.path, packageJsonTextModded);
