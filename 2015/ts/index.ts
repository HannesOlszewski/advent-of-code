import one from "./src/one";

type Day = {
	file: string;
	partOne: (input: string) => number;
	partTwo: (input: string) => number;
};

type Result = {
	"Result One": number;
	"Time One (ms)": number;
	"Result Two": number;
	"Time Two (ms)": number;
};

const days: Day[] = [{ file: "../inputs/one.txt", ...one }];
const results: { [key: string | number]: Result } = {};

for (const day of days) {
	const file = Bun.file(day.file);
	const input = await file.text();

	const start = Date.now();
	const resultOne = day.partOne(input);
	const mid = Date.now();
	const resultTwo = day.partTwo(input);
	const end = Date.now();

	results[days.indexOf(day) + 1] = {
		"Result One": resultOne,
		"Time One (ms)": mid - start,
		"Result Two": resultTwo,
		"Time Two (ms)": end - mid,
	};
}

console.table(results);
