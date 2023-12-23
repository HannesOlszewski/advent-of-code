import fs from "fs";
import { partOne, partTwo } from ".";

describe("dayOne", () => {
  describe("partOne", () => {
    it("should return 288", () => {
      const input = fs.readFileSync("6/example.txt", "utf8");

      expect(partOne(input)).toEqual(288);
    });
  });

  describe("partTwo", () => {
    it("should return 71503", () => {
      const input = fs.readFileSync("6/example.txt", "utf8");

      expect(partTwo(input)).toEqual(71503);
    });
  });
});
