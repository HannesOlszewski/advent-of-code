import fs from "fs";
import { partOne, partTwo } from ".";

describe("daySeven", () => {
  describe("partOne", () => {
    it("should return 6440", () => {
      const input = fs.readFileSync("7/example.txt", "utf8");

      expect(partOne(input)).toEqual(6440);
    });
  });

  describe("partTwo", () => {
    it("should return 5905", () => {
      const input = fs.readFileSync("7/example.txt", "utf8");

      expect(partTwo(input)).toEqual(5905);
    });
  });
});
