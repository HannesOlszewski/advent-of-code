package main

import "testing"

func TestSixteenPartOne(t *testing.T) {
	input := `.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....`

	expected := 46

	if actual := sixteenPartOne(input); expected != actual {
		t.Fatalf("Expected %d but was %d", expected, actual)
	}
}

func TestSixteenPartTwo(t *testing.T) {
	input := `.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....`

	expected := 51

	if actual := sixteenPartTwo(input); expected != actual {
		t.Fatalf("Expected %d but was %d", expected, actual)
	}
}
