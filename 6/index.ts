interface RaceInput {
  time: number;
  distance: number;
}

function parseLine(line: string, ignoreWhitespace: boolean = false): number[] {
  if (ignoreWhitespace) {
    return line
      .split(" ")
      .filter((x) => x !== "")
      .join("")
      .split(":")
      .map((x) => parseInt(x, 10))
      .filter((x) => !isNaN(x));
  }

  return line
    .split(" ")
    .map((x) => parseInt(x, 10))
    .filter((x) => !isNaN(x));
}

function parseInput(
  input: string,
  ignoreWhitespace: boolean = false
): RaceInput[] {
  const [timesLine, distancesLine] = input.split("\n");
  const times = parseLine(timesLine, ignoreWhitespace);
  const distances = parseLine(distancesLine, ignoreWhitespace);

  return times.map((time, index) => ({ time, distance: distances[index] }));
}

function possibleSecondsToHoldToWinRace(raceInput: RaceInput): number[] {
  const { time, distance } = raceInput;
  const secondsToHold: number[] = [];

  for (let seconds = 0; seconds < time; seconds++) {
    const speed = seconds;

    if (speed * (time - seconds) > distance) {
      secondsToHold.push(seconds);
    }
  }

  return secondsToHold;
}

export function partOne(input: string): number {
  const raceInputs = parseInput(input);
  const possibleSecondsToHold = raceInputs.map(possibleSecondsToHoldToWinRace);
  const numberOfWaysToBeatRecord = possibleSecondsToHold.map((x) => x.length);

  return numberOfWaysToBeatRecord.reduce((a, b) => a * b, 1);
}

export function partTwo(input: string): number {
  const raceInputs = parseInput(input, true);
  const possibleSecondsToHold = raceInputs.map(possibleSecondsToHoldToWinRace);
  const numberOfWaysToBeatRecord = possibleSecondsToHold.map((x) => x.length);

  return numberOfWaysToBeatRecord.reduce((a, b) => a * b, 1);
}

export function daySix(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
