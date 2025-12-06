package main

import "testing"

func TestDaySixPartOne(t *testing.T) {
	input := `123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  `

	expected := "4277556"

	if actual := DaySixPartOne(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}

func TestDaySixPartTwo(t *testing.T) {
	// 	input := `23 1328  51 64
	// 45  64  387 23
	//  6  98  215 314
	// *  +    *   +  `
	input := `123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  `

	// expected := "3263828"
	expected := "3263827"

	if actual := DaySixPartTwo(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}
