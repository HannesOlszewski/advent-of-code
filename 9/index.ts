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

function extrapolateSequenceForward(sequence: Sequence): number {
  if (!sequence.subSequence) {
    sequence.values.push(0);

    return 0;
  }

  const nextSubSequenceValue = extrapolateSequenceForward(sequence.subSequence);

  const nextValue =
    sequence.values[sequence.values.length - 1] + nextSubSequenceValue;

  sequence.values.push(nextValue);

  return nextValue;
}

function extrapolateSequenceBackward(sequence: Sequence): number {
  if (!sequence.subSequence) {
    sequence.values.unshift(0);

    return 0;
  }

  const nextSubSequenceValue = extrapolateSequenceBackward(
    sequence.subSequence
  );

  const nextValue = sequence.values[0] - nextSubSequenceValue;

  sequence.values.unshift(nextValue);

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

  const nextValues = subSequences.map(extrapolateSequenceForward);

  return nextValues.reduce((acc, value) => acc + value, 0);
}

export function partTwo(input: string): number {
  const sequences = parseInput(input);

  const subSequences = sequences.map((sequence) => {
    return {
      ...sequence,
      subSequence: buildSubSequences(sequence),
    };
  });

  const nextValues = subSequences.map(extrapolateSequenceBackward);

  return nextValues.reduce((acc, value) => acc + value, 0);
}

export function dayNine(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
