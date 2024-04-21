import fs from "fs";
import { dayOne } from "./1";
import { dayTwo } from "./2";
import { dayThree } from "./3";
import { dayFour } from "./4";
// import { dayFive } from "./5";
import { daySix } from "./6";
import { daySeven } from "./7";
import { dayEight } from "./8";
import { dayNine } from "./9";
import { dayTen } from "./10";
import { dayEleven } from "./11";
import { dayTwelve } from "./12";
import { dayThirteen } from "./13";

interface DayResult {
  day: number;
  partOne: number;
  partTwo: number;
  time: number;
}

function printAsTable(results: DayResult[]) {
  const dayHeaderLabel = "Day";
  const partOneHeaderLabel = "Part One";
  const partTwoHeaderLabel = "Part Two";
  const timeHeaderLabel = "Time (ms)";

  let maxDayCharLength = dayHeaderLabel.length;
  let maxPartOneCharLength = partOneHeaderLabel.length;
  let maxPartTwoCharLength = partTwoHeaderLabel.length;
  let maxTimeCharLength = timeHeaderLabel.length;

  for (const result of results) {
    maxDayCharLength = Math.max(maxDayCharLength, result.day.toString().length);
    maxPartOneCharLength = Math.max(
      maxPartOneCharLength,
      result.partOne.toString().length
    );
    maxPartTwoCharLength = Math.max(
      maxPartTwoCharLength,
      result.partTwo.toString().length
    );
    maxTimeCharLength = Math.max(
      maxTimeCharLength,
      result.time.toString().length
    );
  }

  const header = [
    dayHeaderLabel.padEnd(maxDayCharLength),
    partOneHeaderLabel.padEnd(maxPartOneCharLength),
    partTwoHeaderLabel.padEnd(maxPartTwoCharLength),
    timeHeaderLabel.padEnd(maxTimeCharLength),
  ].join(" | ");

  const separator = "-".repeat(header.length);

  console.log(header);
  console.log(separator);

  for (const result of results) {
    const row = [
      result.day.toString().padEnd(maxDayCharLength),
      result.partOne.toString().padEnd(maxPartOneCharLength),
      result.partTwo.toString().padEnd(maxPartTwoCharLength),
      result.time.toString().padEnd(maxTimeCharLength),
    ].join(" | ");

    console.log(row);
  }

  console.log(separator);
}

function main() {
  const availableDays = {
    1: dayOne,
    2: dayTwo,
    3: dayThree,
    4: dayFour,
    // 5: dayFive,
    6: daySix,
    7: daySeven,
    8: dayEight,
    9: dayNine,
    10: dayTen,
    11: dayEleven,
    12: dayTwelve,
    13: dayThirteen,
  };

  let days: string[];

  if (process.argv.length < 3) {
    days = Object.keys(availableDays);
  } else {
    days = process.argv.slice(2);
  }

  for (const day of days) {
    if (!availableDays[day]) {
      console.error(`Day ${day} is not available`);
      process.exit(1);
    }
  }

  const results = days.map((day) => {
    const input = fs.readFileSync(`${day}/input.txt`, "utf8");

    const startTime = Date.now();
    const result = availableDays[day](input);
    const endTime = Date.now();

    return {
      day: parseInt(day, 10),
      partOne: result[0],
      partTwo: result[1],
      time: endTime - startTime,
    };
  });

  printAsTable(results);
}

main();
