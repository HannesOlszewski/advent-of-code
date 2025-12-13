package main

import "testing"

func TestDayElevenPartOne(t *testing.T) {
	input := `aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out`

	expected := "5"

	if actual := DayElevenPartOne(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}

func TestDayElevenPartTwo(t *testing.T) {
	input := `svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out`

	expected := "2"

	if actual := DayElevenPartTwo(input); actual != expected {
		t.Fatalf("Expected %v but got %v", expected, actual)
	}
}
