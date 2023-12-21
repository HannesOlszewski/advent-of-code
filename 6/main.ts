import fs from "fs";

interface RaceInput {
  time: number;
  distance: number;
}

function parseLine(line: string): number[] {
  return line
    .split(" ")
    .filter((x) => x !== "")
    .join("")
    .split(":")
    .map((x) => parseInt(x, 10))
    .filter((x) => !isNaN(x));
}

function parseInput(input: string): RaceInput[] {
  const [timesLine, distancesLine] = input.split("\n");
  const times = parseLine(timesLine);
  const distances = parseLine(distancesLine);

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

const input = fs.readFileSync("input.txt", "utf8");

const raceInputs = parseInput(input);
const possibleSecondsToHold = raceInputs.map(possibleSecondsToHoldToWinRace);
const numberOfWaysToBeatRecord = possibleSecondsToHold.map((x) => x.length);
const marginOfError = numberOfWaysToBeatRecord.reduce((a, b) => a * b, 1);

console.log(marginOfError);
