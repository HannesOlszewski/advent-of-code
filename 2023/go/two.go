package main

import (
	"strconv"
	"strings"
)

func twoPartOne(input string) int {
	lines := strings.Split(input, "\n")
	sum := 0
	const maxRed = 12
	const maxGreen = 13
	const maxBlue = 14

	for i, line := range lines {
		iStr := strconv.Itoa(i + 1)
		adjustedLine := strings.ReplaceAll(line, "Game "+iStr+": ", "")
		adjustedLine = strings.ReplaceAll(adjustedLine, "; ", ", ")

		cubesSplit := strings.Split(adjustedLine, ", ")
		id := i + 1

		for _, cubeSplit := range cubesSplit {
			countAndColor := strings.Split(cubeSplit, " ")
			count, _ := strconv.Atoi(countAndColor[0])
			color := countAndColor[1]

			if color == "red" && count > maxRed {
				id = 0
				break
			}
			if color == "green" && count > maxGreen {
				id = 0
				break
			}
			if color == "blue" && count > maxBlue {
				id = 0
				break
			}
		}

		sum += id
	}

	return sum
}

func twoPartTwo(input string) int {
	lines := strings.Split(input, "\n")
	sum := 0

	for i, line := range lines {
		iStr := strconv.Itoa(i + 1)
		adjustedLine := strings.ReplaceAll(line, "Game "+iStr+": ", "")
		adjustedLine = strings.ReplaceAll(adjustedLine, "; ", ", ")

		cubesSplit := strings.Split(adjustedLine, ", ")
		minRed := 0
		minGreen := 0
		minBlue := 0

		for _, cubeSplit := range cubesSplit {
			countAndColor := strings.Split(cubeSplit, " ")
			count, _ := strconv.Atoi(countAndColor[0])
			color := countAndColor[1]

			if color == "red" && count > minRed {
				minRed = count
			}
			if color == "green" && count > minGreen {
				minGreen = count
			}
			if color == "blue" && count > minBlue {
				minBlue = count
			}
		}

		sum += minRed * minGreen * minBlue
	}

	return sum
}

func two(input string) (int, int) {
	return twoPartOne(input), twoPartTwo(input)
}
