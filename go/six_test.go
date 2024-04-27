package main

import "testing"

func TestSixPartOne(t *testing.T) {
	input := `Time:      7  15   30
Distance:  9  40  200`

	expected := 288

	if actual := sixPartOne(input); actual != expected {
		t.Fatalf("Expected %v but was %v", expected, actual)
	}
}

func TestSixPartTwo(t *testing.T) {
	input := `Time:      7  15   30
Distance:  9  40  200`

	expected := 71503

	if actual := sixPartTwo(input); actual != expected {
		t.Fatalf("Expected %v but was %v", expected, actual)
	}
}
