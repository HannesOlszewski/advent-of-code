import fs from "fs";
import { partOne, partTwo } from ".";

describe("dayOne", () => {
  describe("partOne", () => {
    it("should return 142", () => {
      const input = fs.readFileSync("1/example1.txt", "utf8");

      expect(partOne(input)).toEqual(142);
    });
  });

  describe("partTwo", () => {
    it("should return 281", () => {
      const input = fs.readFileSync("1/example2.txt", "utf8");

      expect(partTwo(input)).toEqual(281);
    });
  });
});
