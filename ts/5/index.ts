import fs from "fs";

interface Range {
  rangeStart: number;
  rangeLength: number;
}

interface Mapping {
  targetStart: number;
  sourceStart: number;
  periodLength: number;
}

function parseSeeds(line: string): Range[] {
  if (!line.startsWith("seeds:")) {
    throw new Error("Invalid seeds line");
  }

  const values = line
    .split(" ")
    // Remove "seeds:"
    .slice(1);

  const ranges: Range[] = [];

  for (let i = 0; i < values.length; i += 2) {
    const rangeStart = parseInt(values[i]);
    const rangeLength = parseInt(values[i + 1]);

    ranges.push({ rangeStart, rangeLength });
  }

  return ranges;
}

function parseMaps(lines: string[]): Mapping[] {
  const mappings: Mapping[] = [];

  for (const line of lines) {
    if (line.length === 0) {
      continue;
    }

    const [targetStart, sourceStart, periodLength] = line.split(" ");

    mappings.push({
      targetStart: parseInt(targetStart),
      sourceStart: parseInt(sourceStart),
      periodLength: parseInt(periodLength),
    });
  }

  return mappings;
}

const sections = fs.readFileSync("input.txt", "utf8").split("\n\n");

const seeds = parseSeeds(sections[0]).sort(
  (a, b) => a.rangeStart - b.rangeStart
);
const mappings = sections
  .slice(1)
  .map((section) => parseMaps(section.split("\n").slice(1)))
  .sort((a, b) => a[0].targetStart - b[0].targetStart);

const currentTargets: Range[] = seeds;

for (const mapping of mappings) {
  const currentTargetsCopy = [...currentTargets];
  currentTargets.splice(0, currentTargets.length);

  for (const target of currentTargetsCopy) {
    const targetEnd = target.rangeStart + target.rangeLength;

    for (const map of mapping) {
      const sourceEnd = map.sourceStart + map.periodLength;

      if (target.rangeStart > sourceEnd || map.sourceStart > targetEnd) {
        continue;
      }

      // In case of partial match add the non-overlapped parts back to the list
      if (target.rangeStart < map.sourceStart) {
        currentTargets.push({
          rangeStart: target.rangeStart,
          rangeLength: map.sourceStart - target.rangeStart,
        });
      }

      if (targetEnd > sourceEnd) {
        currentTargets.push({
          rangeStart: sourceEnd,
          rangeLength: targetEnd - sourceEnd,
        });
      }

      // Add the overlapped part to the list
      const [offset, overlapStart] =
        map.sourceStart < target.rangeStart
          ? [target.rangeStart - map.sourceStart, target.rangeStart]
          : [0, map.sourceStart];
      const overlapRangeLength = Math.min(targetEnd, sourceEnd) - overlapStart;

      currentTargets.push({
        rangeStart: map.targetStart + offset,
        rangeLength: overlapRangeLength,
      });
      break;
    }

    // If no mapping found add the whole target to the list
    if (currentTargets.length === 0) {
      console.log("No mapping found for", target);
      currentTargets.push(target);
    }
  }
}

const lowest = Math.min(...currentTargets.map((t) => t.rangeStart));

console.log(lowest);

export function partOne(input: string): number {
  return 0;
}

export function partTwo(input: string): number {
  return 0;
}

export function dayFive(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
