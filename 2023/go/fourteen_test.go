package main

import "testing"

func TestFourteenPartOne(t *testing.T) {
	input := `O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....`

	expected := 136

	if actual := fourteenPartOne(input); actual != expected {
		t.Fatalf("Expected %d but was %d", expected, actual)
	}
}

func TestFourteenPartTwo(t *testing.T) {
	input := `O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....`

	expected := 64

	if actual := fourteenPartTwo(input); actual != expected {
		t.Fatalf("Expected %d but was %d", expected, actual)
	}
}
