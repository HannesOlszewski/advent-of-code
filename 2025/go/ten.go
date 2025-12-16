package main

import (
	"fmt"
	"log"
	"strconv"
	"strings"
)

func tryButtons(history []int, buttons []int, target int) int {
	iteration := len(history)

	if iteration >= 8 {
		return -1
	}

	currentLights := history[iteration-1]
	bestIterationCount := -1

	for _, button := range buttons {
		newLights := currentLights ^ button

		if newLights == target {
			return iteration
		}

		if iteration >= 2 && history[iteration-2] == newLights {
			continue
		}

		newHistory := append(history, newLights)
		requiredIterations := tryButtons(newHistory, buttons, target)

		if requiredIterations > -1 && (requiredIterations < bestIterationCount || bestIterationCount == -1) {
			bestIterationCount = requiredIterations
		}
	}

	return bestIterationCount
}

const (
	lightsStart  = '['
	wiringStart  = '('
	joltageStart = '{'
	lightOn      = '#'
)

// const lightOff = '.'

func parseLineAndTryButtons(line string, channel chan int) {
	parts := strings.SplitSeq(line, " ")
	lights := 0
	lightsTarget := 0
	buttons := []int{}

	for part := range parts {
		switch part[0] {
		case lightsStart:

			for i, char := range part[1 : len(part)-1] {
				if char == lightOn {
					lightsTarget |= 1 << i
				}
			}
		case wiringStart:
			wirings := strings.SplitSeq(part[1:len(part)-1], ",")
			button := 0

			for char := range wirings {
				num, err := strconv.Atoi(char)
				if err != nil {
					log.Fatal(err)
				}
				button |= 1 << num
			}

			buttons = append(buttons, button)
		}
	}

	requiredButtonPresses := tryButtons([]int{lights}, buttons, lightsTarget)

	if requiredButtonPresses == -1 {
		fmt.Println(line)
		log.Fatalln("Could not find valid combination")
	}

	channel <- requiredButtonPresses
}

func DayTenPartOne(input string) string {
	lines := strings.Split(input, "\n")
	channel := make(chan int)
	total := 0
	processedLinesCount := 0

	for _, line := range lines {
		go parseLineAndTryButtons(line, channel)
	}

	for processedLinesCount < len(lines) {
		total += <-channel
		processedLinesCount++
	}

	return strconv.Itoa(total)
}

// Convert []int to string for use as map key (Go can't use slices as keys)
func sliceToKey(s []int) string {
	parts := make([]string, len(s))
	for i, v := range s {
		parts[i] = strconv.Itoa(v)
	}
	return strings.Join(parts, ",")
}

// Convert string key back to []int
func keyToSlice(key string) []int {
	if key == "" {
		return []int{}
	}
	parts := strings.Split(key, ",")
	result := make([]int, len(parts))
	for i, p := range parts {
		result[i], _ = strconv.Atoi(p)
	}
	return result
}

// Generate all combinations of k elements from 0..n-1
func combinations(n, k int) [][]int {
	var result [][]int
	var combo []int

	var generate func(start int)
	generate = func(start int) {
		if len(combo) == k {
			c := make([]int, k)
			copy(c, combo)
			result = append(result, c)
			return
		}
		for i := start; i < n; i++ {
			combo = append(combo, i)
			generate(i + 1)
			combo = combo[:len(combo)-1]
		}
	}
	generate(0)
	return result
}

func patterns(coeffs [][]int) map[string]int {
	out := make(map[string]int)
	numButtons := len(coeffs)
	if numButtons == 0 {
		return out
	}
	numVariables := len(coeffs[0])

	for patternLen := 0; patternLen <= numButtons; patternLen++ {
		for _, buttons := range combinations(numButtons, patternLen) {
			// Sum the coefficient vectors for selected buttons
			pattern := make([]int, numVariables)
			for _, btnIdx := range buttons {
				for j := range numVariables {
					pattern[j] += coeffs[btnIdx][j]
				}
			}
			key := sliceToKey(pattern)
			if _, exists := out[key]; !exists {
				out[key] = patternLen
			}
		}
	}
	return out
}

func solveSingle(coeffs [][]int, goal []int) int {
	patternCosts := patterns(coeffs)
	cache := make(map[string]int)

	var solveSingleAux func(goal []int) int
	solveSingleAux = func(goal []int) int {
		key := sliceToKey(goal)
		if cached, exists := cache[key]; exists {
			return cached
		}

		// Base case: all zeros
		allZero := true
		for _, v := range goal {
			if v != 0 {
				allZero = false
				break
			}
		}
		if allZero {
			return 0
		}

		answer := 1000000
		for patternKey, patternCost := range patternCosts {
			pattern := keyToSlice(patternKey)

			// Check: pattern[i] <= goal[i] and same parity
			valid := true
			for i := range pattern {
				if pattern[i] > goal[i] || pattern[i]%2 != goal[i]%2 {
					valid = false
					break
				}
			}

			if valid {
				newGoal := make([]int, len(goal))
				for i := range goal {
					newGoal[i] = (goal[i] - pattern[i]) / 2
				}
				cost := patternCost + 2*solveSingleAux(newGoal)
				if cost < answer {
					answer = cost
				}
			}
		}

		cache[key] = answer
		return answer
	}

	return solveSingleAux(goal)
}

func parseLineAndSolveSingle(line string, channel chan int) {
	parts := strings.SplitSeq(line, " ")
	lightsCount := 0
	var joltageTargets []int
	buttons := [][]int{}

	for part := range parts {
		switch part[0] {
		case lightsStart:
			lightsCount = len(part) - 2
			joltageTargets = make([]int, 0, lightsCount)
		case wiringStart:
			wirings := strings.SplitSeq(part[1:len(part)-1], ",")
			button := make([]int, lightsCount)

			for char := range wirings {
				num, err := strconv.Atoi(char)
				if err != nil {
					log.Fatal(err)
				}
				button[num] = 1
			}

			buttons = append(buttons, button)
		case joltageStart:
			levels := strings.SplitSeq(part[1:len(part)-1], ",")

			for char := range levels {
				num, err := strconv.Atoi(char)
				if err != nil {
					log.Fatal(err)
				}
				joltageTargets = append(joltageTargets, num)
			}
		}
	}

	channel <- solveSingle(buttons, joltageTargets)
}

func DayTenPartTwo(input string) string {
	// Mostly a copy (into go translated) of https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/

	lines := strings.Split(input, "\n")
	channel := make(chan int)
	processedLinesCount := 0
	total := 0

	for _, line := range lines {
		go parseLineAndSolveSingle(line, channel)
	}

	for processedLinesCount < len(lines) {
		total += <-channel
		processedLinesCount++
	}

	return strconv.Itoa(total)
}
