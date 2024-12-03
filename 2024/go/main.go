package main

import (
	"log"
	"os"
	"time"

	"github.com/rodaine/table"
)

func getInput(day string) string {
	data, err := os.ReadFile("../inputs/" + day + ".txt")
	if err != nil {
		log.Fatal(err)
	}

	return string(data)
}

type Day struct {
	name    string
	partOne func(string) int
	partTwo func(string) int
}

func main() {
	days := []Day{
		{"one", onePartOne, onePartTwo},
		{"two", twoPartOne, twoPartTwo},
	}

	tbl := table.New("Day", "Part One Result", "Time", "Part Two Result", "Time")

	for i := 0; i < len(days); i++ {
		day, partOne, partTwo := days[i].name, days[i].partOne, days[i].partTwo
		input := getInput(day)
		start := time.Now()
		resultOne := partOne(input)
		mid := time.Now()
		resultTwo := partTwo(input)
		end := time.Now()
		tbl.AddRow(i+1, resultOne, mid.Sub(start), resultTwo, end.Sub(mid))
	}

	tbl.Print()
}
