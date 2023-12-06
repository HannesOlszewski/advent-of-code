import fs from "fs";

interface Mapping {
  seed: number;
  soil?: number;
  fertilizer?: number;
  water?: number;
  light?: number;
  temperature?: number;
  humidity?: number;
  location?: number;
}

type MappingType = keyof Mapping;

function parseSeeds(line: string): Mapping[] {
  if (!line.startsWith("seeds:")) {
    throw new Error("Invalid seeds line");
  }

  return line
    .split(" ")
    .slice(1)
    .map((seed) => ({ seed: parseInt(seed) }));
}

function parseMapsAndAddToExistingMappings(
  lines: string[],
  mappings: Mapping[]
): Mapping[] {
  let currentSource: MappingType | null = null;
  let currentDestination: MappingType | null = null;
  let mappingsCopy = mappings.slice();

  for (const line of lines) {
    if (line.length === 0) {
      if (currentSource !== null && currentDestination !== null) {
        mappingsCopy = mappingsCopy.map((mapping) => {
          if (
            mapping[currentDestination!] === undefined &&
            mapping[currentSource!] !== undefined
          ) {
            mapping[currentDestination!] = mapping[currentSource!]!;
          }

          return mapping;
        });
      }

      currentSource = null;
      currentDestination = null;
      continue;
    }

    if (line.endsWith("map:")) {
      const [left] = line.split(" ");
      [currentSource, currentDestination] = left.split("-to-") as MappingType[];
      continue;
    }

    if (currentSource === null || currentDestination === null) {
      throw new Error("Invalid mapping");
    }

    const [
      destinationPeriodStartString,
      sourcePeriodStartString,
      periodLengthString,
    ] = line.split(" ");

    const periodLength = parseInt(periodLengthString);
    const sourcePeriodStart = parseInt(sourcePeriodStartString);
    const sourcePeriodEnd = sourcePeriodStart + periodLength;
    const destinationPeriodStart = parseInt(destinationPeriodStartString);
    const destinationPeriodEnd = destinationPeriodStart + periodLength;

    mappingsCopy = mappingsCopy.map((mapping) => {
      const sourceValue = mapping[currentSource!]!;

      if (sourceValue >= sourcePeriodStart && sourceValue < sourcePeriodEnd) {
        const destinationValue =
          ((sourceValue - sourcePeriodStart) /
            (sourcePeriodEnd - sourcePeriodStart)) *
            (destinationPeriodEnd - destinationPeriodStart) +
          destinationPeriodStart;

        mapping[currentDestination!] = Math.round(destinationValue);
      }

      return mapping;
    });
  }

  if (currentSource !== null && currentDestination !== null) {
    mappingsCopy = mappingsCopy.map((mapping) => {
      if (
        mapping[currentDestination!] === undefined &&
        mapping[currentSource!] !== undefined
      ) {
        mapping[currentDestination!] = mapping[currentSource!]!;
      }

      return mapping;
    });
  }

  return mappingsCopy;
}

const input = fs.readFileSync("input.txt", "utf8").split("\n");

const mappings = parseSeeds(input[0]);
const allMappings = parseMapsAndAddToExistingMappings(input.slice(2), mappings);
const locations = allMappings.map((mapping) => mapping.location!);
const lowestLocation = Math.min(...locations);

console.log(lowestLocation);
