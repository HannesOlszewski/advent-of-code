import fs from "fs";

type Cell = {
  row: number;
  column: number;
  isDigit: boolean;
  isSymbol: boolean;
  value: number | string;
  adjacentSymbols: Cell[];
};

function parseInput(lines: string[]): Cell[][] {
  return lines.map((line, rowIndex) => {
    return line.split("").map((char, columnIndex) => {
      const parsedChar = parseInt(char, 10);
      const isDigit = !Number.isNaN(parsedChar);
      const isSymbol = Number.isNaN(parsedChar) && char !== ".";
      const value = isDigit ? parsedChar : char;

      return {
        row: rowIndex,
        column: columnIndex,
        isDigit,
        isSymbol,
        value,
        adjacentSymbols: [],
      };
    });
  });
}

function findAdjacedSymbol(cell: Cell, cells: Cell[][]): Cell[] {
  const result: Cell[] = [];
  const { row, column } = cell;

  const hasTop = row > 0;
  const hasBottom = row < cells.length - 1;
  const hasLeft = column > 0;
  const hasRight = column < cells[row].length - 1;

  // tl, t, tr
  //  l, c, r
  // bl, b, br

  // tl
  if (hasTop && hasLeft && cells[row - 1][column - 1].isSymbol) {
    result.push(cells[row - 1][column - 1]);
  }

  // t
  if (hasTop && cells[row - 1][column].isSymbol) {
    result.push(cells[row - 1][column]);
  }

  // tr
  if (hasTop && hasRight && cells[row - 1][column + 1].isSymbol) {
    result.push(cells[row - 1][column + 1]);
  }

  // l
  if (hasLeft && cells[row][column - 1].isSymbol) {
    result.push(cells[row][column - 1]);
  }

  // r
  if (hasRight && cells[row][column + 1].isSymbol) {
    result.push(cells[row][column + 1]);
  }

  // bl
  if (hasBottom && hasLeft && cells[row + 1][column - 1].isSymbol) {
    result.push(cells[row + 1][column - 1]);
  }

  // b
  if (hasBottom && cells[row + 1][column].isSymbol) {
    result.push(cells[row + 1][column]);
  }

  // br
  if (hasBottom && hasRight && cells[row + 1][column + 1].isSymbol) {
    result.push(cells[row + 1][column + 1]);
  }

  return result;
}

const input = fs.readFileSync("input.txt", "utf8").split("\n");
const schematic = parseInput(input);

schematic.forEach((row) => {
  row.forEach((cell) => {
    if (cell.isDigit) {
      const adjacedSymbols = findAdjacedSymbol(cell, schematic);
      cell.adjacentSymbols = adjacedSymbols;
    }
  });
});

const numbers: Cell[][] = schematic.flatMap((row) => {
  const numbersInRow: Cell[][] = [];
  let currentNumber: Cell[] = [];

  for (let i = 0; i < row.length; i++) {
    const cell = row[i];

    if (cell.isDigit) {
      currentNumber.push(cell);
    }

    const isLastCell = i === row.length - 1;

    if (currentNumber.length > 0 && (!cell.isDigit || isLastCell)) {
      numbersInRow.push(currentNumber);
      currentNumber = [];
    }
  }

  return numbersInRow;
});

const numbersWithAdjacedSymbols = numbers.filter((number) =>
  number.some((cell) => cell.adjacentSymbols.length > 0)
);
const numbersAsActualNumbers: number[] = numbersWithAdjacedSymbols.map(
  (number) => {
    return parseInt(number.map((cell) => cell.value).join(""), 10);
  }
);

const sumOfNumbers = numbersAsActualNumbers.reduce(
  (acc, number) => acc + number,
  0
);

console.log(sumOfNumbers);
