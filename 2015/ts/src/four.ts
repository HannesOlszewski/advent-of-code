function partOne(input: string): number {
	const str = input.trim();
	const hasher = new Bun.CryptoHasher("md5");

	let i = 0;
	while (true) {
		i++;
		const hash = hasher.update(`${str}${i}`).digest("hex");

		if (hash.startsWith("00000")) {
			break;
		}
	}

	return i;
}

function partTwo(input: string): number {
	const str = input.trim();
	const hasher = new Bun.CryptoHasher("md5");

	let i = 0;
	while (true) {
		i++;
		const hash = hasher.update(`${str}${i}`).digest("hex");

		if (hash.startsWith("000000")) {
			break;
		}
	}

	return i;
}

export default {
	partOne,
	partTwo,
};
