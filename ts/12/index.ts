type Damaged = "#";
type Operational = ".";
type Unknown = "?";
type SpringStatus = Damaged | Operational | Unknown;

interface Record {
  readings: SpringStatus[];
  damagedGroups: number[];
  numUnknown: number;
}

function parseInput(input: string): Record[] {
  return input.split("\n").map((line) => {
    const [readings, damagedGroups] = line.split(" ");

    return {
      readings: readings.split("") as SpringStatus[],
      damagedGroups: damagedGroups
        .split(",")
        .map((group) => parseInt(group, 10)),
      numUnknown: readings.split("").filter((char) => char === "?").length,
    };
  });
}

function isValidReadingList(
  readings: SpringStatus[],
  damagedGroups: number[]
): boolean {
  let numDamaged = 0;
  let damagedGroupsFromReadings: number[] = [];

  for (let i = 0; i < readings.length; i++) {
    const reading = readings[i];

    if (reading === "?") {
      return false;
    }

    if (reading === "#") {
      numDamaged++;
    } else if (reading === "." && numDamaged > 0) {
      damagedGroupsFromReadings.push(numDamaged);
      numDamaged = 0;
    }
  }

  if (numDamaged > 0) {
    damagedGroupsFromReadings.push(numDamaged);
  }

  return (
    damagedGroupsFromReadings.length === damagedGroups.length &&
    damagedGroupsFromReadings.every(
      (group, index) => group === damagedGroups[index]
    )
  );
}

function getPossibleReadings(record: Record): SpringStatus[][] {
  const possibleReadings: Set<string> = new Set();
  const possibleArrangements = Math.pow(2, record.numUnknown);

  // permutate unknowns
  for (let i = 0; i < possibleArrangements; i++) {
    const binary = i.toString(2).padStart(record.numUnknown, "0");
    const possibleReading = record.readings.map((reading) => reading);

    for (let j = 0; j < binary.length; j++) {
      const unknownIndex = possibleReading.findIndex(
        (reading) => reading === "?"
      );
      possibleReading[unknownIndex] = binary[j] === "0" ? "." : "#";
    }

    if (
      isValidReadingList(possibleReading, record.damagedGroups) &&
      !possibleReadings.has(possibleReading.join(""))
    ) {
      possibleReadings.add(possibleReading.join(""));
    }
  }

  return Array.from(possibleReadings).map(
    (reading) => reading.split("") as SpringStatus[]
  );
}

export function partOne(input: string): number {
  const records = parseInput(input);
  const possibleReadings = records.map(getPossibleReadings);

  return possibleReadings.reduce(
    (total, readings) => total + readings.length,
    0
  );
}

export function partTwo(input: string): number {
  return 0;
}

export function dayTwelve(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
