package main

import "testing"

func TestDayOnePartOne(t *testing.T) {
	input := `L68
L100
L200
R100
R200
L30
R48
L5
R60
L55
L1
L99
R14
L82`

	expected := "3"

	if actual := DayOnePartOne(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}

func TestDayOnePartTwo(t *testing.T) {
	input := `L68
L100
L200
R100
R200
L30
R48
R1000
L99
R99
L5
R60
L55
L1
L99
R14
L82`

	expected := "23"

	if actual := DayOnePartTwo(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}
