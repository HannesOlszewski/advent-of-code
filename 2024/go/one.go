package main

import (
	"slices"
	"strconv"
	"strings"
)

func onePartOne(input string) int {
	sum := 0
	lines := strings.Split(input, "\n")
	listOne := make([]int, len(lines))
	listTwo := make([]int, len(lines))

	for i, line := range lines {
		if len(line) == 0 {
			continue
		}

		numbers := strings.Split(line, "   ")
		first, _ := strconv.Atoi(numbers[0])
		second, _ := strconv.Atoi(numbers[1])

		listOne[i] = first
		listTwo[i] = second
	}

	slices.Sort(listOne)
	slices.Sort(listTwo)

	for i := range listOne {
		first, second := listOne[i], listTwo[i]

		if first <= second {
			sum += second - first
		} else {
			sum += first - second
		}
	}

	return sum
}

func onePartTwo(input string) int {
	sum := 0
	lines := strings.Split(input, "\n")
	mapOne := map[int]int{}
	mapTwo := map[int]int{}

	for _, line := range lines {
		if len(line) == 0 {
			continue
		}

		numbers := strings.Split(line, "   ")
		first, _ := strconv.Atoi(numbers[0])
		second, _ := strconv.Atoi(numbers[1])

		mapOne[first]++
		mapTwo[second]++
	}

	for num, count := range mapOne {
		sum += num * count * mapTwo[num]
	}

	return sum
}
