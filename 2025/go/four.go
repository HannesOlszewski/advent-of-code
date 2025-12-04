package main

import (
	"strconv"
	"strings"
)

func DayFourPartOne(input string) string {
	lines := strings.Split(input, "\n")
	const neighbourSign = '@'
	result := 0

	for rowIndex, row := range lines {
		for columnIndex, value := range row {
			if value != neighbourSign {
				continue
			}

			neighbourCount := 0
			hasTop := rowIndex > 0
			hasBottom := rowIndex < len(lines)-1
			hasLeft := columnIndex > 0
			hasRight := columnIndex < len(row)-1

			if hasLeft && hasTop && lines[rowIndex-1][columnIndex-1] == neighbourSign {
				neighbourCount++
			}

			if hasTop && lines[rowIndex-1][columnIndex] == neighbourSign {
				neighbourCount++
			}

			if hasTop && hasRight && lines[rowIndex-1][columnIndex+1] == neighbourSign {
				neighbourCount++
			}

			if hasRight && row[columnIndex+1] == neighbourSign {
				neighbourCount++
			}

			if hasRight && hasBottom && lines[rowIndex+1][columnIndex+1] == neighbourSign {
				neighbourCount++
			}

			if hasBottom && lines[rowIndex+1][columnIndex] == neighbourSign {
				neighbourCount++
			}

			if hasBottom && hasLeft && lines[rowIndex+1][columnIndex-1] == neighbourSign {
				neighbourCount++
			}

			if hasLeft && row[columnIndex-1] == neighbourSign {
				neighbourCount++
			}

			if neighbourCount <= 3 {
				result++
			}
		}
	}

	return strconv.FormatInt(int64(result), 10)
}

func DayFourPartTwo(input string) string {
	lines := strings.Split(input, "\n")
	const neighbourSign = '@'
	const emptySign = '.'
	result := 0
	hadRemoval := true
	theMap := make([][]rune, len(lines))

	for rowIndex, row := range lines {
		theMap[rowIndex] = make([]rune, len(row))

		for columnIndex, value := range row {
			theMap[rowIndex][columnIndex] = value
		}
	}

	for hadRemoval {
		hadRemoval = false

		for rowIndex, row := range theMap {
			for columnIndex, value := range row {
				if value != neighbourSign {
					continue
				}

				neighbourCount := 0
				hasTop := rowIndex > 0
				hasBottom := rowIndex < len(lines)-1
				hasLeft := columnIndex > 0
				hasRight := columnIndex < len(row)-1

				if hasLeft && hasTop && theMap[rowIndex-1][columnIndex-1] == neighbourSign {
					neighbourCount++
				}

				if hasTop && theMap[rowIndex-1][columnIndex] == neighbourSign {
					neighbourCount++
				}

				if hasTop && hasRight && theMap[rowIndex-1][columnIndex+1] == neighbourSign {
					neighbourCount++
				}

				if hasRight && row[columnIndex+1] == neighbourSign {
					neighbourCount++
				}

				if hasRight && hasBottom && theMap[rowIndex+1][columnIndex+1] == neighbourSign {
					neighbourCount++
				}

				if hasBottom && theMap[rowIndex+1][columnIndex] == neighbourSign {
					neighbourCount++
				}

				if hasBottom && hasLeft && theMap[rowIndex+1][columnIndex-1] == neighbourSign {
					neighbourCount++
				}

				if hasLeft && row[columnIndex-1] == neighbourSign {
					neighbourCount++
				}

				if neighbourCount <= 3 {
					result++
					theMap[rowIndex][columnIndex] = emptySign
					hadRemoval = true
				}
			}
		}
	}

	return strconv.FormatInt(int64(result), 10)
}
