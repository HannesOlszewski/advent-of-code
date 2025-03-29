function partOne(input: string): number {
  const str = input.trim();
  const hasher = new Bun.CryptoHasher("md5");
  const result = new Uint8Array(64);

  let i = 1;
  while (true) {
    i++;
    hasher.update(`${str}${i}`);
    const hash = hasher.digest(result);

    if (hash[0] === 0 && hash[1] === 0 && hash[2] <= 15) {
      break;
    }
  }

  return i;
}

function partTwo(input: string): number {
  const str = input.trim();
  const hasher = new Bun.CryptoHasher("md5");
  const result = new Uint8Array(64);

  let i = 1;
  while (true) {
    i++;
    hasher.update(`${str}${i}`);
    const hash = hasher.digest(result);

    if (hash[0] === 0 && hash[1] === 0 && hash[2] === 0) {
      break;
    }
  }

  return i;
}

export default {
  partOne,
  partTwo,
};
