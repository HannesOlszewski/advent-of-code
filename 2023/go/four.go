package main

import (
	"strconv"
	"strings"
)

type Card struct {
	id             string
	winningNumbers []string
	ownNumbers     []string
}

func (c *Card) getId() int {
	id, _ := strconv.Atoi(c.id)

	return id
}

func (c *Card) countWinningPoints() int {
	points := 0

	for _, ownNumber := range c.ownNumbers {
		for _, winningNumber := range c.winningNumbers {
			if ownNumber != winningNumber || ownNumber == "" {
				continue
			}

			if points == 0 {
				points = 1
			} else {
				points *= 2
			}

			break
		}
	}

	return points
}

func (c *Card) countWinningNumbers() int {
	count := 0

	for _, ownNumber := range c.ownNumbers {
		for _, winningNumber := range c.winningNumbers {
			if ownNumber != winningNumber || ownNumber == "" {
				continue
			}

			count++
			break
		}
	}

	return count
}

func parseCard(line string) Card {
	parts := strings.Split(line, ": ")
	id := strings.Split(strings.ReplaceAll(parts[0], " ", ""), "Card")[1]
	numbers := strings.Split(parts[1], " | ")
	winningNumbers := strings.Split(numbers[0], " ")
	ownNumbers := strings.Split(numbers[1], " ")

	return Card{
		id:             id,
		winningNumbers: winningNumbers,
		ownNumbers:     ownNumbers,
	}
}

func fourPartOne(input string) int {
	lines := strings.Split(input, "\n")
	sum := 0

	for _, line := range lines {
		card := parseCard(line)
		sum += card.countWinningPoints()
	}

	return sum
}

func fourPartTwo(input string) int {
	lines := strings.Split(input, "\n")
	cardCounts := map[int]int{}

	for _, line := range lines {
		card := parseCard(line)
		id := card.getId()
		count := card.countWinningNumbers()
		_, exists := cardCounts[id]

		if exists {
			cardCounts[id]++
		} else {
			cardCounts[id] = 1
		}

		currentCount := cardCounts[id]

		for i := 1; i <= count; i++ {
			cardID := id + i
			_, exists := cardCounts[cardID]

			if exists {
				cardCounts[cardID] += currentCount
			} else {
				cardCounts[cardID] = currentCount
			}
		}
	}

	sum := 0

	for _, count := range cardCounts {
		sum += count
	}

	return sum
}

func four(input string) (int, int) {
	return fourPartOne(input), fourPartTwo(input)
}
