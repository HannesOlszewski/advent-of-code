package main

import (
	"slices"
	"strconv"
	"strings"
)

const (
	FiveOfAKind  = 7
	FourOfAKind  = 6
	FullHouse    = 5
	ThreeOfAKind = 4
	TwoPair      = 3
	OnePair      = 2
	HighCard     = 1
	Joker        = 1
)

type Round struct {
	hand       [5]int
	bid        int
	typeOfHand int
}

func typeOfHand(hand *[5]int) int {
	counts := map[int]int{}

	for _, card := range hand {
		counts[card]++
	}

	numJokers := counts[Joker]

	isFourOfAKind := false
	isFullHouse := false
	isThreeOfAKind := false
	isTwoPair := false
	isPair := false

	for card, count := range counts {
		if card == Joker {
			continue
		}

		if count == 5 {
			return FiveOfAKind
		}

		if count == 4 {
			isFourOfAKind = true
		}

		if count == 3 {
			isThreeOfAKind = true

			if isPair {
				isFullHouse = true
			}
		}

		if count == 2 {
			if isPair {
				isTwoPair = true
			}

			isPair = true

			if isThreeOfAKind {
				isFullHouse = true
			}
		}
	}

	if numJokers == 1 {
		if isFourOfAKind {
			return FiveOfAKind
		}

		if isFullHouse {
			return FullHouse
		}

		if isThreeOfAKind {
			return FourOfAKind
		}

		if isTwoPair {
			return FullHouse
		}

		if isPair {
			return ThreeOfAKind
		}

		return OnePair
	}

	if numJokers == 2 {
		if isThreeOfAKind {
			return FiveOfAKind
		}

		if isPair {
			return FourOfAKind
		}

		return ThreeOfAKind
	}

	if numJokers == 3 {
		if isPair {
			return FiveOfAKind
		}

		return FourOfAKind
	}

	if numJokers > 3 {
		return FiveOfAKind
	}

	if isFourOfAKind {
		return FourOfAKind
	}

	if isFullHouse {
		return FullHouse
	}

	if isThreeOfAKind {
		return ThreeOfAKind
	}

	if isTwoPair {
		return TwoPair
	}

	if isPair {
		return OnePair
	}

	return HighCard
}

func getCardValues(jIsJoker bool) map[byte]int {
	cardValues := map[byte]int{
		'2': 2,
		'3': 3,
		'4': 4,
		'5': 5,
		'6': 6,
		'7': 7,
		'8': 8,
		'9': 9,
		'T': 10,
		'Q': 12,
		'K': 13,
		'A': 14,
	}

	if jIsJoker {
		cardValues['J'] = Joker
	} else {
		cardValues['J'] = 11
	}

	return cardValues
}

func parseRound(line string, jIsJoker bool) Round {
	round := Round{
		hand: [5]int{},
		bid:  0,
	}

	parts := strings.Split(line, " ")

	for i := 0; i < 5; i++ {
		card := parts[0][i]
		round.hand[i] = getCardValues(jIsJoker)[card]
	}

	bid, _ := strconv.Atoi(parts[1])
	round.bid = bid

	round.typeOfHand = typeOfHand(&round.hand)

	return round
}

func compareHands(a, b Round) int {
	if a.typeOfHand > b.typeOfHand {
		return 1
	}

	if a.typeOfHand < b.typeOfHand {
		return -1
	}

	for i := 0; i < 5; i++ {
		if a.hand[i] > b.hand[i] {
			return 1
		}

		if a.hand[i] < b.hand[i] {
			return -1
		}
	}

	return 0
}

func sevenPartOne(input string) int {
	lines := strings.Split(input, "\n")
	rounds := []Round{}

	for _, line := range lines {
		rounds = append(rounds, parseRound(line, false))
	}

	slices.SortStableFunc(rounds, compareHands)

	total := 0

	for i := 0; i < len(rounds); i++ {
		total += rounds[i].bid * (i + 1)
	}

	return total
}

func sevenPartTwo(input string) int {
	lines := strings.Split(input, "\n")
	rounds := []Round{}

	for _, line := range lines {
		rounds = append(rounds, parseRound(line, true))
	}

	slices.SortStableFunc(rounds, compareHands)

	total := 0

	for i := 0; i < len(rounds); i++ {
		total += rounds[i].bid * (i + 1)
	}

	return total
}

func seven(input string) (int, int) {
	return sevenPartOne(input), sevenPartTwo(input)
}
