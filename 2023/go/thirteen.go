package main

import "strings"

const (
	Ash  = "."
	Rock = "#"
)

func findVerticalReflection(lines []string) (bool, int, int) {
	hasVerticalReflection := false
	left := 0
	right := 0

	for i := 0; i < len(lines[0])-1; i++ {
		found := true

		for j := 0; j < len(lines); j++ {
			if lines[j][i] != lines[j][i+1] {
				found = false
				break
			}
		}

		if !found {
			continue
		}

		for j := i; j >= 0; j-- {
			diff := i - j

			if i+diff+1 >= len(lines[0]) {
				// Column has no counterpart on the otherside since len(lines) might be an odd number
				continue
			}

			for k := 0; k < len(lines); k++ {
				if lines[k][j] != lines[k][i+diff+1] {
					found = false
					break
				}
			}
		}

		if found {
			hasVerticalReflection = true
			left = i
			right = i + 1
		}
	}

	return hasVerticalReflection, left, right
}

func findHorizontalReflection(lines []string) (bool, int, int) {
	hasHorizontalReflection := false
	top := 0
	bottom := 0

	for i := 0; i < len(lines)-1; i++ {
		if lines[i] != lines[i+1] {
			continue
		}

		found := true

		for j := i; j >= 0; j-- {
			diff := i - j

			if i+diff+1 >= len(lines) {
				// Row has no counterpart on the otherside since len(lines) might be an odd number
				continue
			}

			if lines[j] != lines[i+diff+1] {
				found = false
				break
			}
		}

		if found {
			hasHorizontalReflection = true
			top = i
			bottom = i + 1
		}
	}

	return hasHorizontalReflection, top, bottom
}

func thirteenPartOne(input string) int {
	patterns := strings.Split(input, "\n\n")
	verticalReflectionColumnsSum := 0
	horizontalReflectionRowsSum := 0

	for _, pattern := range patterns {
		lines := strings.Split(pattern, "\n")
		hasVerticalReflection, leftColumn, _ := findVerticalReflection(lines)

		if hasVerticalReflection {
			verticalReflectionColumnsSum += leftColumn + 1
			continue
		}

		hasHorizontalReflection, topRow, _ := findHorizontalReflection(lines)

		if hasHorizontalReflection {
			horizontalReflectionRowsSum += topRow + 1
		}
	}

	return verticalReflectionColumnsSum + horizontalReflectionRowsSum*100
}

func thirteenPartTwo(input string) int {
	return 0
}

func thirteen(input string) (int, int) {
	return thirteenPartOne(input), thirteenPartTwo(input)
}
