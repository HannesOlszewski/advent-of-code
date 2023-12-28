import { partOne, partTwo } from ".";

const input = `...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....`;

describe("dayEleven", () => {
  describe("partOne", () => {
    it("returns 374", () => {
      expect(partOne(input)).toEqual(374);
    });
  });

  describe("partTwo", () => {
    it("returns 0", () => {
      expect(partTwo(input)).toEqual(0);
    });
  });
});
