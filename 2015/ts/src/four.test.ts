import { expect, test } from "bun:test";
import four from "./four";

test("four part one", () => {
	expect(four.partOne("abcdef")).toBe(609043);
	expect(four.partOne("pqrstuv")).toBe(1048970);
});

test("four part two", () => {
	expect(four.partTwo("abcdef")).toBe(6742839);
	expect(four.partTwo("pqrstuv")).toBe(5714438);
});
