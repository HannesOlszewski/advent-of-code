package main

import (
	"log"
	"slices"
	"strconv"
	"strings"
)

type Point struct {
	col int
	row int
}

func DaySevenPartOne(input string) string {
	lines := strings.Split(input, "\n")
	numSplits := 0
	const empty = '.'
	const splitterNotActivated = '^'
	const splitterActivated = 'v'

	startingPointIndex := int(len(lines[0]) / 2)
	activeBeams := []Point{{startingPointIndex, 1}}

	for len(activeBeams) > 0 {
		// Keep the beams as a stack (lifo) to be able to easily remove the active beam at the end when finished
		beamIndex := len(activeBeams) - 1
		beam := activeBeams[beamIndex]

		for beam.row < len(lines) && lines[beam.row][beam.col] == empty {
			beam.row++
		}

		if beam.row == len(lines) {
			// beam is out of bounds, remove it
			activeBeams = activeBeams[:beamIndex]
			continue
		}

		cellValue := lines[beam.row][beam.col]

		if cellValue == splitterActivated {
			// another beam has already activated this splitter, remove it
			activeBeams = activeBeams[:beamIndex]
			continue
		}

		if cellValue != splitterNotActivated {
			log.Fatalf("Beam at %v should be at an not activated splitter (%s), but is %s", beam, string(splitterNotActivated), string(cellValue))
		}

		lines[beam.row] = lines[beam.row][:beam.col] + string(splitterActivated) + lines[beam.row][beam.col+1:]
		numSplits++

		activeBeams = activeBeams[:beamIndex]

		if beam.col > 0 {
			activeBeams = append(activeBeams, Point{beam.col - 1, beam.row})
		}
		if beam.col < len(lines[beam.row])-1 {
			activeBeams = append(activeBeams, Point{beam.col + 1, beam.row})
		}
	}

	return strconv.FormatInt(int64(numSplits), 10)
}

func DaySevenPartTwo(input string) string {
	const empty = '.'
	const beamCell = '|'
	const splitterNotActivated = '^'
	const splitterActivated = 'v'

	type Splitter struct {
		inputs   []*Splitter
		outputs  []*Splitter
		position Point
		active   bool
		count    int
	}

	type Beam struct {
		position Point
		from     *Splitter
	}

	lines := strings.Split(input, "\n")
	total := 0

	startingPointIndex := int(len(lines[0]) / 2)
	initialSplitter := &Splitter{[]*Splitter{}, []*Splitter{}, Point{startingPointIndex, 2}, true, 0}
	allSplitters := []*Splitter{initialSplitter}
	// active beams start left and right of the initial splitter, as if it was just hit
	activeBeams := []Beam{{Point{initialSplitter.position.col - 1, initialSplitter.position.row}, initialSplitter}, {Point{initialSplitter.position.col + 1, initialSplitter.position.row}, initialSplitter}}

	for len(activeBeams) > 0 {
		beam := activeBeams[0]

		for beam.position.row < len(lines) && (lines[beam.position.row][beam.position.col] == empty || lines[beam.position.row][beam.position.col] == beamCell) {
			lines[beam.position.row] = lines[beam.position.row][:beam.position.col] + string(beamCell) + lines[beam.position.row][beam.position.col+1:]
			beam.position.row++
		}

		if beam.position.row == len(lines) {
			// beam is out of bounds, remove it
			activeBeams = activeBeams[1:]
			continue
		}

		cellValue := lines[beam.position.row][beam.position.col]

		if cellValue == splitterActivated {
			// another beam has already activated this splitter, remove it
			activeBeams = activeBeams[1:]

			for _, splitter := range allSplitters {
				if splitter.position.col == beam.position.col && splitter.position.row == beam.position.row {
					splitter.inputs = append(splitter.inputs, beam.from)
					beam.from.outputs = append(beam.from.outputs, splitter)
				}
			}

			continue
		}

		if cellValue != splitterNotActivated {
			log.Fatalf("Beam at %v should be at an not activated splitter (%s), but is %s", beam, string(splitterNotActivated), string(cellValue))
		}

		lines[beam.position.row] = lines[beam.position.row][:beam.position.col] + string(splitterActivated) + lines[beam.position.row][beam.position.col+1:]

		activeBeams = activeBeams[1:]
		splitter := &Splitter{[]*Splitter{beam.from}, []*Splitter{}, beam.position, true, 0}
		beam.from.outputs = append(beam.from.outputs, splitter)
		allSplitters = append(allSplitters, splitter)

		if beam.position.col > 0 {
			activeBeams = append(activeBeams, Beam{Point{beam.position.col - 1, beam.position.row}, splitter})
		}
		if beam.position.col < len(lines[beam.position.row])-1 {
			activeBeams = append(activeBeams, Beam{Point{beam.position.col + 1, beam.position.row}, splitter})
		}
	}

	splitterQueue := []*Splitter{initialSplitter}
	visited := make(map[*Splitter]bool)

	for len(splitterQueue) > 0 {
		// always sort splitters by row to perform a breadth first search
		slices.SortFunc(splitterQueue, func(a, b *Splitter) int {
			return a.position.row - b.position.row
		})
		splitter := splitterQueue[0]

		alreadyVisited := visited[splitter]
		if alreadyVisited {
			// already calculated this one
			splitterQueue = splitterQueue[1:]
			continue
		}
		visited[splitter] = true

		if len(splitter.inputs) == 0 {
			splitter.count = 1 // from the starting point
		}

		for _, output := range splitter.outputs {
			output.count += splitter.count
		}

		splitterQueue = splitterQueue[1:]

		if len(splitter.outputs) > 0 {
			splitterQueue = append(splitterQueue, splitter.outputs...)
		}
	}

	for _, splitter := range allSplitters {
		// a splitter that is not a complete leaf might still have a single beam that leaves the area
		if len(splitter.outputs) <= 1 {
			total += splitter.count * (2 - len(splitter.outputs))
		}
	}

	return strconv.FormatInt(int64(total), 10)
}
