package main

import (
	"log"
	"os"
	"time"

	"github.com/rodaine/table"
)

func getInput(day string) string {
	data, err := os.ReadFile("../shared/" + day + ".txt")
	if err != nil {
		log.Fatal(err)
	}

	return string(data)
}

func main() {
	days := map[string]func(string) (int, int){
		"one":   one,
		"two":   two,
		"three": three,
		"four":  four,
	}

	tbl := table.New("Day", "Part 1", "Part 2", "Duration")

	for day, fn := range days {
		input := getInput(day)
		before := time.Now()
		partOne, partTwo := fn(input)
		after := time.Now()
		duration := after.Sub(before)
		tbl.AddRow(day, partOne, partTwo, duration)
	}

	tbl.Print()
}
