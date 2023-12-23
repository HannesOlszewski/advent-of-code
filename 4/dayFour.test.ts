import fs from "fs";
import { partOne, partTwo } from ".";

describe("dayOne", () => {
  describe("partOne", () => {
    it("should return 13", () => {
      const input = fs.readFileSync("4/example.txt", "utf8");

      expect(partOne(input)).toEqual(13);
    });
  });

  describe("partTwo", () => {
    it("should return 30", () => {
      const input = fs.readFileSync("4/example.txt", "utf8");

      expect(partTwo(input)).toEqual(30);
    });
  });
});
