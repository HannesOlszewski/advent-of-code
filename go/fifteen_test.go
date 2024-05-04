package main

import "testing"

func TestFifteenPartOne(t *testing.T) {
	input := `rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7`

	expected := 1320

	if actual := fifteenPartOne(input); actual != expected {
		t.Fatalf("Expected %d but was %d", expected, actual)
	}
}

func TestFifteenPartTwo(t *testing.T) {
	input := `rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7`

	expected := 145

	if actual := fifteenPartTwo(input); actual != expected {
		t.Fatalf("Expected %d but was %d", expected, actual)
	}
}
