import fs from "fs";
import { partOne, partTwo } from ".";

describe("dayOne", () => {
  describe("partOne", () => {
    it("should return 8", () => {
      const input = fs.readFileSync("2/example.txt", "utf8");

      expect(partOne(input)).toEqual(8);
    });
  });

  describe("partTwo", () => {
    it("should return 2286", () => {
      const input = fs.readFileSync("2/example.txt", "utf8");

      expect(partTwo(input)).toEqual(2286);
    });
  });
});
