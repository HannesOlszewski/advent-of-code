package main

import "testing"

func TestDayFivePartOne(t *testing.T) {
	input := `3-5
10-14
16-20
12-18

1
5
8
11
17
32`

	expected := "3"

	if actual := DayFivePartOne(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}

func TestDayFivePartTwo(t *testing.T) {
	input := `3-5
3-5
10-14
17-17
16-20
12-18
21-30
22-25
26-30`

	expected := "24"

	if actual := DayFivePartTwo(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}
