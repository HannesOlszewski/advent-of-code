import { partOne, partTwo } from ".";

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

const input3 = `LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)`;

describe("dayEight", () => {
  describe("partOne", () => {
    it("returns 2", () => {
      expect(partOne(input1)).toEqual(2);
    });

    it("returns 6", () => {
      expect(partOne(input2)).toEqual(6);
    });
  });

  describe("partTwo", () => {
    it("returns 6", () => {
      expect(partTwo(input3)).toEqual(6);
    });
  });
});
