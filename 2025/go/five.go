package main

import (
	"log"
	"math"
	"slices"
	"strconv"
	"strings"
)

func parseIdRanges(rangeLines []string) [][2]int64 {
	ranges := make([][2]int64, len(rangeLines))

	for i, line := range rangeLines {
		rangeBoundaries := strings.Split(line, "-")
		rangeStart, err1 := strconv.ParseInt(rangeBoundaries[0], 10, 64)
		rangeEnd, err2 := strconv.ParseInt(rangeBoundaries[1], 10, 64)

		if err1 != nil || err2 != nil {
			log.Fatal(err1, err2)
		}

		ranges[i][0] = rangeStart
		ranges[i][1] = rangeEnd
	}

	return ranges
}

func DayFivePartOne(input string) string {
	parts := strings.Split(input, "\n\n")
	rangeLines := strings.Split(parts[0], "\n")
	idLines := strings.SplitSeq(parts[1], "\n")
	ranges := parseIdRanges(rangeLines)
	freshCount := 0

	for idLine := range idLines {
		id, err := strconv.ParseInt(idLine, 10, 64)
		if err != nil {
			log.Fatal(err)
		}

		for _, idRange := range ranges {
			if id >= idRange[0] && id <= idRange[1] {
				freshCount++
				break
			}
		}
	}

	return strconv.FormatInt(int64(freshCount), 10)
}

func DayFivePartTwo(input string) string {
	parts := strings.Split(input, "\n\n")
	rangeLines := strings.Split(parts[0], "\n")
	ranges := parseIdRanges(rangeLines)
	freshCount := int64(0)

	// sort ranges primarily by range start and secondarily by range end so that neighbouring ranges can be merged when intersecting
	slices.SortFunc(ranges, func(a, b [2]int64) int {
		if a[0] < b[0] {
			return -1
		}

		if a[0] > b[0] {
			return 1
		}

		return int(a[1] - b[1])
	})

	// repeat merging of intersecting ranges until no can be mergend anymore
	// some might not intersect at the beginning but do after their neighbouring ranges have merged with others
	hadMerges := true
	for hadMerges {
		hadMerges = false

		for i := len(ranges) - 1; i > 0; i-- {
			current := &ranges[i]
			previous := &ranges[i-1]

			if current[0] <= previous[1] {
				// ranges intersect, join current into previous
				previous[1] = int64(math.Max(float64(previous[1]), float64(current[1])))
				ranges = slices.Delete(ranges, i, i+1)
				hadMerges = true
			}
		}
	}

	for _, idRange := range ranges {
		freshCount += idRange[1] - idRange[0] + 1
	}

	return strconv.FormatInt(freshCount, 10)
}
