package main

import (
	"strconv"
	"strings"
)

func isInvalidIdPartOne(id string) bool {
	if len(id)%2 == 1 {
		return false
	}

	digitCountToCheck := len(id) / 2

	for i := range digitCountToCheck {
		if id[i] != id[i+digitCountToCheck] {
			return false
		}
	}

	return true
}

func DayTwoPartOne(input string) string {
	var result int64 = 0
	ranges := strings.SplitSeq(input, ",")

	for idRange := range ranges {
		ids := strings.Split(idRange, "-")

		if len(ids) != 2 {
			panic("Wrong id range format")
		}

		start, err1 := strconv.ParseInt(ids[0], 10, 64)
		end, err2 := strconv.ParseInt(ids[1], 10, 64)

		if err1 != nil || err2 != nil {
			panic("Could not parse ids")
		}

		for id := start; id <= end; id++ {
			idString := strconv.FormatInt(id, 10)
			if isInvalidIdPartOne(idString) {
				result += id
			}
		}

	}

	return strconv.FormatInt(result, 10)
}

func isInvalidIdPartTwo(id string) bool {
	maxDigitCountToCheck := len(id) / 2

	for patternLength := range maxDigitCountToCheck + 1 {
		if patternLength == 0 || len(id)%patternLength != 0 {
			continue
		}

		pattern := id[:patternLength]
		isMatch := true

		for compareStartIndex := patternLength; compareStartIndex < len(id); compareStartIndex += patternLength {
			for digitIndex := range patternLength {
				if pattern[digitIndex] != id[compareStartIndex+digitIndex] {
					isMatch = false
					break
				}
			}

			if !isMatch {
				break
			}
		}

		if isMatch {
			return true
		}
	}

	return false
}

func DayTwoPartTwo(input string) string {
	var result int64 = 0
	ranges := strings.SplitSeq(input, ",")

	for idRange := range ranges {
		ids := strings.Split(idRange, "-")

		if len(ids) != 2 {
			panic("Wrong id range format")
		}

		start, err1 := strconv.ParseInt(ids[0], 10, 64)
		end, err2 := strconv.ParseInt(ids[1], 10, 64)

		if err1 != nil || err2 != nil {
			panic("Could not parse ids")
		}

		for id := start; id <= end; id++ {
			idString := strconv.FormatInt(id, 10)
			if isInvalidIdPartTwo(idString) {
				result += id
			}
		}

	}

	return strconv.FormatInt(result, 10)
}
