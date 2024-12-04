import { expect, test } from "bun:test";
import three from "./three";

test("three part one", () => {
	expect(three.partOne(">")).toBe(2);
	expect(three.partOne("^>v<")).toBe(4);
	expect(three.partOne("^v^v^v^v^v")).toBe(2);
});

test("three part two", () => {
	expect(three.partTwo("^v")).toBe(3);
	expect(three.partTwo("^>v<")).toBe(3);
	expect(three.partTwo("^v^v^v^v^v")).toBe(11);
});
