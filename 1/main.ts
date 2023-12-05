import fs from "fs";

function parseNumbersFromInputLine(line: string): number[] {
  return line
    .split("")
    .map((num) => parseInt(num, 10))
    .filter((num) => !Number.isNaN(num));
}

function getTwoDigitNumberFromInputLine(line: string): number {
  const numbers = parseNumbersFromInputLine(line);
  const firstDigit = numbers[0];
  const lastDigit = numbers[numbers.length - 1];

  return firstDigit * 10 + lastDigit;
}

function transformInputLinesToTwoDigitNumbers(input: string[]): number[] {
  return input.map(getTwoDigitNumberFromInputLine);
}

function calculateOutputSum(input: string[]): number {
  const numbers = transformInputLinesToTwoDigitNumbers(input);

  return numbers.reduce((sum, number) => sum + number, 0);
}

const input = fs.readFileSync("input.txt", "utf8").split("\n");

const output = calculateOutputSum(input);

console.log(output);
