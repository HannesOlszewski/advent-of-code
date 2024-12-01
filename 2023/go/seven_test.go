package main

import "testing"

func TestSevenPartOne(t *testing.T) {
	input := `32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483`

	expected := 6440

	if actual := sevenPartOne(input); actual != expected {
		t.Fatalf("Expected %v but was %v", expected, actual)
	}
}

func TestSevenPartTwo(t *testing.T) {
	input := `32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483`

	expected := 5905

	if actual := sevenPartTwo(input); actual != expected {
		t.Fatalf("Expected %v but was %v", expected, actual)
	}
}
