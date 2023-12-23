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

export function partOne(input: string): number {
  const { instructions, nodes } = parseInput(input);

  return countStepsTillEnd("AAA", "ZZZ", nodes, instructions);
}

export function dayEight(input: string): [number, number] {
  return [partOne(input), 0];
}
