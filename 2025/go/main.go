package main

import (
	"fmt"
	"io"
	"log"
	"os"
	"time"
)

func getInput(day string) string {
	data, err := os.ReadFile("../shared/" + day + ".txt")
	if err != nil {
		log.Fatal(err)
	}

	return string(data)
}

type Day struct {
	name    string
	PartOne func(string) string
	PartTwo func(string) string
}

func NotYetImplemented(_ string) string {
	return "not yet implemented"
}

func main() {
	days := [12]Day{
		{"1", NotYetImplemented, NotYetImplemented},
		{"2", NotYetImplemented, NotYetImplemented},
		{"3", NotYetImplemented, NotYetImplemented},
		{"4", NotYetImplemented, NotYetImplemented},
		{"5", NotYetImplemented, NotYetImplemented},
		{"6", NotYetImplemented, NotYetImplemented},
		{"7", NotYetImplemented, NotYetImplemented},
		{"8", NotYetImplemented, NotYetImplemented},
		{"9", NotYetImplemented, NotYetImplemented},
		{"10", NotYetImplemented, NotYetImplemented},
		{"11", NotYetImplemented, NotYetImplemented},
		{"12", NotYetImplemented, NotYetImplemented},
	}

	for _, day := range days {
		input := getInput(day.name)

		if len(input) == 0 {
			continue
		}

		before := time.Now()
		partOneResult := day.PartOne(input)
		between := time.Now()
		partTwoResult := day.PartOne(input)
		after := time.Now()
		partOneDuration := between.Sub(before)
		partTwoDuration := after.Sub(between)

		line := fmt.Sprintf("Day %v part 1 (took %v): %v\n", day.name, partOneDuration, partOneResult)
		if _, err := io.WriteString(os.Stdout, line); err != nil {
			log.Fatal(err)
		}
		line = fmt.Sprintf("Day %v part 2 (took %v): %v\n", day.name, partTwoDuration, partTwoResult)
		if _, err := io.WriteString(os.Stdout, line); err != nil {
			log.Fatal(err)
		}
	}
}
