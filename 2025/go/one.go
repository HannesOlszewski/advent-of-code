package main

import (
	"fmt"
	"log"
	"strconv"
	"strings"
)

func DayOnePartOne(input string) string {
	password := 0
	lines := strings.Split(input, "\n")
	var currentPoint int64 = 50

	for _, line := range lines {
		if len(line) == 0 {
			continue
		}

		direction := line[0]
		rotationValue, rotationParseErr := strconv.ParseInt(line[1:], 10, 16)
		if rotationParseErr != nil {
			log.Fatal(rotationParseErr)
		}
		rotationValue %= 100 // every full 100 rotation in either direction is neglectable

		if direction == 'L' {
			// Rotate left
			if rotationValue > currentPoint {
				currentPoint = 100 - (rotationValue - currentPoint)
			} else {
				currentPoint -= rotationValue
			}
		} else {
			// Rotate right
			currentPoint = (currentPoint + rotationValue) % 100
		}

		if currentPoint == 0 {
			password++
		}
	}

	return fmt.Sprintf("%d", password)
}

func DayOnePartTwo(input string) string {
	password := 0
	lines := strings.Split(input, "\n")
	var currentPoint int64 = 50

	for _, line := range lines {
		if len(line) == 0 {
			continue
		}

		direction := line[0]
		rotationValue, rotationParseErr := strconv.ParseInt(line[1:], 10, 16)
		if rotationParseErr != nil {
			log.Fatal(rotationParseErr)
		}
		password += int(rotationValue / 100)
		rotationValue %= 100 // every full 100 rotation in either direction is neglectable

		if direction == 'L' {
			// Rotate left
			if rotationValue > currentPoint {
				if currentPoint > 0 {
					password++
				}
				currentPoint = 100 - (rotationValue - currentPoint)
			} else {
				currentPoint -= rotationValue

				if currentPoint == 0 {
					password++
				}
			}
		} else {
			// Rotate right
			if currentPoint+rotationValue >= 100 {
				password++
			}
			currentPoint = (currentPoint + rotationValue) % 100
		}
	}

	return fmt.Sprintf("%d", password)
}
