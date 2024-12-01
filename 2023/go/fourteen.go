package main

import (
	"slices"
	"strings"
)

const (
	RoundRock = 'O'
	CubeRock  = '#'
	Empty     = '.'
)

func tiltNorth(lines []string) []string {
	numRows := len(lines)
	numColumns := len(lines[0])
	result := make([][]string, numRows)

	for i := 0; i < numRows; i++ {
		result[i] = make([]string, numColumns)

		for j := 0; j < numColumns; j++ {
			result[i][j] = string(lines[i][j])
		}
	}

	for col := 0; col < numColumns; col++ {
		for row := 0; row < numRows; row++ {
			rock := string(lines[row][col])
			rowsToMove := 0

			if rock == string(RoundRock) {
				for i := row; i > 0; i-- {
					if result[i-1][col] != string(Empty) {
						break
					}

					rowsToMove++
				}
			}

			newRow := row - rowsToMove

			result[newRow][col] = rock

			if row != newRow {
				result[row][col] = string(Empty)
			}
		}
	}

	newLines := make([]string, numRows)

	for i := range result {
		newLines[i] = ""

		for j := 0; j < numColumns; j++ {
			newLines[i] += result[i][j]
		}
	}

	return newLines
}

func rotateRight(lines []string) []string {
	rotated := make([]string, len(lines[0]))

	for row := len(lines) - 1; row >= 0; row-- {
		for col := 0; col < len(lines[0]); col++ {
			rotated[col] += string(lines[row][col])
		}
	}

	return rotated
}

func countLoad(lines []string) int {
	numRows := len(lines)
	result := 0

	for i, row := range lines {
		numRocksInRow := 0

		for _, col := range row {
			if col == RoundRock {
				numRocksInRow++
			}
		}

		result += numRocksInRow * (numRows - i)
	}

	return result
}

func fourteenPartOne(input string) int {
	lines := strings.Split(input, "\n")

	if len(lines[len(lines)-1]) == 0 {
		lines = lines[:len(lines)-1]
	}

	tiltedNorth := tiltNorth(lines)

	return countLoad(tiltedNorth)
}

func fourteenPartTwo(input string) int {
	lines := strings.Split(input, "\n")

	if len(lines[len(lines)-1]) == 0 {
		lines = lines[:len(lines)-1]
	}

	previous := slices.Clone(lines)

	const maxCycles = 1000000000
	// const maxCycles = 1000

	loads := [][]int{}
	cycleStart := -1

	for i := 0; i < maxCycles; i++ {
		// Previous
		current := slices.Clone(previous)
		// Tilt north
		current = tiltNorth(current)
		loadAfterNorth := countLoad(current)
		// Tilt west
		current = rotateRight(current)
		current = tiltNorth(current)
		// Tilt south
		current = rotateRight(current)
		current = tiltNorth(current)
		// Tilt east
		current = rotateRight(current)
		current = tiltNorth(current)
		// Rotate back
		current = rotateRight(current)
		loadAfterCycle := countLoad(current)

		// Check for cycle
		for j := i; j > 0; j-- {
			prevLoadAfterNorth := loads[j-1][0]
			prevLoadAfterCycle := loads[j-1][1]

			if prevLoadAfterNorth == loadAfterNorth && prevLoadAfterCycle == loadAfterCycle {
				// Cycle found
				cycleStart = j
			}
		}

		if cycleStart >= 0 {
			cycleLength := i - cycleStart + 1

			mod := maxCycles % cycleLength

			for k := 0; k < cycleLength; k++ {
				if (cycleStart+k)%cycleLength == mod {
					return loads[k+cycleStart-1][1]
				}
				k++
			}
		}

		loads = append(loads, []int{loadAfterNorth, loadAfterCycle})

		isDifferent := false

		for j, line := range current {
			if line != previous[j] {
				isDifferent = true
				break
			}
		}

		if !isDifferent {
			break
		}

		previous = current
	}

	return countLoad(previous)
}

func fourteen(input string) (int, int) {
	return fourteenPartOne(input), fourteenPartTwo(input)
}
