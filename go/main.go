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

type Day struct {
	name string
	fn   func(string) (int, int)
}

func main() {
	days := []Day{
		{"one", one},
		{"two", two},
		{"three", three},
		{"four", four},
		{"five", five},
		{"six", six},
		{"seven", seven},
		{"thirteen", thirteen},
		{"fourteen", fourteen},
		{"fifteen", fifteen},
		{"sixteen", sixteen},
	}

	tbl := table.New("Day", "Part 1", "Part 2", "Duration")

	for i := 0; i < len(days); i++ {
		day, fn := days[i].name, days[i].fn
		input := getInput(day)
		before := time.Now()
		partOne, partTwo := fn(input)
		after := time.Now()
		duration := after.Sub(before)
		tbl.AddRow(day, partOne, partTwo, duration)
	}

	tbl.Print()
}
