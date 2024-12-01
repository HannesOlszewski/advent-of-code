package main

import "strings"

func isNumber(char rune) bool {
	return char >= '0' && char <= '9'
}

func isSymbol(char rune) bool {
	return !isNumber(char) && char != '.'
}

func hasAdjacentSymbol(lines []string, row int, col int) bool {
	// left
	if col > 0 && isSymbol(rune(lines[row][col-1])) {
		return true
	}

	// right
	if col < len(lines[row])-1 && isSymbol(rune(lines[row][col+1])) {
		return true
	}

	// up
	if row > 0 && isSymbol(rune(lines[row-1][col])) {
		return true
	}

	// down
	if row < len(lines)-1 && isSymbol(rune(lines[row+1][col])) {
		return true
	}

	// top-right
	if col < len(lines[row])-1 && row > 0 && isSymbol(rune(lines[row-1][col+1])) {
		return true
	}

	// top-left
	if col > 0 && row > 0 && isSymbol(rune(lines[row-1][col-1])) {
		return true
	}

	// bottom-right
	if col < len(lines[row])-1 && row < len(lines)-1 && isSymbol(rune(lines[row+1][col+1])) {
		return true
	}

	// bottom-left
	if col > 0 && row < len(lines)-1 && isSymbol(rune(lines[row+1][col-1])) {
		return true
	}

	return false
}

func threePartOne(input string) int {
	lines := strings.Split(input, "\n")
	sum := 0
	numberToAdd := 0
	addToSum := false

	for row, line := range lines {
		for col, char := range line {
			if isNumber(char) {
				numberToAdd = numberToAdd*10 + int(char-'0')

				if !addToSum && hasAdjacentSymbol(lines, row, col) {
					addToSum = true
				}
			}

			if col == len(line)-1 || (!isNumber(char) && numberToAdd > 0) {
				if addToSum {
					sum += numberToAdd
				}

				addToSum = false
				numberToAdd = 0
			}
		}
	}

	return sum
}

type Coordinate struct {
	row int
	col int
}

func (c Coordinate) isAdjacentTo(other Coordinate) bool {
	if c.row == other.row {
		return c.col == other.col-1 || c.col == other.col+1
	}

	if c.row == other.row-1 {
		return c.col == other.col-1 || c.col == other.col || c.col == other.col+1
	}

	if c.row == other.row+1 {
		return c.col == other.col-1 || c.col == other.col || c.col == other.col+1
	}

	return false
}

type Number struct {
	value       int
	coordinates []Coordinate
}

func hasAdjacentGear(lines []string, row int, col int) bool {
	// left
	if col > 0 && lines[row][col-1] == '*' {
		return true
	}

	// right
	if col < len(lines[row])-1 && lines[row][col+1] == '*' {
		return true
	}

	// up
	if row > 0 && lines[row-1][col] == '*' {
		return true
	}

	// down
	if row < len(lines)-1 && lines[row+1][col] == '*' {
		return true
	}

	// top-right
	if col < len(lines[row])-1 && row > 0 && lines[row-1][col+1] == '*' {
		return true
	}

	// top-left
	if col > 0 && row > 0 && lines[row-1][col-1] == '*' {
		return true
	}

	// bottom-right
	if col < len(lines[row])-1 && row < len(lines)-1 && lines[row+1][col+1] == '*' {
		return true
	}

	// bottom-left
	if col > 0 && row < len(lines)-1 && lines[row+1][col-1] == '*' {
		return true
	}

	return false
}

func threePartTwo(input string) int {
	// TODO: Idea: same as part one, but instead of summing the numbers, store the coordinates of the numbers
	// TODO: Also, store the coordinates of '*' symbols
	// TODO: Then, for each '*', check if there are exactly two numbers adjacent to it
	// TODO: If so, multiply the numbers and add these to the sum instead
	lines := strings.Split(input, "\n")
	numbers := []Number{}
	gears := []Coordinate{}
	numberToAdd := Number{value: 0, coordinates: []Coordinate{}}
	shouldAddNumber := false

	for row, line := range lines {
		for col, char := range line {
			if isNumber(char) {
				numberToAdd.value = numberToAdd.value*10 + int(char-'0')
				numberToAdd.coordinates = append(numberToAdd.coordinates, Coordinate{row: row, col: col})

				if hasAdjacentGear(lines, row, col) {
					shouldAddNumber = true
				}
			}

			if col == len(line)-1 || (!isNumber(char) && numberToAdd.value > 0) {
				if shouldAddNumber {
					numbers = append(numbers, numberToAdd)
				}

				shouldAddNumber = false
				numberToAdd = Number{value: 0, coordinates: []Coordinate{}}
			}

			if isSymbol(char) && char == '*' {
				gears = append(gears, Coordinate{row: row, col: col})
			}
		}
	}

	sum := 0

	for _, gear := range gears {
		adjacentNumbers := []Number{}

		for _, number := range numbers {
			for _, coordinate := range number.coordinates {
				if gear.isAdjacentTo(coordinate) {
					adjacentNumbers = append(adjacentNumbers, number)
					break
				}
			}
		}

		if len(adjacentNumbers) == 2 {
			sum += adjacentNumbers[0].value * adjacentNumbers[1].value
		}
	}

	return sum
}

func three(input string) (int, int) {
	return threePartOne(input), threePartTwo(input)
}
