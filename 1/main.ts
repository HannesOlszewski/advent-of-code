import fs from "fs";

const spelledNumbers = [
  "zero",
  "one",
  "two",
  "three",
  "four",
  "five",
  "six",
  "seven",
  "eight",
  "nine",
];

function parseNumbersFromInputLine(line: string): number[] {
  const numbers: number[] = [];

  for (let i = 0; i < line.length; i++) {
    const parsedNumber = parseInt(line.charAt(i), 10);

    if (!Number.isNaN(parsedNumber)) {
      numbers.push(parsedNumber);
    }

    for (const spelledNumber of spelledNumbers) {
      if (line.indexOf(spelledNumber, i) === i) {
        numbers.push(spelledNumbers.indexOf(spelledNumber));
      }
    }
  }

  return numbers;
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
