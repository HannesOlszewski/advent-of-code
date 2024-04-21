package main

import "testing"

func TestOnePartOne(t *testing.T) {
	input := `1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet`

	expected := 142

	if actual := onePartOne(input); actual != expected {
		t.Fatalf("Expected %d but got %d", expected, actual)
	}
}

func TestOnePartTwo(t *testing.T) {
	input := `two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
eighthree`

	expected := 281 + 83

	if actual := onePartTwo(input); actual != expected {
		t.Fatalf("Expected %d but got %d", expected, actual)
	}
}
