package main

import (
	"regexp"
	"strconv"
	"strings"
)

func parseDigit(s string) int {
	digit, _ := strconv.Atoi(s)

	return digit
}

func onePartOne(input string) int {
	sum := 0
	lines := strings.Split(input, "\n")

	for _, line := range lines {
		re := regexp.MustCompile(`\d`)
		numbers := re.FindAllString(line, -1)

		if len(numbers) == 0 {
			continue
		}

		first := parseDigit(numbers[0])
		last := parseDigit(numbers[len(numbers)-1])
		sum += first*10 + last
	}

	return sum
}

func onePartTwo(input string) int {
	adjustedInput := strings.ReplaceAll(input, "one", "o1e")
	adjustedInput = strings.ReplaceAll(adjustedInput, "two", "t2o")
	adjustedInput = strings.ReplaceAll(adjustedInput, "three", "t3e")
	adjustedInput = strings.ReplaceAll(adjustedInput, "four", "f4r")
	adjustedInput = strings.ReplaceAll(adjustedInput, "five", "f5e")
	adjustedInput = strings.ReplaceAll(adjustedInput, "six", "s6x")
	adjustedInput = strings.ReplaceAll(adjustedInput, "seven", "s7n")
	adjustedInput = strings.ReplaceAll(adjustedInput, "eight", "e8t")
	adjustedInput = strings.ReplaceAll(adjustedInput, "nine", "n9e")

	return onePartOne(adjustedInput)
}

func one(input string) (int, int) {
	return onePartOne(input), onePartTwo(input)
}
