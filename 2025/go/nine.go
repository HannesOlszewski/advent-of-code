package main

import (
	"log"
	"strconv"
	"strings"
)

func calcArea(row1, col1, row2, col2 int) int {
	maxRow, minRow := row1, row2
	maxCol, minCol := col1, col2

	if minRow > maxRow {
		maxRow, minRow = minRow, maxRow
	}

	if minCol > maxCol {
		maxCol, minCol = minCol, maxCol
	}

	// the coordinates are 0-based, but the lengths need to be 1-based
	return (maxRow - minRow + 1) * (maxCol - minCol + 1)
}

func DayNinePartOne(input string) string {
	lines := strings.Split(input, "\n")
	points := make([]Point, 0, len(lines))

	for _, line := range lines {
		parts := strings.Split(line, ",")
		colPart, err1 := strconv.ParseInt(parts[0], 10, 64)
		rowPart, err2 := strconv.ParseInt(parts[1], 10, 64)

		if err1 != nil || err2 != nil {
			log.Fatal(err1, err2)
		}

		points = append(points, Point{int(colPart), int(rowPart)})
	}

	maxArea := 0

	for i, point := range points {
		for j, otherPoint := range points[i+1:] {
			if i == j {
				continue
			}

			area := calcArea(point.row, point.col, otherPoint.row, otherPoint.col)

			if area > maxArea {
				maxArea = area
			}
		}
	}

	return strconv.Itoa(maxArea)
}

func isInsidePolygon(col, row int, polygon []Point) bool {
	intersectUp, intersectDown, intersectLeft, intersectRight := 0, 0, 0, 0
	n := len(polygon)

	for i := range n {
		e1, e2 := polygon[i], polygon[(i+1)%n]

		if (col == e1.col && row == e1.row) || (col == e2.col && row == e2.row) {
			return true
		}

		if e1.row == e2.row {
			minC, maxC := e1.col, e2.col
			if minC > maxC {
				minC, maxC = maxC, minC
			}
			if col >= minC && col <= maxC {
				if row < e1.row {
					intersectDown++
				} else {
					intersectUp++
				}
			}
		} else {
			minR, maxR := e1.row, e2.row
			if minR > maxR {
				minR, maxR = maxR, minR
			}
			if row >= minR && row <= maxR {
				if col < e1.col {
					intersectRight++
				} else {
					intersectLeft++
				}
			}
		}
	}

	return intersectUp == 1 || intersectDown == 1 ||
		intersectLeft == 1 || intersectRight == 1
}

// Check if rectangle is entirely inside polygon by verifying no edge cuts through
func isRectangleInside(c1, r1, c2, r2 int, polygon []Point) bool {
	n := len(polygon)

	for i := range n {
		e1, e2 := polygon[i], polygon[(i+1)%n]

		if e1.row == e2.row {
			// Horizontal edge - check if it cuts through interior rows
			edgeRow := e1.row
			if edgeRow <= r1 || edgeRow >= r2 {
				continue
			}
			// Edge is strictly between r1 and r2, check column overlap
			minC, maxC := e1.col, e2.col
			if minC > maxC {
				minC, maxC = maxC, minC
			}
			if maxC > c1 && minC < c2 {
				return false // Edge cuts through rectangle
			}
		} else {
			// Vertical edge - check if it cuts through interior columns
			edgeCol := e1.col
			if edgeCol <= c1 || edgeCol >= c2 {
				continue
			}
			// Edge is strictly between c1 and c2, check row overlap
			minR, maxR := e1.row, e2.row
			if minR > maxR {
				minR, maxR = maxR, minR
			}
			if maxR > r1 && minR < r2 {
				return false // Edge cuts through rectangle
			}
		}
	}

	// No edge cuts through - verify center point is inside
	return isInsidePolygon((c1+c2)/2, (r1+r2)/2, polygon)
}

func DayNinePartTwo(input string) string {
	// Disclaimer: Claude Opus 4.5 has helped with optimizing my original implementation of this part
	// Neither the task description nor any input data was given to AI, just my previous code
	lines := strings.Split(input, "\n")
	points := make([]Point, 0, len(lines))

	for _, line := range lines {
		idx := strings.IndexByte(line, ',')
		col, _ := strconv.Atoi(line[:idx])
		row, _ := strconv.Atoi(line[idx+1:])
		points = append(points, Point{col, row})
	}

	maxArea := 0
	n := len(points)

	for i := range n {
		for j := i + 1; j < n; j++ {
			p1, p2 := points[i], points[j]

			c1, c2 := p1.col, p2.col
			if c1 > c2 {
				c1, c2 = c2, c1
			}
			r1, r2 := p1.row, p2.row
			if r1 > r2 {
				r1, r2 = r2, r1
			}

			area := (c2 - c1 + 1) * (r2 - r1 + 1)
			if area <= maxArea {
				continue // Early skip - can't beat current max
			}

			if isRectangleInside(c1, r1, c2, r2, points) {
				maxArea = area
			}
		}
	}

	return strconv.Itoa(maxArea)
}
