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
    it("returns 1030", () => {
      expect(partTwo(input, 10)).toEqual(1030);
    });

    it("returns 8410", () => {
      expect(partTwo(input, 100)).toEqual(8410);
    });

    it("returns 82210", () => {
      expect(partTwo(input, 1000)).toEqual(82210);
    });
  });
});
