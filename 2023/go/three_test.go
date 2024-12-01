package main

import "testing"

func TestThreePartOne(t *testing.T) {
	input := `467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..`

	expected := 4361

	if actual := threePartOne(input); actual != expected {
		t.Errorf("expected %v but got %v", expected, actual)
	}
}

func TestThreePartTwo(t *testing.T) {
	input := `467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..`

	expected := 467835

	if actual := threePartTwo(input); actual != expected {
		t.Errorf("expected %v but got %v", expected, actual)
	}
}
