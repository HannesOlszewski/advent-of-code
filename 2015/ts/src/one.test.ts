import { expect, test } from "bun:test";
import one from "./one";

test("one part one", () => {
	expect(one.partOne("(())")).toBe(0);
	expect(one.partOne("()()")).toBe(0);
	expect(one.partOne("(((")).toBe(3);
	expect(one.partOne("(()(()(")).toBe(3);
	expect(one.partOne("))(((((")).toBe(3);
	expect(one.partOne("())")).toBe(-1);
	expect(one.partOne("))(")).toBe(-1);
	expect(one.partOne(")))")).toBe(-3);
	expect(one.partOne(")())())")).toBe(-3);
});

test("one part two", () => {
	expect(one.partTwo(")")).toBe(1);
	expect(one.partTwo("()())")).toBe(5);
});
