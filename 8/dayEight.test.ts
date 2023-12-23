import fs from "fs";
import { partOne } from ".";

describe("dayEight", () => {
  describe("partOne", () => {
    it("returns 2", () => {
      const input = fs.readFileSync(`8/example1.txt`).toString();

      expect(partOne(input)).toEqual(2);
    });

    it("returns 6", () => {
      const input = fs.readFileSync(`8/example2.txt`).toString();

      expect(partOne(input)).toEqual(6);
    });
  });
});
