import { partOne, partTwo } from ".";

const input = `32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483`;

describe("daySeven", () => {
  describe("partOne", () => {
    it("should return 6440", () => {
      expect(partOne(input)).toEqual(6440);
    });
  });

  describe("partTwo", () => {
    it("should return 5905", () => {
      expect(partTwo(input)).toEqual(5905);
    });
  });
});
