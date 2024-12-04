import { expect, test } from "bun:test";
import two from "./two";

test("two part one", () => {
	expect(two.partOne("2x3x4")).toBe(58);
	expect(two.partOne("1x1x10")).toBe(43);
	expect(
		two.partOne(`2x3x4
1x1x10`),
	).toBe(58 + 43);
});

test("two part two", () => {
	expect(two.partTwo("2x3x4")).toBe(34);
	expect(two.partTwo("1x1x10")).toBe(14);
	expect(
		two.partTwo(`2x3x4
1x1x10`),
	).toBe(34 + 14);
});
