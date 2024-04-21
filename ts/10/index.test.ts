import { partOne, partTwo } from ".";

const input1 = `.....
.S-7.
.|.|.
.L-J.
.....`;

const input2 = `7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ`;

describe("dayTen", () => {
  describe("partOne", () => {
    it("returns 4", () => {
      expect(partOne(input1)).toEqual(4);
    });

    it("returns 8", () => {
      expect(partOne(input2)).toEqual(8);
    });
  });

  describe("partTwo", () => {
    it("returns 0", () => {
      expect(partTwo("")).toEqual(0);
    });
  });
});
