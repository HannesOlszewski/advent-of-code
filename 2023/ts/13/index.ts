function findVerticalLineReflection(section: string[]): number {
  const numColumns = section[0].length;
  let leftColumnIndex = Math.floor(numColumns / 2);
  // const reflectableColumnCount = Math.min(
  //   leftColumnIndex,
  //   numColumns - (leftColumnIndex + 1)
  // );
  let i = 1;

  while (leftColumnIndex > 0 && leftColumnIndex < numColumns) {
    const rightColumnIndex = leftColumnIndex + 1;
    const reflectableColumnCount = Math.min(
      leftColumnIndex,
      numColumns - rightColumnIndex
    );

    const isReflection = section.every((row) => {
      for (let j = 0; j < reflectableColumnCount; j++) {
        if (row[leftColumnIndex - j] !== row[rightColumnIndex + j]) {
          return false;
        }
      }

      return true;
    });

    if (isReflection && reflectableColumnCount > 0) {
      return leftColumnIndex;
    }

    leftColumnIndex += i;

    i *= -1;

    if (i > 0) {
      i++;
    } else {
      i--;
    }
  }

  return -1;
}

function findHorizontalLineReflection(section: string[]): number {
  const numRows = section.length;
  let topRowIndex = Math.floor(numRows / 2);
  // const reflectableRowCount = Math.min(
  //   topRowIndex,
  //   numRows - (topRowIndex + 1)
  // );
  let i = 1;

  while (topRowIndex > 0 && topRowIndex < numRows) {
    const bottomRowIndex = topRowIndex + 1;
    const reflectableRowCount = Math.min(topRowIndex, numRows - bottomRowIndex);
    let isReflection = reflectableRowCount > 0;

    for (let j = 0; j < reflectableRowCount; j++) {
      const topRow = section[topRowIndex - j];
      const bottomRow = section[bottomRowIndex + j];

      if (topRow !== bottomRow) {
        isReflection = false;
        break;
      }
    }

    if (isReflection) {
      return topRowIndex;
    }

    topRowIndex += i;

    i *= -1;

    if (i > 0) {
      i++;
    } else {
      i--;
    }
  }

  return -1;
}

function sum(array: number[]): number {
  return array.reduce((sum, value) => sum + value, 0);
}

export function partOne(input: string): number {
  const sections = input.split("\n\n");
  const verticalReflectionLines = sections.map((section) => {
    const rows = section.split("\n");

    return findVerticalLineReflection(rows) + 1;
  });
  // .filter((line) => line > 0);
  const horizontalReflectionLines = sections.map((section) => {
    const rows = section.split("\n");

    return findHorizontalLineReflection(rows) + 1;
  });
  // .filter((line) => line > 0);

  console.log(verticalReflectionLines, horizontalReflectionLines);

  return sum(verticalReflectionLines) + sum(horizontalReflectionLines) * 100;
}

export function partTwo(input: string): number {
  return 0;
}

export function dayThirteen(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
