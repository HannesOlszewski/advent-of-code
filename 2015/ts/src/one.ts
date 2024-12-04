function partOne(input: string): number {
	let floor = 0;

	for (const c of input) {
		if (c === "(") {
			floor++;
		} else if (c === ")") {
			floor--;
		}
	}

	return floor;
}

function partTwo(input: string): number {
	let floor = 0;
	let position = 1;

	for (const c of input) {
		if (c === "(") {
			floor++;
		} else if (c === ")") {
			floor--;
		}

		if (floor === -1) {
			return position;
		}

		position++;
	}

	return floor;
}

export default {
	partOne,
	partTwo,
};
