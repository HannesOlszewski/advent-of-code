import fs from "fs";
import { partOne, partTwo } from "./";

describe("dayOne", () => {
  describe("partOne", () => {
    it("should return 4361", () => {
      const input = fs.readFileSync("3/example.txt", "utf8");

      expect(partOne(input)).toEqual(4361);
    });
  });

  describe("partTwo", () => {
    it("should return 467835", () => {
      const input = fs.readFileSync("3/example.txt", "utf8");

      expect(partTwo(input)).toEqual(467835);
    });
  });
});
