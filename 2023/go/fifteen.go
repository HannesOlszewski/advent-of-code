package main

import (
	"slices"
	"strconv"
	"strings"
)

func sanitiseInput(input string) string {
	return strings.ReplaceAll(input, "\n", "")
}

func parseSteps(input string) []string {
	sanitisedInput := sanitiseInput(input)

	return strings.Split(sanitisedInput, ",")
}

func hash(str string) int {
	current := 0

	for i := 0; i < len(str); i++ {
		current += int(str[i])
		current *= 17
		current %= 256
	}

	return current
}

func fifteenPartOne(input string) int {
	steps := parseSteps(input)
	result := 0

	for _, step := range steps {
		result += hash(step)
	}

	return result
}

type Lens struct {
	label string
	value int
}

func parseOperation(step string) (string, int, bool) {
	isRemoveOperation := strings.Contains(step, "-")

	if isRemoveOperation {
		return step[:len(step)-1], -1, false
	}

	splitted := strings.Split(step, "=")

	label, value := splitted[0], splitted[1]

	intValue, err := strconv.Atoi(value)
	if err != nil {
		println("Step", step, "was recognised as add operation, but", value, "could not be converted to int")
		println(err)
		return label, -1, true
	}

	return label, intValue, false
}

func fifteenPartTwo(input string) int {
	steps := parseSteps(input)
	boxes := make([][]Lens, 256)

	for i := 0; i < len(boxes); i++ {
		boxes[i] = []Lens{}
	}

	for i := 0; i < len(steps); i++ {
		step := steps[i]
		label, value, err := parseOperation(step)

		if err {
			break
		}

		boxNr := hash(label)

		if value != -1 {
			lens := Lens{label, value}
			indexToReplace := -1

			for j, lensInBox := range boxes[boxNr] {
				if lensInBox.label == lens.label {
					indexToReplace = j
					break
				}
			}

			if indexToReplace == -1 {
				boxes[boxNr] = append(boxes[boxNr], lens)
			} else {
				boxes[boxNr][indexToReplace] = lens
			}

			continue
		}

		lensIndexToRemove := -1

		for j, lensInBox := range boxes[boxNr] {
			if lensInBox.label == label {
				lensIndexToRemove = j
				break
			}
		}

		if lensIndexToRemove == -1 {
			// Lens is not in the box, nothing to remove
			continue
		}

		if lensIndexToRemove == 0 {
			if len(boxes[boxNr]) > 1 {
				boxes[boxNr] = boxes[boxNr][1:]
			} else {
				boxes[boxNr] = []Lens{}
			}
		} else if lensIndexToRemove == len(boxes[boxNr])-1 {
			boxes[boxNr] = boxes[boxNr][:lensIndexToRemove]
		} else {
			boxes[boxNr] = slices.Concat(boxes[boxNr][0:lensIndexToRemove], boxes[boxNr][lensIndexToRemove+1:])
		}
	}

	result := 0

	for i, box := range boxes {
		if len(box) == 0 {
			continue
		}
		for j, lens := range box {
			result += (i + 1) * (j + 1) * lens.value
		}
	}

	return result
}

func fifteen(input string) (int, int) {
	return fifteenPartOne(input), fifteenPartTwo(input)
}
