import fs from "fs";
import path from "path";

const daysAsStrings = [
  "One",
  "Two",
  "Three",
  "Four",
  "Five",
  "Six",
  "Seven",
  "Eight",
  "Nine",
  "Ten",
  "Eleven",
  "Twelve",
  "Thirteen",
  "Fourteen",
  "Fifteen",
  "Sixteen",
  "Seventeen",
  "Eightteen",
  "Nineteen",
  "Twenty",
  "Twentyone",
  "Twentytwo",
  "Twentythree",
  "Twentyfour",
];

const day = process.argv[2];

if (!day || isNaN(parseInt(day)) || parseInt(day) < 1 || parseInt(day) > 24) {
  console.log("Please provide a day number between 1 and 24");
  process.exit(1);
}

const dayNumber = parseInt(day);
const dayString = daysAsStrings[dayNumber - 1];

const utilPath = __dirname;
const utilIndexTemplatePath = path.join(utilPath, "index.template.ts");
const utilTestTemplatePath = path.join(utilPath, "test.template.ts");

const dayPath = path.join(path.dirname(__dirname), dayNumber.toString());
const dayInputPath = path.join(dayPath, "input.txt");
const dayIndexPath = path.join(dayPath, "index.ts");
const dayTestPath = path.join(dayPath, "index.test.ts");

if (!fs.existsSync(dayPath)) {
  fs.mkdirSync(dayPath);
}

fs.writeFileSync(
  dayIndexPath,
  fs.readFileSync(utilIndexTemplatePath, "utf-8").replace(/DAY/g, dayString)
);

fs.writeFileSync(
  dayTestPath,
  fs.readFileSync(utilTestTemplatePath, "utf-8").replace(/DAY/g, dayString)
);

fs.writeFileSync(dayInputPath, "");

// add import to main.ts
const mainPath = path.join(path.dirname(__dirname), "main.ts");
const mainContent = fs.readFileSync(mainPath, "utf-8");
const mainLines = mainContent.split("\n");
const mainFirstImportLine = mainLines.findIndex((line) =>
  line.includes("import")
);
const mainImportLines = mainLines.filter((line) => line.includes("import"));
const mainImport = `import { day${dayString} } from "./${dayNumber}";`;

if (!mainImportLines.includes(mainImport)) {
  mainLines.splice(mainFirstImportLine + mainImportLines.length, 0, mainImport);
}

// add day to availableDays in main() in main.ts
const mainAvailableDaysLine = mainLines.findIndex((line) =>
  line.includes("const availableDays = {")
);
const mainAvailableDaysEnd = mainLines.findIndex(
  (line, index) => index > mainAvailableDaysLine && line.includes("};")
);
const mainAvailableDays = `    ${dayNumber}: day${dayString},`;
mainLines.splice(mainAvailableDaysEnd, 0, mainAvailableDays);

fs.writeFileSync(mainPath, mainLines.join("\n"));

console.log(`Day ${dayNumber} initialised!`);
