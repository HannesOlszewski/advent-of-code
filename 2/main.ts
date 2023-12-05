import fs from "fs";

type RevealedSet = {
  red: number;
  green: number;
  blue: number;
};

type Game = {
  id: number;
  revealedSets: RevealedSet[];
};

const bag: RevealedSet = {
  red: 12,
  green: 13,
  blue: 14,
};

function normalizeLine(line: string): string {
  return line.toLowerCase().trim().replace(" ", "").replace("game", "");
}

function parseGameIdFromLine(line: string): number {
  const normalizedLine = normalizeLine(line);
  const [id] = normalizedLine.split(":");

  return parseInt(id, 10);
}

function parseRevealedSet(revealedSetLinePart: string): RevealedSet {
  const normalizedLine = normalizeLine(revealedSetLinePart);
  const parts = normalizedLine.split(",");

  const result: RevealedSet = { red: 0, green: 0, blue: 0 };

  parts.forEach((part) => {
    if (part.includes("red")) {
      result.red = parseInt(part.replace("red", ""), 10);
    } else if (part.includes("green")) {
      result.green = parseInt(part.replace("green", ""), 10);
    } else if (part.includes("blue")) {
      result.blue = parseInt(part.replace("blue", ""), 10);
    }
  });

  return result;
}

function parseRevealedSetsFromLine(line: string): RevealedSet[] {
  const normalizedLine = normalizeLine(line);
  const [, revealedSetsLine] = normalizedLine.split(":");
  const revealedSetsLineParts = revealedSetsLine.split(";");

  return revealedSetsLineParts.map(parseRevealedSet);
}

function parseInputLine(line: string): Game {
  const normalizedLine = normalizeLine(line);
  const id = parseGameIdFromLine(normalizedLine);
  const revealedSets = parseRevealedSetsFromLine(normalizedLine);

  return {
    id,
    revealedSets,
  };
}

function parseInput(input: string[]): Game[] {
  return input.map(parseInputLine);
}

const input = fs.readFileSync("input.txt", "utf8").split("\n");

const games = parseInput(input);
const possibleGames = games.filter((game) =>
  game.revealedSets.every(
    (revealedSet) =>
      revealedSet.red <= bag.red &&
      revealedSet.green <= bag.green &&
      revealedSet.blue <= bag.blue
  )
);
const sumOfIds = possibleGames.reduce((acc, game) => acc + game.id, 0);

console.log(`Games: ${games.length}`);
console.log(`Possible games: ${possibleGames.length}`);
console.log(`Sum of ids: ${sumOfIds}`);
