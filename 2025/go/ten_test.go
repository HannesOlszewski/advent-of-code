package main

import (
	"slices"
	"testing"
)

func TestDayTenPartOne(t *testing.T) {
	input := `[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}`

	expected := "7"

	if actual := DayTenPartOne(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}

func TestCombinations(t *testing.T) {
	expected := [][]int{{0, 1}, {0, 2}, {0, 3}, {1, 2}, {1, 3}, {2, 3}}

	if actual := combinations(4, 2); !slices.EqualFunc(actual, expected, func(a, b []int) bool {
		return slices.Equal(a, b)
	}) {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}

func TestDayTenPartTwo(t *testing.T) {
	if actual := DayTenPartTwo("[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}"); actual != "10" {
		t.Fatalf("Expected %v but got %v", "10", actual)
	}

	if actual := DayTenPartTwo("[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}"); actual != "12" {
		t.Fatalf("Expected %v but got %v", "12", actual)
	}

	if actual := DayTenPartTwo("[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}"); actual != "11" {
		t.Fatalf("Expected %v but got %v", "11", actual)
	}

	input := `[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}`

	expected := "33"

	if actual := DayTenPartTwo(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}
