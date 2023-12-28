interface Galaxy {
  id: number;
  x: number;
  y: number;
}

function expandInput(input: string): string {
  const lines = input.split("\n");

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    if (line.split("").every((char) => char === ".")) {
      lines.splice(i, 0, line);
      i++;
    }
  }

  for (let i = 0; i < lines[0].length; i++) {
    if (lines.every((line) => line[i] === ".")) {
      lines.forEach((line, index) => {
        lines[index] = line.slice(0, i) + "." + line.slice(i);
      });

      i++;
    }
  }

  return lines.join("\n");
}

function parseInput(input: string): Galaxy[] {
  const lines = input.split("\n");
  const galaxies: Galaxy[] = [];

  for (let y = 0; y < lines.length; y++) {
    const line = lines[y];
    for (let x = 0; x < line.length; x++) {
      const char = line[x];

      if (char === ".") {
        continue;
      }

      const id = galaxies.length + 1;
      galaxies.push({ id, x, y });
    }
  }

  return galaxies;
}

export function partOne(input: string): number {
  const expandedInput = expandInput(input);
  const galaxies = parseInput(expandedInput);

  return galaxies.reduce((acc, galaxy, index) => {
    return (
      acc +
      galaxies.slice(index + 1).reduce((galaxyAcc, otherGalaxy) => {
        if (galaxy.id === otherGalaxy.id) {
          return galaxyAcc;
        }

        const higherX = Math.max(galaxy.x, otherGalaxy.x);
        const lowerX = Math.min(galaxy.x, otherGalaxy.x);
        const higherY = Math.max(galaxy.y, otherGalaxy.y);
        const lowerY = Math.min(galaxy.y, otherGalaxy.y);

        return galaxyAcc + (higherX - lowerX) + (higherY - lowerY);
      }, 0)
    );
  }, 0);
}

export function partTwo(input: string): number {
  return 0;
}

export function dayEleven(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
