function partOne(input: string): number {
	let x = 0;
	let y = 0;
	const visited: Record<string, boolean> = { "0-0": true };

	for (const move of input) {
		if (move === ">") {
			x++;
		}
		if (move === "<") {
			x--;
		}
		if (move === "^") {
			y++;
		}
		if (move === "v") {
			y--;
		}

		const house = `${x}-${y}`;
		visited[house] = true;
	}

	return Object.keys(visited).length;
}

function partTwo(input: string): number {
	const locations = [
		{ x: 0, y: 0 },
		{ x: 0, y: 0 },
	];
	let turn = 0;
	const visited: Record<string, boolean> = { "0-0": true };

	for (const move of input) {
		if (move === ">") {
			locations[turn].x++;
		}
		if (move === "<") {
			locations[turn].x--;
		}
		if (move === "^") {
			locations[turn].y++;
		}
		if (move === "v") {
			locations[turn].y--;
		}

		const house = `${locations[turn].x}-${locations[turn].y}`;
		visited[house] = true;
		turn = (turn + 1) % 2;
	}

	return Object.keys(visited).length;
}

export default {
	partOne,
	partTwo,
};
