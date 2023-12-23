import { partOne, partTwo } from ".";

const input = `0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45`;

describe("dayNine", () => {
  describe("partOne", () => {
    it("returns 114", () => {
      expect(partOne(input)).toEqual(114);
    });
  });

  describe("partTwo", () => {
    it("returns 0", () => {
      expect(partTwo("")).toEqual(0);
    });
  });
});
