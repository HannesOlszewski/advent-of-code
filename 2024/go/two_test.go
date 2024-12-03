package main

import "testing"

func TestTwoPartOne(t *testing.T) {
	input := `7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9`

	expected := 2

	if actual := twoPartOne(input); actual != expected {
		t.Fatalf("Expected %d but got %d", expected, actual)
	}
}

func TestTwoPartTwo(t *testing.T) {
	input := `7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
9 7 6 2 1 0
1 3 2 4 5
1 1 2 4 5
8 6 4 4 1
1 3 6 7 9
1 3 6 7 1
5 2 3 4 5 7
8 3 2 1 0
2 6 7 8 9`

	expected := 9

	if actual := twoPartTwo(input); actual != expected {
		t.Fatalf("Expected %d but got %d", expected, actual)
	}
}
