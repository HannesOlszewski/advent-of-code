package main

import (
	"strconv"
	"strings"
)

func parseInputAsSeparateNumbers(input string) ([]int, []int) {
	parts := strings.Split(input, "\n")

	times := strings.Fields(parts[0])[1:]
	timesResult := make([]int, len(times))

	for i, time := range times {
		timesResult[i], _ = strconv.Atoi(time)
	}

	distances := strings.Fields(parts[1])[1:]
	distancesResult := make([]int, len(distances))

	for i, distance := range distances {
		distancesResult[i], _ = strconv.Atoi(distance)
	}

	return timesResult, distancesResult
}

func parseInputAsSingleNumber(input string) (int, int) {
	parts := strings.Split(input, "\n")

	timeStr := ""
	distanceStr := ""

	for _, timePart := range strings.Fields(parts[0])[1:] {
		timeStr += timePart
	}

	for _, distancePart := range strings.Fields(parts[1])[1:] {
		distanceStr += distancePart
	}

	time, _ := strconv.Atoi(timeStr)
	distance, _ := strconv.Atoi(distanceStr)

	return time, distance
}

func findNumWinningPossibilities(time int, distance int) int {
	numWinningPossibilities := 0

	for ms := 0; ms <= time; ms++ {
		if (time-ms)*ms > distance {
			numWinningPossibilities++
		}
	}

	return numWinningPossibilities
}

func sixPartOne(input string) int {
	times, distances := parseInputAsSeparateNumbers(input)

	result := 1

	for i, time := range times {
		result *= findNumWinningPossibilities(time, distances[i])
	}

	return result
}

func sixPartTwo(input string) int {
	time, distance := parseInputAsSingleNumber(input)

	return findNumWinningPossibilities(time, distance)
}

func six(input string) (int, int) {
	return sixPartOne(input), sixPartTwo(input)
}
