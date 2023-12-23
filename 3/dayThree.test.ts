import { partOne, partTwo } from "./";

const input = `467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..`;

describe("dayOne", () => {
  describe("partOne", () => {
    it("should return 4361", () => {
      expect(partOne(input)).toEqual(4361);
    });
  });

  describe("partTwo", () => {
    it("should return 467835", () => {
      expect(partTwo(input)).toEqual(467835);
    });
  });
});
