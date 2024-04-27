import { partOne, partTwo } from ".";

const input1 = `#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#`;

const input2 = `#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#

.#.##.#.#
.##..##..
.#.##.#..
#......##
#......##
.#.##.#..
.##..##.#

#..#....#
###..##..
.##.#####
.##.#####
###..##..
#..#....#
#..##...#

#.##..##.
..#.##.#.
##..#...#
##...#..#
..#.##.#.
..##..##.
#.#.##.#.`;

describe("dayThirteen", () => {
  describe("partOne", () => {
    it("returns 405", () => {
      expect(partOne(input1)).toEqual(405);
    });

    it("returns 709", () => {
      expect(partOne(input2)).toEqual(709);
    });
  });

  describe("partTwo", () => {
    it("returns 0", () => {
      expect(partTwo(input1)).toEqual(0);
    });
  });
});