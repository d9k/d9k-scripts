#!/bin/env deno

// https://github.com/ortex/snils-generator/blob/master/src/App.js

function generateSnils() {
  const rnd = Math.floor(Math.random() * 999999999)
  const number = leftPad('' + rnd, 9, '0')

  let sum = number
    .split('')
    .map((val, i) => parseInt(val) * (9 - i))
    .reduce((a, b) => a + b)

  if (sum > 101) {
    sum = sum % 101
  }

  const checkSum = sum == 100 || sum == 101 ? '00' : leftPad('' + sum, 2, '0')
  return number + checkSum
}

function leftPad(str, len, ch) {
  const length = len - str.length + 1
  return length > 0 ? new Array(length).join(ch) + str : str
}

function mask(num) {
  return `${num.substr(0, 3)} ${num.substr(3, 3)} ${num.substr(6, 3)} ${num.substr(9)}`
}

const randomSnils = generateSnils();
console.log(randomSnils);
