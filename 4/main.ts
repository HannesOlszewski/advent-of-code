import fs from "fs";

interface Scratchcard {
  id: number;
  winningNumbers: number[];
  ownNumbers: number[];
  numPoints: number;
}

function calculatePoints(
  winningNumbers: number[],
  ownNumbers: number[]
): number {
  const matchingNumbers = ownNumbers.filter((n) => winningNumbers.includes(n));

  if (matchingNumbers.length === 0) {
    return 0;
  }

  return Math.pow(2, matchingNumbers.length - 1);
}

function parseInputLine(line: string): Scratchcard {
  const [idString, numbersString] = line.split(":");
  const id = parseInt(idString.split("Card ")[1], 10);
  const [winningNumbersString, ownNumbersString] = numbersString.split("|");
  const winningNumbers = winningNumbersString
    .split(" ")
    .map((n) => parseInt(n, 10))
    .filter((n) => !Number.isNaN(n));
  const ownNumbers = ownNumbersString
    .trim()
    .split(" ")
    .map((n) => parseInt(n, 10))
    .filter((n) => !Number.isNaN(n));
  const numPoints = calculatePoints(winningNumbers, ownNumbers);

  return {
    id,
    winningNumbers,
    ownNumbers,
    numPoints,
  };
}

function parseInput(lines: string[]): Scratchcard[] {
  return lines.map(parseInputLine);
}

const input = fs.readFileSync("input.txt", "utf8").split("\n");
const initialScratchcards = parseInput(input);
const totalPoints = initialScratchcards.reduce(
  (sum, scratchcard) => sum + scratchcard.numPoints,
  0
);

console.log(totalPoints);
