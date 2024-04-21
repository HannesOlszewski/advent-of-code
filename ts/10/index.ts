type Pipe = "|" | "-" | "L" | "J" | "7" | "F";

type CellType = Pipe | "." | "S";

type Direction = "up" | "right" | "down" | "left";

type Cell = {
  type: CellType;
  x: number;
  y: number;
  connections: Record<Direction, boolean>;
};

type Grid = Cell[][];

type LoopCell = {
  type: CellType;
  x: number;
  y: number;
  connections: Record<Direction, boolean>;
  stepsFromStart: number;
};

function findConnections(cellType: CellType): Record<Direction, boolean> {
  const connections: Record<Direction, boolean> = {
    up: false,
    right: false,
    down: false,
    left: false,
  };

  if (cellType === "S") {
    connections.up = true;
    connections.right = true;
    connections.down = true;
    connections.left = true;
  } else if (cellType === "7") {
    connections.down = true;
    connections.left = true;
  } else if (cellType === "F") {
    connections.right = true;
    connections.down = true;
  } else if (cellType === "J") {
    connections.up = true;
    connections.left = true;
  } else if (cellType === "L") {
    connections.up = true;
    connections.right = true;
  } else if (cellType === "-") {
    connections.right = true;
    connections.left = true;
  } else if (cellType === "|") {
    connections.up = true;
    connections.down = true;
  }

  return connections;
}

function parseInput(input: string): Grid {
  const rows = input.split("\n");
  const grid: Grid = [];

  for (let y = 0; y < rows.length; y++) {
    const row = rows[y];
    grid[y] = [];

    for (let x = 0; x < row.length; x++) {
      const cellType = row.charAt(x) as CellType;

      const cell: Cell = {
        type: cellType,
        x,
        y,
        connections: findConnections(cellType),
      };

      grid[y][x] = cell;
    }
  }

  return grid;
}

function findStartCell(grid: Grid): Cell {
  return grid
    .map((row) => row.find((cell) => cell.type === "S"))
    .find((cell) => cell !== undefined)!;
}

// visit cells recursively, marking them as visited
// if we find a cell that has already been visited, we've found a loop
function findLoop(grid: Grid, startCell: Cell): LoopCell[] {
  const loop: LoopCell[] = [];
  const visited: Record<string, boolean> = {};

  // TODO: only visit first available connection
  function visit(cell: Cell, stepsFromStart: number): void {
    const key = `${cell.x},${cell.y}`;

    visited[key] = true;

    const up = grid[cell.y - 1] && grid[cell.y - 1][cell.x];
    const right = grid[cell.y][cell.x + 1];
    const down = grid[cell.y + 1] && grid[cell.y + 1][cell.x];
    const left = grid[cell.y][cell.x - 1];

    const canVisitUp =
      up &&
      cell.connections.up &&
      (!visited[`${up.x},${up.y}`] ||
        (up.type === "S" && stepsFromStart > 1)) &&
      up.connections.down;
    const canVisitRight =
      right &&
      cell.connections.right &&
      (!visited[`${right.x},${right.y}`] ||
        (right.type === "S" && stepsFromStart > 1)) &&
      right.connections.left;
    const canVisitDown =
      down &&
      cell.connections.down &&
      (!visited[`${down.x},${down.y}`] ||
        (down.type === "S" && stepsFromStart > 1)) &&
      down.connections.up;
    const canVisitLeft =
      left &&
      cell.connections.left &&
      (!visited[`${left.x},${left.y}`] ||
        (left.type === "S" && stepsFromStart > 1)) &&
      left.connections.right;

    if (canVisitUp && up.type) {
      visit(up, stepsFromStart + 1);
    } else if (canVisitRight) {
      visit(right, stepsFromStart + 1);
    } else if (canVisitDown) {
      visit(down, stepsFromStart + 1);
    } else if (canVisitLeft) {
      visit(left, stepsFromStart + 1);
    } else {
      return;
    }

    if (cell.type !== "S") {
      loop.push({
        ...cell,
        stepsFromStart,
      });
    } else if (stepsFromStart === 0) {
      loop.push({
        ...cell,
        stepsFromStart,
      });
    }
  }

  visit(startCell, 0);

  return loop.reverse();
}

export function partOne(input: string): number {
  const grid = parseInput(input);
  const startCell = findStartCell(grid);
  const loop = findLoop(grid, startCell);

  return loop.length / 2;
}

export function partTwo(input: string): number {
  return 0;
}

export function dayTen(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
