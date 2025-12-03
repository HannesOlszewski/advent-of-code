package main

import "testing"

func TestDayThreePartOne(t *testing.T) {
	input := `987654321111111
811111111111119
234234234234278
818181911112111`

	expected := "357"

	if actual := DayThreePartOne(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}

func TestDayThreePartTwo(t *testing.T) {
	input := `987654321111111
811111111111119
234234234234278
818181911112111`

	expected := "3121910778619"

	if actual := DayThreePartTwo(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}
