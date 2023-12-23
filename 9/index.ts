interface Sequence {
  values: number[];
  level: number;
  subSequence?: Sequence;
}

function parseInput(input: string): Sequence[] {
  return input.split("\n").map((line) => {
    const values = line.split(" ").map((value) => parseInt(value, 10));
    return {
      values,
      level: 0,
    };
  });
}

function buildSubSequences(sequence: Sequence): Sequence {
  const subSequence: Sequence = {
    values: [],
    level: sequence.level + 1,
  };

  sequence.values.slice(1).forEach((value, index) => {
    subSequence.values.push(value - sequence.values[index]);
  });

  if (!subSequence.values.every((value) => value === 0)) {
    subSequence.subSequence = buildSubSequences(subSequence);
  }

  return subSequence;
}

function extrapolateSequence(sequence: Sequence): number {
  if (!sequence.subSequence) {
    sequence.values.push(0);

    return 0;
  }

  const nextSubSequenceValue = extrapolateSequence(sequence.subSequence);

  const nextValue =
    sequence.values[sequence.values.length - 1] + nextSubSequenceValue;

  sequence.values.push(nextValue);

  return nextValue;
}

export function partOne(input: string): number {
  const sequences = parseInput(input);

  const subSequences = sequences.map((sequence) => {
    return {
      ...sequence,
      subSequence: buildSubSequences(sequence),
    };
  });

  const nextValues = subSequences.map(extrapolateSequence);

  return nextValues.reduce((acc, value) => acc + value, 0);
}

export function partTwo(input: string): number {
  return 0;
}

export function dayNine(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
