import { partOne, partTwo } from ".";

const input = `Time:      7  15   30
Distance:  9  40  200`;

describe("dayOne", () => {
  describe("partOne", () => {
    it("should return 288", () => {
      expect(partOne(input)).toEqual(288);
    });
  });

  describe("partTwo", () => {
    it("should return 71503", () => {
      expect(partTwo(input)).toEqual(71503);
    });
  });
});
