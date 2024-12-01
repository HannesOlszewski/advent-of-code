type Card =
  | "A"
  | "K"
  | "Q"
  | "J"
  | "T"
  | "9"
  | "8"
  | "7"
  | "6"
  | "5"
  | "4"
  | "3"
  | "2";

type HandType =
  | "Five of a Kind"
  | "Four of a Kind"
  | "Full House"
  | "Three of a Kind"
  | "Two Pairs"
  | "One Pair"
  | "High Card";

interface Hand {
  cards: Card[];
  bid: number;
}

function parseInput(input: string): Hand[] {
  return input.split("\n").map((line) => {
    const [cards, bid] = line.split(" ");

    return {
      cards: cards.split("") as Card[],
      bid: parseInt(bid, 10),
    };
  });
}

let jIsJokerWildcard = false;

function getHandType(hand: Hand): HandType {
  let isFiveOfAKind = hand.cards.every((card) => card === hand.cards[0]);
  let isFourOfAKind = false;
  let isFullHouse = false;
  let isThreeOfAKind = false;
  let isTwoPairs = false;
  let isOnePair = false;
  let numJokers = 0;
  const pairTypes: Card[] = [];

  for (const card of hand.cards) {
    const count = hand.cards.filter((c) => c === card).length;

    if (card === "J" && jIsJokerWildcard) {
      numJokers++;
      continue;
    }

    if (count === 4) {
      isFourOfAKind = true;
    } else if (count === 3) {
      isThreeOfAKind = true;

      if (isOnePair) {
        isFullHouse = true;
      }
    } else if (count === 2) {
      if (isOnePair && !pairTypes.includes(card)) {
        isTwoPairs = true;
      } else {
        isOnePair = true;
      }

      if (isThreeOfAKind) {
        isFullHouse = true;
      }

      pairTypes.push(card);
    }
  }

  if (jIsJokerWildcard && numJokers > 0) {
    if (numJokers === 1) {
      if (isFourOfAKind) {
        isFiveOfAKind = true;
      } else if (isThreeOfAKind) {
        isFourOfAKind = true;
      } else if (isTwoPairs) {
        isFullHouse = true;
      } else if (isOnePair) {
        isThreeOfAKind = true;
      } else {
        isOnePair = true;
      }
    } else if (numJokers === 2) {
      if (isThreeOfAKind) {
        isFiveOfAKind = true;
      } else if (isOnePair) {
        isFourOfAKind = true;
      } else {
        isThreeOfAKind = true;
      }
    } else if (numJokers === 3) {
      if (isOnePair) {
        isFiveOfAKind = true;
      } else {
        isFourOfAKind = true;
      }
    } else if (numJokers === 4 || numJokers === 5) {
      isFiveOfAKind = true;
    }
  }

  if (isFiveOfAKind) {
    return "Five of a Kind";
  } else if (isFourOfAKind) {
    return "Four of a Kind";
  } else if (isFullHouse) {
    return "Full House";
  } else if (isThreeOfAKind) {
    return "Three of a Kind";
  } else if (isTwoPairs) {
    return "Two Pairs";
  } else if (isOnePair) {
    return "One Pair";
  } else {
    return "High Card";
  }
}

const handTypeStrength: Record<HandType, number> = {
  "Five of a Kind": 6,
  "Four of a Kind": 5,
  "Full House": 4,
  "Three of a Kind": 3,
  "Two Pairs": 2,
  "One Pair": 1,
  "High Card": 0,
};

const cardStrength: Record<Card, number> = {
  A: 14,
  K: 13,
  Q: 12,
  J: 11,
  T: 10,
  "9": 9,
  "8": 8,
  "7": 7,
  "6": 6,
  "5": 5,
  "4": 4,
  "3": 3,
  "2": 2,
};

function compareHandsOfSameType(hand1: Hand, hand2: Hand): number {
  for (let i = 0; i < hand1.cards.length; i++) {
    const card1 = hand1.cards[i];
    const card2 = hand2.cards[i];

    if (cardStrength[card1] > cardStrength[card2]) {
      return 1;
    } else if (cardStrength[card1] < cardStrength[card2]) {
      return -1;
    }
  }

  return 0;
}

function compareHands(hand1: Hand, hand2: Hand): number {
  const handOneStrength = handTypeStrength[getHandType(hand1)];
  const handTwoStrength = handTypeStrength[getHandType(hand2)];

  if (handOneStrength !== handTwoStrength) {
    return handOneStrength - handTwoStrength;
  }

  return compareHandsOfSameType(hand1, hand2);
}

function getTotalWinnings(hands: Hand[]): number {
  const sortedHands = hands.sort(compareHands);
  const winnings = sortedHands.map((hand, index) => hand.bid * (index + 1));

  return winnings.reduce((acc, curr) => acc + curr, 0);
}

export function partOne(input: string): number {
  jIsJokerWildcard = false;
  const hands = parseInput(input);

  return getTotalWinnings(hands);
}

export function partTwo(input: string): number {
  jIsJokerWildcard = true;
  cardStrength.J = 1;
  const hands = parseInput(input);

  return getTotalWinnings(hands);
}

export function daySeven(input: string): [number, number] {
  return [partOne(input), partTwo(input)];
}
