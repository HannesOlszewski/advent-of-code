package main

import "testing"

func TestDayNinePartOne(t *testing.T) {
	input := `7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3`

	expected := "50"

	if actual := DayNinePartOne(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}

func TestDayNinePartTwo(t *testing.T) {
	input := `7,1
11,1
11,7
9,7
9,5
2,5
2,3
2,0
3,0
3,3
7,3`

	expected := "24"

	if actual := DayNinePartTwo(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}
