type Instruction = "L" | "R";

type Node = Record<Instruction, string>;

interface Input {
  instructions: Instruction[];
  nodes: Record<string, Node>;
}

function parseInput(input: string): Input {
  const [instructions, ...nodes] = input.split("\n");

  return {
    instructions: instructions.split("") as Instruction[],
    nodes: nodes.slice(1).reduce((acc, node) => {
      const [name, rest] = node.split(" = ");
      const [left, right] = rest.slice(1, -1).split(", ");

      return {
        ...acc,
        [name]: {
          L: left,
          R: right,
        },
      };
    }, {}),
  };
}

function countStepsTillEnd(
  start: string,
  end: string,
  nodes: Record<string, Node>,
  instructions: Instruction[]
): number {
  let currentNode = start;
  let steps = 0;

  while (currentNode !== end) {
    const nextNode =
      nodes[currentNode][instructions[steps % instructions.length]];

    currentNode = nextNode;
    steps++;
  }

  return steps;
}

function isPrime(number: number): boolean {
  if (number <= 1) {
    return false;
  }

  if (number <= 3) {
    return true;
  }

  if (number % 2 === 0 || number % 3 === 0) {
    return false;
  }

  for (let i = 5; i * i <= number; i = i + 6) {
    if (number % i === 0 || number % (i + 2) === 0) {
      return false;
    }
  }

  return true;
}

function calculateLcm(numbers: number[]): number {
  let divisor: number = 0;
  let i = 1;

  while (divisor === 0) {
    if (isPrime(i)) {
      for (const number of numbers) {
        if (number % i === 0) {
          divisor = number / i;
        }
      }
    }

    i++;
  }

  const primes = numbers.map((number) => number / divisor);

  return primes.reduce((acc, prime) => acc * prime, divisor);
}

function countStepsTillEndParallel(
  start: string[],
  isEnd: (node: string) => boolean,
  nodes: Record<string, Node>,
  instructions: Instruction[]
): number {
  let currentNodes = start;
  let steps = 0;
  let firstEndReached: { node: string; endAtStep: number }[] = start.map(
    (node) => ({
      node,
      endAtStep: 0,
    })
  );

  while (firstEndReached.some((end) => end.endAtStep === 0)) {
    const nextNodes = currentNodes.map((node) => {
      return nodes[node][instructions[steps % instructions.length]];
    });

    nextNodes.forEach((node, index) => {
      if (isEnd(node) && firstEndReached[index].endAtStep === 0) {
        firstEndReached[index].endAtStep = steps + 1;
      }
    });

    currentNodes = nextNodes;
    steps++;
  }

  const firstEndReachedSteps = firstEndReached.map((end) => end.endAtStep);

  return calculateLcm(firstEndReachedSteps);
}

export function partOne(input: string): number {
  const { instructions, nodes } = parseInput(input);

  return countStepsTillEnd("AAA", "ZZZ", nodes, instructions);
}

export function partTwo(input: string): number {
  const { instructions, nodes } = parseInput(input);

  const startNodes = Object.keys(nodes).filter((node) => node.endsWith("A"));
  const isEndNode = (node: string) => node.endsWith("Z");

  return countStepsTillEndParallel(startNodes, isEndNode, nodes, instructions);
}

export function dayEight(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
