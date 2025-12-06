package main

import (
	"log"
	"regexp"
	"strconv"
	"strings"
)

func DaySixPartOne(input string) string {
	lines := strings.Split(input, "\n")
	regexNumbers := regexp.MustCompile(`\d+`)
	regexOperands := regexp.MustCompile(`[+*]+`)
	problemsCount := len(regexNumbers.FindAllString(lines[0], -1))
	problems := make([][]int64, 0, problemsCount)
	total := int64(0)

	for numberIndex, line := range lines {
		if numberIndex < len(lines)-1 {
			numbers := regexNumbers.FindAllString(line, -1)

			if len(numbers) == 0 {
				log.Fatal("No numbers found")
			}

			for problemIndex, numberStr := range numbers {
				number, err := strconv.ParseInt(numberStr, 10, 64)
				if err != nil {
					log.Fatal(err)
				}

				if numberIndex == 0 {
					problems = append(problems, make([]int64, len(lines)-1))
				}

				problems[problemIndex][numberIndex] = number
			}
		} else {
			operands := regexOperands.FindAllString(line, -1)

			if len(operands) == 0 {
				log.Fatal("No operands found")
			}

			for problemIndex, operand := range operands {
				problemTotal := int64(0)

				if operand == "*" {
					// Multiplication needs to start at 1, otherwise the result will always be zero!
					problemTotal++
				}

				for _, number := range problems[problemIndex] {
					if operand == "+" {
						problemTotal += number
					} else {
						problemTotal *= number
					}
				}

				total += problemTotal
			}
		}
	}

	return strconv.FormatInt(total, 10)
}

func DaySixPartTwo(input string) string {
	lines := strings.Split(input, "\n")
	lineCount := len(lines)
	maxLineLength := len(lines[lineCount-1])
	total := 0

	sum := 0
	product := 1

	for columnIndex := maxLineLength - 1; columnIndex >= 0; columnIndex-- {
		number := 0

		for rowIndex := range lineCount - 1 {
			digit := lines[rowIndex][columnIndex]

			if digit != ' ' {
				number = number*10 + int(digit-'0')
			}
		}

		if number == 0 {
			continue
		}

		sum += number
		product *= number

		operand := lines[lineCount-1][columnIndex]

		switch operand {
		case '+':
			total += sum
			sum = 0
			product = 1
		case '*':
			total += product
			sum = 0
			product = 1
		}
	}

	// 9434900013640 is too low
	return strconv.FormatInt(int64(total), 10)
}
