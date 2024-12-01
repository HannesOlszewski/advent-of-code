import { partOne, partTwo } from ".";

const input1 = `1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet`;

const input2 = `two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen`;

describe("dayOne", () => {
  describe("partOne", () => {
    it("should return 142", () => {
      expect(partOne(input1)).toEqual(142);
    });
  });

  describe("partTwo", () => {
    it("should return 281", () => {
      expect(partTwo(input2)).toEqual(281);
    });
  });
});
