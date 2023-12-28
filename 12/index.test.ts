import { partOne, partTwo } from ".";

const input = `???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1`;

describe("dayTwelve", () => {
  describe("partOne", () => {
    it("returns 21", () => {
      expect(partOne(input)).toEqual(21);
    });
  });

  describe("partTwo", () => {
    it("returns 0", () => {
      expect(partTwo(input)).toEqual(0);
    });
  });
});
