package main

import (
	"log"
	"math"
	"slices"
	"strconv"
	"strings"
)

type Point3D struct {
	x int
	y int
	z int
}

func parsePoint3D(line string) Point3D {
	parts := strings.Split(line, ",")
	xPart, err1 := strconv.ParseInt(parts[0], 10, 64)
	yPart, err2 := strconv.ParseInt(parts[1], 10, 64)
	zPart, err3 := strconv.ParseInt(parts[2], 10, 64)

	if err1 != nil || err2 != nil || err3 != nil {
		log.Fatal(err1, err2, err3)
	}

	return Point3D{int(xPart), int(yPart), int(zPart)}
}

func euclidDistance3D(a, b Point3D) float64 {
	xPart := math.Pow(float64(a.x-b.x), 2)
	yPart := math.Pow(float64(a.y-b.y), 2)
	zPart := math.Pow(float64(a.z-b.z), 2)

	return math.Sqrt(xPart + yPart + zPart)
}

func DayEightPartOne(input string) string {
	lines := strings.SplitSeq(input, "\n")
	points := []Point3D{}
	circuits := [][]Point3D{}
	distances := make(map[float64][][2]Point3D)
	numConnectionsToMake := 1000

	for line := range lines {
		point := parsePoint3D(line)
		points = append(points, point)
	}

	for _, point := range points {
		for _, otherPoint := range points {
			distance := euclidDistance3D(point, otherPoint)

			if distance == 0 {
				continue
			}

			if _, ok := distances[distance]; !ok {
				distances[distance] = [][2]Point3D{}
			}

			distances[distance] = append(distances[distance], [2]Point3D{point, otherPoint})
		}
	}

	if len(points) == 20 {
		// test input
		numConnectionsToMake = 10
	}

	distancesKeys := make([]float64, 0, len(distances))
	for key := range distances {
		distancesKeys = append(distancesKeys, key)
	}

	slices.Sort(distancesKeys)

	connections := [][2]Point3D{}

	for _, key := range distancesKeys {
		if len(connections) >= numConnectionsToMake {
			break
		}

		pointsAtDistance := distances[key]

		for _, points := range pointsAtDistance {
			if len(connections) >= numConnectionsToMake {
				break
			}

			connectionExists := false
			for _, connection := range connections {
				if (points[0] == connection[0] && points[1] == connection[1]) || (points[1] == connection[0] && points[0] == connection[1]) {
					connectionExists = true
					break
				}
			}

			if connectionExists {
				continue
			}

			connections = append(connections, points)

			circuitContainingFirstPoint := -1
			circuitContainingSecondPoint := -1

			for circuitIndex, circuit := range circuits {
				containsFirst := slices.Contains(circuit, points[0])
				containsSecond := slices.Contains(circuit, points[1])

				if containsFirst {
					circuitContainingFirstPoint = circuitIndex
				}

				if containsSecond {
					circuitContainingSecondPoint = circuitIndex
				}
			}

			if circuitContainingFirstPoint == -1 && circuitContainingSecondPoint == -1 {
				circuits = append(circuits, []Point3D{points[0], points[1]})
			} else if circuitContainingFirstPoint != -1 && circuitContainingSecondPoint == -1 {
				circuits[circuitContainingFirstPoint] = append(circuits[circuitContainingFirstPoint], points[1])
			} else if circuitContainingFirstPoint == -1 && circuitContainingSecondPoint != -1 {
				circuits[circuitContainingSecondPoint] = append(circuits[circuitContainingSecondPoint], points[0])
			} else if circuitContainingFirstPoint != circuitContainingSecondPoint {
				// both are in different circuits, connect those
				if circuitContainingFirstPoint < circuitContainingSecondPoint {
					circuits[circuitContainingFirstPoint] = append(circuits[circuitContainingFirstPoint], circuits[circuitContainingSecondPoint]...)
					circuits = slices.Delete(circuits, circuitContainingSecondPoint, circuitContainingSecondPoint+1)
				} else {
					circuits[circuitContainingSecondPoint] = append(circuits[circuitContainingSecondPoint], circuits[circuitContainingFirstPoint]...)
					circuits = slices.Delete(circuits, circuitContainingFirstPoint, circuitContainingFirstPoint+1)
				}
			}
		}
	}

	slices.SortFunc(circuits, func(a, b []Point3D) int {
		return len(b) - len(a)
	})

	result := 1

	if len(circuits) > 0 {
		result *= len(circuits[0])
	}
	if len(circuits) > 1 {
		result *= len(circuits[1])
	}
	if len(circuits) > 2 {
		result *= len(circuits[2])
	}

	return strconv.FormatInt(int64(result), 10)
}

func DayEightPartTwo(input string) string {
	lines := strings.SplitSeq(input, "\n")
	points := []Point3D{}
	circuits := [][]Point3D{}
	distances := make(map[float64][][2]Point3D)

	for line := range lines {
		point := parsePoint3D(line)
		points = append(points, point)
	}

	for _, point := range points {
		for _, otherPoint := range points {
			distance := euclidDistance3D(point, otherPoint)

			if distance == 0 {
				continue
			}

			if _, ok := distances[distance]; !ok {
				distances[distance] = [][2]Point3D{}
			}

			distances[distance] = append(distances[distance], [2]Point3D{point, otherPoint})
		}
	}

	distancesKeys := make([]float64, 0, len(distances))
	for key := range distances {
		distancesKeys = append(distancesKeys, key)
	}

	slices.Sort(distancesKeys)

	connections := [][2]Point3D{}

	for _, key := range distancesKeys {
		if len(circuits) > 0 && len(circuits[0]) == len(points) {
			break
		}

		pointsAtDistance := distances[key]

		for _, pointsAtDistancePair := range pointsAtDistance {
			if len(circuits) > 0 && len(circuits[0]) == len(points) {
				break
			}

			connectionExists := false
			for _, connection := range connections {
				if (pointsAtDistancePair[0] == connection[0] && pointsAtDistancePair[1] == connection[1]) || (pointsAtDistancePair[1] == connection[0] && pointsAtDistancePair[0] == connection[1]) {
					connectionExists = true
					break
				}
			}

			if connectionExists {
				continue
			}

			connections = append(connections, pointsAtDistancePair)

			circuitContainingFirstPoint := -1
			circuitContainingSecondPoint := -1

			for circuitIndex, circuit := range circuits {
				containsFirst := slices.Contains(circuit, pointsAtDistancePair[0])
				containsSecond := slices.Contains(circuit, pointsAtDistancePair[1])

				if containsFirst {
					circuitContainingFirstPoint = circuitIndex
				}

				if containsSecond {
					circuitContainingSecondPoint = circuitIndex
				}
			}

			if circuitContainingFirstPoint == -1 && circuitContainingSecondPoint == -1 {
				circuits = append(circuits, []Point3D{pointsAtDistancePair[0], pointsAtDistancePair[1]})
			} else if circuitContainingFirstPoint != -1 && circuitContainingSecondPoint == -1 {
				circuits[circuitContainingFirstPoint] = append(circuits[circuitContainingFirstPoint], pointsAtDistancePair[1])
			} else if circuitContainingFirstPoint == -1 && circuitContainingSecondPoint != -1 {
				circuits[circuitContainingSecondPoint] = append(circuits[circuitContainingSecondPoint], pointsAtDistancePair[0])
			} else if circuitContainingFirstPoint != circuitContainingSecondPoint {
				// both are in different circuits, connect those
				if circuitContainingFirstPoint < circuitContainingSecondPoint {
					circuits[circuitContainingFirstPoint] = append(circuits[circuitContainingFirstPoint], circuits[circuitContainingSecondPoint]...)
					circuits = slices.Delete(circuits, circuitContainingSecondPoint, circuitContainingSecondPoint+1)
				} else {
					circuits[circuitContainingSecondPoint] = append(circuits[circuitContainingSecondPoint], circuits[circuitContainingFirstPoint]...)
					circuits = slices.Delete(circuits, circuitContainingFirstPoint, circuitContainingFirstPoint+1)
				}
			}
		}
	}

	slices.SortFunc(circuits, func(a, b []Point3D) int {
		return len(b) - len(a)
	})

	lastConnectionMade := connections[len(connections)-1]
	result := lastConnectionMade[0].x * lastConnectionMade[1].x

	return strconv.FormatInt(int64(result), 10)
}
