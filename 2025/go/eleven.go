package main

import (
	"strconv"
	"strings"
)

func DayElevenPartOne(input string) string {
	lines := strings.SplitSeq(input, "\n")
	connections := map[string][]string{}
	total := 0
	const start = "you"
	const end = "out"

	for line := range lines {
		// format is aaa: bbb ccc ...
		//           ^^^^^^^^^^
		//        i= 0123456789...
		connections[line[:3]] = strings.Split(line[5:], " ")
	}

	queue := connections[start]

	for len(queue) > 0 {
		device := queue[0]
		queue = queue[1:]

		if device == end {
			total++
		} else {
			queue = append(queue, connections[device]...)
		}
	}

	return strconv.Itoa(total)
}

func findConnectionPaths(from string, to string, currentPath *[]string, validPathsCount *int, connections map[string][]string, cache map[string]bool) {
	if _, inCache := cache[from]; inCache {
		// already marked as not reaching the goal
		return
	}

	if from == to {
		*validPathsCount++
		return
	}

	*currentPath = append(*currentPath, from)
	nextDevices, exists := connections[from]

	if !exists || len(nextDevices) == 0 {
		cache[from] = false
		return
	}

	for _, device := range nextDevices {
		pathLengthBefore := len(*currentPath)
		findConnectionPaths(device, to, currentPath, validPathsCount, connections, cache)

		pathLengthAfter := len(*currentPath)
		if pathLengthBefore < pathLengthAfter {
			*currentPath = (*currentPath)[:pathLengthBefore]
		}
	}

	for _, device := range nextDevices {
		_, inCache := cache[device]

		if !inCache {
			// if it is not in the cache, it (might still) lead to the goal
			return
		}
	}

	// all next devices must have been in the cache (being false)
	cache[from] = false
}

func DayElevenPartTwo(input string) string {
	lines := strings.SplitSeq(input, "\n")
	connections := map[string][]string{}
	const start = "svr"
	const end = "out"

	for line := range lines {
		// format is aaa: bbb ccc ...
		//           ^^^^^^^^^^
		//        i= 0123456789...
		connections[line[:3]] = strings.Split(line[5:], " ")
	}

	total1 := 0
	findConnectionPaths(start, "fft", &[]string{}, &total1, connections, map[string]bool{})

	total2 := 0
	findConnectionPaths("fft", "dac", &[]string{}, &total2, connections, map[string]bool{})

	total3 := 0
	findConnectionPaths("dac", end, &[]string{}, &total3, connections, map[string]bool{})

	return strconv.Itoa(total1 * total2 * total3)
}
