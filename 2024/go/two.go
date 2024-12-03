package main

import (
	"slices"
	"strconv"
	"strings"
)

func twoPartOne(input string) int {
	lines := strings.Split(input, "\n")
	safeReports := 0

	for _, line := range lines {
		if len(line) == 0 {
			continue
		}

		levels := strings.Split(line, " ")
		direction := 0 // 0 = not set, 1 = asc, 2 = desc
		isSafe := true

		for i, lvlStr := range levels {
			if i == 0 {
				continue
			}

			lvl, _ := strconv.Atoi(lvlStr)
			prev, _ := strconv.Atoi(levels[i-1])

			if lvl == prev || (prev-lvl) > 3 || (lvl-prev) > 3 {
				isSafe = false
				break
			}

			if direction == 0 {
				if lvl < prev {
					direction = 2
				} else {
					direction = 1
				}
			}

			if (direction == 1 && lvl < prev) || (direction == 2 && lvl > prev) {
				isSafe = false
				break
			}
		}

		if isSafe {
			safeReports++
		}
	}

	return safeReports
}

func twoPartTwo(input string) int {
	lines := strings.Split(input, "\n")
	safeReports := 0

	for _, line := range lines {
		if len(line) == 0 {
			continue
		}

		report := strings.Split(line, " ")
		hasSafePermutation := false

		for skipIndex := range report {
			levels := slices.Clone(report)
			levels = slices.Delete(levels, skipIndex, skipIndex+1)
			direction := 0 // 0 = not set, 1 = asc, 2 = desc
			isSafe := true

			for i, lvlStr := range levels {
				if i == 0 {
					continue
				}

				lvl, _ := strconv.Atoi(lvlStr)
				prev, _ := strconv.Atoi(levels[i-1])

				if lvl == prev || (prev-lvl) > 3 || (lvl-prev) > 3 {
					isSafe = false
					break
				}

				if direction == 0 {
					if lvl < prev {
						direction = 2
					} else {
						direction = 1
					}
				}

				if (direction == 1 && lvl < prev) || (direction == 2 && lvl > prev) {
					isSafe = false
					break
				}
			}

			if isSafe {
				hasSafePermutation = true
				break
			}
		}

		if hasSafePermutation {
			safeReports++
		}
	}

	return safeReports
}
