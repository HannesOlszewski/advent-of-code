package main

import (
	"slices"
	"strings"
)

const (
	EmptySpace         = '.'
	MirrorA            = '/'
	MirrorB            = '\\'
	VerticalSplitter   = '|'
	HorizontalSplitter = '-'
	Up                 = 0
	Left               = 1
	Down               = 2
	Right              = 3
)

type Beam struct {
	row int
	col int
	dir int
}

func runBeamsAndCountVisitedFields(lines []string, initialBeam Beam) int {
	beams := []Beam{initialBeam}
	numRows := len(lines)
	numCols := len(lines[0])
	visited := make([][]bool, numRows)
	activatedSplitters := make([][]bool, numRows)

	for i := range visited {
		visited[i] = make([]bool, numCols)
		activatedSplitters[i] = make([]bool, numCols)

		for j := range visited[i] {
			visited[i][j] = false
			activatedSplitters[i][j] = false
		}
	}

	for len(beams) > 0 {
		newBeams := []Beam{}
		exitedBeams := []int{}

		for i := range beams {
			beam := &beams[i]
			// Move beam

			visited[beam.row][beam.col] = true
			// 2. If beam hits splitter in splitting direction, set this beam to right/up and add a new beam to newBeams in left/down direction
			field := lines[beam.row][beam.col]

			if field == VerticalSplitter && (beam.dir == Right || beam.dir == Left) {
				if activatedSplitters[beam.row][beam.col] {
					exitedBeams = append(exitedBeams, i)
					continue
				}
				beam.dir = Up
				newBeams = append(newBeams, Beam{beam.row, beam.col, Down})
				activatedSplitters[beam.row][beam.col] = true
			}

			if field == HorizontalSplitter && (beam.dir == Up || beam.dir == Down) {
				if activatedSplitters[beam.row][beam.col] {
					exitedBeams = append(exitedBeams, i)
					continue
				}
				beam.dir = Right
				newBeams = append(newBeams, Beam{beam.row, beam.col, Left})
				activatedSplitters[beam.row][beam.col] = true
			}
			// 3. If beam hits mirror, set direction accordingly
			if field == MirrorA {
				switch beam.dir {
				case Up:
					beam.dir = Right
				case Left:
					beam.dir = Down
				case Down:
					beam.dir = Left
				case Right:
					beam.dir = Up
				}
			}

			if field == MirrorB {
				switch beam.dir {
				case Up:
					beam.dir = Left
				case Left:
					beam.dir = Up
				case Down:
					beam.dir = Right
				case Right:
					beam.dir = Down
				}
			}

			// 4. Adjust row/col according to dir
			switch beam.dir {
			case Up:
				beam.row--
			case Left:
				beam.col--
			case Down:
				beam.row++
			case Right:
				beam.col++
			}
			// 1. If beam goes out of bounds, remove it
			if beam.row < 0 || beam.col < 0 || beam.row >= numRows || beam.col >= numCols {
				exitedBeams = append(exitedBeams, i)
				continue
			}
		}

		// Make sure that indexes are removed from the end
		slices.Sort(exitedBeams)

		for e := len(exitedBeams) - 1; e >= 0; e-- {
			beamIndex := exitedBeams[e]
			beams = slices.Delete(beams, beamIndex, beamIndex+1)
		}

		beams = append(beams, newBeams...)
	}

	numVisited := 0

	for _, line := range visited {
		for _, isVisited := range line {
			if isVisited {
				numVisited++
			}
		}
	}

	return numVisited
}

func sixteenPartOne(input string) int {
	if string(input[len(input)-1]) == "\n" {
		input = input[:len(input)-1]
	}
	lines := strings.Split(input, "\n")
	initialBeam := Beam{0, 0, Right}

	return runBeamsAndCountVisitedFields(lines, initialBeam)
}

func sixteenPartTwo(input string) int {
	if string(input[len(input)-1]) == "\n" {
		input = input[:len(input)-1]
	}
	lines := strings.Split(input, "\n")
	startingPoints := []Beam{}
	maxEnergised := 0
	maxRow := len(lines) - 1
	maxCol := len(lines[0]) - 1

	for row := range lines {
		startingPoints = append(startingPoints, Beam{row, 0, Right}, Beam{row, maxCol, Left})
	}

	for col := range lines[0] {
		startingPoints = append(startingPoints, Beam{0, col, Down}, Beam{maxRow, col, Up})
	}

	for _, startingPoint := range startingPoints {
		numEnergised := runBeamsAndCountVisitedFields(lines, startingPoint)

		if numEnergised > maxEnergised {
			maxEnergised = numEnergised
		}
	}

	return maxEnergised
}

func sixteen(input string) (int, int) {
	return sixteenPartOne(input), sixteenPartTwo(input)
}
