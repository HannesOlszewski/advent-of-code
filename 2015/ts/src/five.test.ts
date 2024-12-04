import { expect, test } from "bun:test";
import five from "./five";

test("five part one", () => {
	const input = `ugknbfddgicrmopn
aaa
jchzalrnumimnmhp
haegwjzuvuyypxyu
dvszwmarrgswjxmb`;

	expect(five.partOne(input)).toBe(2);
});

test("five part two", () => {
	const input = `qjhvhtzxzqqjkmpb
xxyxx
uurcxstgmygtbstg
ieodomkazucvgmuy
aaa`;

	expect(five.partTwo(input)).toBe(2);
});
