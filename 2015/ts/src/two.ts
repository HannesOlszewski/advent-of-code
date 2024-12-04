function partOne(input: string): number {
	return input
		.split("\n")
		.map((line) => {
			if (line.length === 0) {
				return 0;
			}

			const [l, w, h] = line.split("x").map((x) => Number.parseInt(x, 10));
			const sideA = l * w;
			const sideB = w * h;
			const sideC = h * l;

			return 2 * sideA + 2 * sideB + 2 * sideC + Math.min(sideA, sideB, sideC);
		})
		.reduce((prev, curr) => prev + curr, 0);
}

function partTwo(input: string): number {
	return input
		.split("\n")
		.map((line) => {
			if (line.length === 0) {
				return 0;
			}

			const [a, b, c] = line
				.split("x")
				.map((x) => Number.parseInt(x, 10))
				.toSorted((x, y) => x - y);

			return a + a + b + b + a * b * c;
		})
		.reduce((prev, curr) => prev + curr, 0);
}

export default {
	partOne,
	partTwo,
};
