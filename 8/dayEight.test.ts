import { partOne } from ".";

const input1 = `RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)`;

const input2 = `LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)`;

describe("dayEight", () => {
  describe("partOne", () => {
    it("returns 2", () => {
      expect(partOne(input1)).toEqual(2);
    });

    it("returns 6", () => {
      expect(partOne(input2)).toEqual(6);
    });
  });
});
