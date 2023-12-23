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

export function partOne(input: string): number {
  const games = parseInput(input.split("\n"));

  const possibleGames = games.filter((game) =>
    game.revealedSets.every(
      (revealedSet) =>
        revealedSet.red <= bag.red &&
        revealedSet.green <= bag.green &&
        revealedSet.blue <= bag.blue
    )
  );

  return possibleGames.reduce((acc, game) => acc + game.id, 0);
}

export function partTwo(input: string): number {
  const games = parseInput(input.split("\n"));

  const minimalBagsPerGame = games.map((game) =>
    game.revealedSets.reduce(
      (acc, revealedSet) => ({
        red: Math.max(acc.red, revealedSet.red),
        green: Math.max(acc.green, revealedSet.green),
        blue: Math.max(acc.blue, revealedSet.blue),
      }),
      { red: 0, green: 0, blue: 0 }
    )
  );

  const powers = minimalBagsPerGame.map(
    (minimalBag) => minimalBag.red * minimalBag.green * minimalBag.blue
  );

  return powers.reduce((acc, power) => acc + power, 0);
}

export function dayTwo(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
