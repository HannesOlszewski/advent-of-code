package main

import "testing"

func TestOnePartOne(t *testing.T) {
	input := `3   4
4   3
2   5
1   3
3   9
3   3`

	expected := 11

	if actual := onePartOne(input); actual != expected {
		t.Fatalf("Expected %d but got %d", expected, actual)
	}
}

func TestOnePartTwo(t *testing.T) {
	input := `3   4
4   3
2   5
1   3
3   9
3   3`

	expected := 31

	if actual := onePartTwo(input); actual != expected {
		t.Fatalf("Expected %d but got %d", expected, actual)
	}
}
