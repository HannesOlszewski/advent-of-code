function partOne(input: string): number {
  const lights: boolean[][] = [];

  for (let i = 0; i < 1000; i++) {
    const row: boolean[] = [];

    for (let j = 0; j < 1000; j++) {
      row.push(false);
    }

    lights.push(row);
  }

  for (const line of input.split("\n")) {
    const parts = line.split(" ");

    if (parts.length === 4) {
      const [startX, startY] = parts[1]
        .split(",")
        .map((n) => Number.parseInt(n, 10));
      const [endX, endY] = parts[3]
        .split(",")
        .map((n) => Number.parseInt(n, 10));

      for (let x = startX; x <= endX; x++) {
        for (let y = startY; y <= endY; y++) {
          lights[y][x] = !lights[y][x];
        }
      }
    } else if (parts.length === 5) {
      const [startX, startY] = parts[2]
        .split(",")
        .map((n) => Number.parseInt(n, 10));
      const [endX, endY] = parts[4]
        .split(",")
        .map((n) => Number.parseInt(n, 10));

      for (let x = startX; x <= endX; x++) {
        for (let y = startY; y <= endY; y++) {
          lights[y][x] = parts[1] === "on";
        }
      }
    }
  }

  return lights
    .map((row) => row.map(Number).reduce((prev, curr) => prev + curr, 0))
    .reduce((prev, curr) => prev + curr, 0);
}

function partTwo(input: string): number {
  const lights: number[][] = [];

  for (let i = 0; i < 1000; i++) {
    const row: number[] = [];

    for (let j = 0; j < 1000; j++) {
      row.push(0);
    }

    lights.push(row);
  }

  for (const line of input.split("\n")) {
    const parts = line.split(" ");

    if (parts.length === 4) {
      const [startX, startY] = parts[1]
        .split(",")
        .map((n) => Number.parseInt(n, 10));
      const [endX, endY] = parts[3]
        .split(",")
        .map((n) => Number.parseInt(n, 10));

      for (let x = startX; x <= endX; x++) {
        for (let y = startY; y <= endY; y++) {
          lights[y][x] += 2;
        }
      }
    } else if (parts.length === 5) {
      const [startX, startY] = parts[2]
        .split(",")
        .map((n) => Number.parseInt(n, 10));
      const [endX, endY] = parts[4]
        .split(",")
        .map((n) => Number.parseInt(n, 10));

      for (let x = startX; x <= endX; x++) {
        for (let y = startY; y <= endY; y++) {
          if (parts[1] === "on") {
            lights[y][x] += 1;
          } else if (lights[y][x] > 0) {
            lights[y][x] -= 1;
          }
        }
      }
    }
  }

  return lights
    .map((row) => row.map(Number).reduce((prev, curr) => prev + curr, 0))
    .reduce((prev, curr) => prev + curr, 0);
}

export default {
  partOne,
  partTwo,
};
