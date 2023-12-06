import fs from "fs";

interface Scratchcard {
  id: number;
  winningNumbers: number[];
  ownNumbers: number[];
  matchingNumbers: number[];
  numPoints: number;
}

function calculatePoints(matchingNumbers: number[]): number {
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
  const matchingNumbers = ownNumbers.filter((n) => winningNumbers.includes(n));
  const numPoints = calculatePoints(matchingNumbers);

  return {
    id,
    winningNumbers,
    ownNumbers,
    matchingNumbers,
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

const cardCounts: Record<number, number> = {};

initialScratchcards.forEach((scratchcard) => {
  if (scratchcard.id in cardCounts) {
    cardCounts[scratchcard.id]++;
  } else {
    cardCounts[scratchcard.id] = 1;
  }

  const numMatchingNumbers = scratchcard.matchingNumbers.length;

  for (let i = 1; i <= numMatchingNumbers; i++) {
    const cardId = scratchcard.id + i;

    if (cardId in cardCounts) {
      cardCounts[cardId] += cardCounts[scratchcard.id];
    } else {
      cardCounts[cardId] = cardCounts[scratchcard.id];
    }
  }
});

const totalNumCards = Object.values(cardCounts).reduce(
  (sum, count) => sum + count,
  0
);

console.log(totalPoints);
console.log(totalNumCards);
