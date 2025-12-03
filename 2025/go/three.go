package main

import (
	"log"
	"strconv"
	"strings"
)

func DayThreePartOne(input string) string {
	total := 0
	lines := strings.SplitSeq(input, "\n")

	for line := range lines {
		maxFirst, maxSecond := byte(0), byte(0)

		for firstIndex := 0; firstIndex < len(line)-1; firstIndex++ {
			if line[firstIndex] <= maxFirst {
				continue
			}

			maxFirst = line[firstIndex]
			maxSecond = line[firstIndex+1]

			for secondIndexOffset, secondValue := range line[firstIndex+1:] {
				secondIndex := firstIndex + secondIndexOffset + 1
				if secondValue <= rune(maxSecond) {
					continue
				}

				if secondValue > rune(maxFirst) && secondIndex < len(line)-1 {
					firstIndex = secondIndex - 1
					break
				}

				maxSecond = byte(secondValue)
			}
		}

		total += 10*int(maxFirst-'0') + int(maxSecond-'0')
	}

	return strconv.FormatInt(int64(total), 10)
}

func DayThreePartTwo(input string) string {
	total := int64(0)
	lines := strings.SplitSeq(input, "\n")
	const resultCount = 12

	for line := range lines {
		lineResult := make([]rune, resultCount)
		indexStart := 0
		// Go through the line for 0-11, for each index check the first i:len(line)-12-i digits and find the maximum
		// repeat recursively for each next index and line-rest

		for i := range resultCount {
			lastIndexToCheck := len(line) - (resultCount - i)
			currentIndexStart := indexStart

			for j, value := range line[currentIndexStart : lastIndexToCheck+1] {
				if value > lineResult[i] {
					lineResult[i] = value
					indexStart = currentIndexStart + j + 1
				}
			}
		}

		lineTotal, err := strconv.ParseInt(string(lineResult), 10, 64)
		if err != nil {
			log.Fatal(err)
		}
		total += lineTotal
	}

	return strconv.FormatInt(total, 10)
}
