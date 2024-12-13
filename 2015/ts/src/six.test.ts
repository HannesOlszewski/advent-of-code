import { expect, test } from "bun:test";
import six from "./six";

test("six part one", () => {
  expect(six.partOne("turn on 0,0 through 999,999")).toBe(1000 * 1000);
  expect(six.partOne("toggle 0,0 through 999,0")).toBe(1000);
  expect(six.partOne("turn off 499,499 through 500,500")).toBe(0);
  expect(
    six.partOne(`turn on 0,0 through 999,999
toggle 0,0 through 999,0
turn off 499,499 through 500,500`),
  ).toBe(1000 * 1000 - 1000 - 4);
});

test("six part two", () => {
  expect(six.partTwo("turn on 0,0 through 999,999")).toBe(1000 * 1000);
  expect(six.partTwo("toggle 0,0 through 999,0")).toBe(2000);
  expect(six.partTwo("turn off 499,499 through 500,500")).toBe(0);
  expect(
    six.partTwo(`turn on 0,0 through 999,999
toggle 0,0 through 999,0
turn off 499,499 through 500,500`),
  ).toBe(1000 * 1000 + 2000 - 4);
});
