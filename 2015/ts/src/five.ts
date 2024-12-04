const alphabet = [
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
];

const vowels = ["a", "e", "i", "o", "u"];
const forbidden = ["ab", "cd", "pq", "xy"];

function partOne(input: string): number {
	return input.split("\n").filter((line) => {
		let numVowels = 0;
		let hasDouble = false;
		let hasForbidden = false;
		let i = 0;

		for (const c of line) {
			if (vowels.includes(c)) {
				numVowels++;
			}

			if (i < line.length - 1) {
				const next = line.at(i + 1);
				if (next === c) {
					hasDouble = true;
				}

				if (forbidden.includes(`${c}${next}`)) {
					hasForbidden = true;
					break;
				}
			}

			i++;
		}

		return numVowels >= 3 && hasDouble && !hasForbidden;
	}).length;
}

function partTwo(input: string): number {
	return input.split("\n").filter((line) => {
		const chars = line.split("");

		const hasDouble = alphabet.some((a) =>
			alphabet.some((b) => {
				let num = 0;
				let i = -2;

				while (true) {
					// increment of two to avoid overlapping doubles
					i = line.indexOf(`${a}${b}`, i + 2);

					if (i === -1) {
						break;
					}

					num++;
				}

				return num >= 2;
			}),
		);

		const hasWithMiddle = alphabet.some((a) =>
			chars.some((_, i) => {
				if (i === 0 || i === chars.length - 1) {
					return false;
				}

				if (chars[i - 1] === a && chars[i + 1] === a) {
					return true;
				}

				return false;
			}),
		);

		return hasDouble && hasWithMiddle;
	}).length;
}

export default {
	partOne,
	partTwo,
};
