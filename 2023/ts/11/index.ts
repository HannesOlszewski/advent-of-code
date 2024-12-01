interface Galaxy {
  id: number;
  x: number;
  y: number;
}

function parseInput(input: string): [Galaxy[], Set<number>, Set<number>] {
  const lines = input.split("\n");
  const galaxies: Galaxy[] = [];
  const emptyRows = new Set<number>();
  const emptyColumns = new Set<number>();

  for (let y = 0; y < lines.length; y++) {
    const line = lines[y];

    if (!emptyRows.has(y) && line.split("").every((char) => char === ".")) {
      emptyRows.add(y);
    }

    for (let x = 0; x < line.length; x++) {
      const char = line[x];

      if (char === ".") {
        if (!emptyColumns.has(x) && lines.every((line) => line[x] === ".")) {
          emptyColumns.add(x);
        }

        continue;
      }

      const id = galaxies.length + 1;
      galaxies.push({ id, x, y });
    }
  }

  return [galaxies, emptyRows, emptyColumns];
}

function getManhattanDistance(
  galaxyOne: Galaxy,
  galaxyTwo: Galaxy,
  emptyRows: Set<number>,
  emptyColumns: Set<number>,
  emptyCountsAs: number
): number {
  const higherX = Math.max(galaxyOne.x, galaxyTwo.x);
  const lowerX = Math.min(galaxyOne.x, galaxyTwo.x);
  const higherY = Math.max(galaxyOne.y, galaxyTwo.y);
  const lowerY = Math.min(galaxyOne.y, galaxyTwo.y);
  const numEmptyRowsBetween = Array.from(emptyRows).filter(
    (row) => row > lowerY && row < higherY
  ).length;
  const addedRows = numEmptyRowsBetween * (emptyCountsAs - 1);
  const numEmptyColumnsBetween = Array.from(emptyColumns).filter(
    (column) => column > lowerX && column < higherX
  ).length;
  const addedColumns = numEmptyColumnsBetween * (emptyCountsAs - 1);

  return higherX + addedColumns - lowerX + (higherY + addedRows) - lowerY;
}

function getClosestDistancesBetweenGalaxies(
  galaxies: Galaxy[],
  emptyRows: Set<number>,
  emptyColumns: Set<number>,
  emptyCountsAs: number
): number {
  return galaxies.reduce((acc, galaxy, index) => {
    return (
      acc +
      galaxies.slice(index + 1).reduce((galaxyAcc, otherGalaxy) => {
        if (galaxy.id === otherGalaxy.id) {
          return galaxyAcc;
        }

        return (
          galaxyAcc +
          getManhattanDistance(
            galaxy,
            otherGalaxy,
            emptyRows,
            emptyColumns,
            emptyCountsAs
          )
        );
      }, 0)
    );
  }, 0);
}

export function partOne(input: string): number {
  const [galaxies, emptyRows, emptyColumns] = parseInput(input);

  return getClosestDistancesBetweenGalaxies(
    galaxies,
    emptyRows,
    emptyColumns,
    2
  );
}

export function partTwo(
  input: string,
  emptyCountsAs: number = 1_000_000
): number {
  const [galaxies, emptyRows, emptyColumns] = parseInput(input);

  return getClosestDistancesBetweenGalaxies(
    galaxies,
    emptyRows,
    emptyColumns,
    emptyCountsAs
  );
}

export function dayEleven(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
