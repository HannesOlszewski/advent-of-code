interface NumberCell {
  value: number;
  row: number;
  columns: number[];
}

interface SymbolCell {
  value: string;
  row: number;
  column: number;
}

interface SymbolWithAdjacentNumbers {
  adjacentNumbers: NumberCell[];
  symbol: SymbolCell;
}

function parseNumberCellsFromInputRow(
  row: string,
  rowIndex: number
): NumberCell[] {
  const columns = row.split("");
  const numbers: NumberCell[] = [];
  let currentNumber: NumberCell | null = null;

  for (let columnIndex = 0; columnIndex < columns.length; columnIndex++) {
    const value = columns[columnIndex];
    const number = parseInt(value, 10);

    if (Number.isNaN(number)) {
      if (currentNumber !== null) {
        numbers.push(currentNumber);
        currentNumber = null;
      }

      continue;
    }

    if (currentNumber === null) {
      currentNumber = {
        value: number,
        row: rowIndex,
        columns: [columnIndex],
      };
    } else {
      currentNumber.value = currentNumber.value * 10 + number;
      currentNumber.columns.push(columnIndex);
    }

    if (columnIndex === columns.length - 1) {
      numbers.push(currentNumber);
      currentNumber = null;
    }
  }

  return numbers;
}

function parseSymbolCellsFromInputRow(
  row: string,
  rowIndex: number
): SymbolCell[] {
  const columns = row.split("");
  const symbols: SymbolCell[] = [];

  for (let columnIndex = 0; columnIndex < columns.length; columnIndex++) {
    const value = columns[columnIndex];
    const number = parseInt(value, 10);

    if (!Number.isNaN(number) || value === ".") {
      continue;
    }

    symbols.push({
      value,
      row: rowIndex,
      column: columnIndex,
    });
  }

  return symbols;
}

function hasAdjacentSymbol(number: NumberCell, symbols: SymbolCell[]): boolean {
  const adjacentSymbols = symbols.filter((symbol) => {
    const isUpperRow = symbol.row === number.row - 1;
    const isSameRow = symbol.row === number.row;
    const isLowerRow = symbol.row === number.row + 1;
    const isVerticalAdjacentColumn = number.columns.includes(symbol.column);
    const isHorizontalAdjacentColumn =
      number.columns.includes(symbol.column - 1) ||
      number.columns.includes(symbol.column + 1);

    const isTopCorner = isUpperRow && isHorizontalAdjacentColumn;
    const isBottomCorner = isLowerRow && isHorizontalAdjacentColumn;
    const isLeftOrRight = isSameRow && isHorizontalAdjacentColumn;
    const isTop = isUpperRow && isVerticalAdjacentColumn;
    const isBottom = isLowerRow && isVerticalAdjacentColumn;

    return isTopCorner || isBottomCorner || isLeftOrRight || isTop || isBottom;
  });

  return adjacentSymbols.length > 0;
}

function sumArray(array: number[]): number {
  return array.reduce((sum, number) => sum + number, 0);
}

function symbolWithAdjacentNumbers(
  symbol: SymbolCell,
  numbers: NumberCell[]
): SymbolWithAdjacentNumbers {
  const adjacentNumbers = numbers.filter((number) => {
    const isUpperRow = symbol.row === number.row - 1;
    const isSameRow = symbol.row === number.row;
    const isLowerRow = symbol.row === number.row + 1;
    const isVerticalAdjacentColumn = number.columns.includes(symbol.column);
    const isHorizontalAdjacentColumn =
      number.columns.includes(symbol.column - 1) ||
      number.columns.includes(symbol.column + 1);

    const isTopCorner = isUpperRow && isHorizontalAdjacentColumn;
    const isBottomCorner = isLowerRow && isHorizontalAdjacentColumn;
    const isLeftOrRight = isSameRow && isHorizontalAdjacentColumn;
    const isTop = isUpperRow && isVerticalAdjacentColumn;
    const isBottom = isLowerRow && isVerticalAdjacentColumn;

    return isTopCorner || isBottomCorner || isLeftOrRight || isTop || isBottom;
  });

  return { adjacentNumbers, symbol };
}

function isGear(symbol: SymbolWithAdjacentNumbers): boolean {
  return symbol.symbol.value === "*" && symbol.adjacentNumbers.length === 2;
}

export function partOne(input: string): number {
  const lines = input.split("\n");

  const parsedNumbers: NumberCell[] = lines.flatMap(
    parseNumberCellsFromInputRow
  );
  const parsedSymbols: SymbolCell[] = lines.flatMap(
    parseSymbolCellsFromInputRow
  );

  const numbersWithAdjacentSymbols = parsedNumbers.filter((number) =>
    hasAdjacentSymbol(number, parsedSymbols)
  );

  return sumArray(numbersWithAdjacentSymbols.map(({ value }) => value));
}

export function partTwo(input: string): number {
  const lines = input.split("\n");

  const parsedNumbers: NumberCell[] = lines.flatMap(
    parseNumberCellsFromInputRow
  );
  const parsedSymbols: SymbolCell[] = lines.flatMap(
    parseSymbolCellsFromInputRow
  );

  const symbolsWithAdjacentNumbers = parsedSymbols.map((symbol) =>
    symbolWithAdjacentNumbers(symbol, parsedNumbers)
  );

  const gears = symbolsWithAdjacentNumbers.filter(isGear);

  const gearRatios = gears.map(({ adjacentNumbers }) => {
    const [firstNumber, secondNumber] = adjacentNumbers;

    return firstNumber.value * secondNumber.value;
  });

  return sumArray(gearRatios);
}

export function dayThree(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
