package main

import "testing"

func TestThirteenPartOne(t *testing.T) {
	input := `#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#`

	expected := 405

	if actual := thirteenPartOne(input); actual != expected {
		t.Fatalf("Expected %d but was %d", expected, actual)
	}
}

func TestThirteenPartOneEdgeCases(t *testing.T) {
	input := `#.##..
..#.##
##....
##....
..#.##
..##..
#.#.##

#...##..#
#....#..#
..##..###
#####.##.
#####.##.`

	expected := 405

	if actual := thirteenPartOne(input); actual != expected {
		t.Fatalf("Expected %d but was %d", expected, actual)
	}
}

func TestThirteenPartTwo(t *testing.T) {
	input := `#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#`

	expected := 0

	if actual := thirteenPartTwo(input); actual != expected {
		t.Fatalf("Expected %d but was %d", expected, actual)
	}
}

func TestThirteenPartTwoEdgeCases(t *testing.T) {
	input := `#.##..
..#.##
##....
##....
..#.##
..##..
#.#.##

#...##..#
#....#..#
..##..###
#####.##.
#####.##.`

	expected := 0

	if actual := thirteenPartTwo(input); actual != expected {
		t.Fatalf("Expected %d but was %d", expected, actual)
	}
}
