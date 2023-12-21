import fs from "fs";

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

    if (card === "J") {
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

function getHandTypeStrength(handType: HandType): number {
  switch (handType) {
    case "Five of a Kind":
      return 6;
    case "Four of a Kind":
      return 5;
    case "Full House":
      return 4;
    case "Three of a Kind":
      return 3;
    case "Two Pairs":
      return 2;
    case "One Pair":
      return 1;
    case "High Card":
      return 0;
  }
}

function getCardStrength(card: Card): number {
  switch (card) {
    case "A":
      return 14;
    case "K":
      return 13;
    case "Q":
      return 12;
    case "T":
      return 10;
    case "9":
      return 9;
    case "8":
      return 8;
    case "7":
      return 7;
    case "6":
      return 6;
    case "5":
      return 5;
    case "4":
      return 4;
    case "3":
      return 3;
    case "2":
      return 2;
    case "J":
      return 1;
  }
}

function compareHandsOfSameType(hand1: Hand, hand2: Hand): number {
  for (let i = 0; i < hand1.cards.length; i++) {
    const card1 = hand1.cards[i];
    const card2 = hand2.cards[i];

    if (getCardStrength(card1) > getCardStrength(card2)) {
      return 1;
    } else if (getCardStrength(card1) < getCardStrength(card2)) {
      return -1;
    }
  }

  return 0;
}

function compareHands(hand1: Hand, hand2: Hand): number {
  const handOneStrength = getHandTypeStrength(getHandType(hand1));
  const handTwoStrength = getHandTypeStrength(getHandType(hand2));

  if (handOneStrength !== handTwoStrength) {
    return handOneStrength - handTwoStrength;
  }

  return compareHandsOfSameType(hand1, hand2);
}

const input = fs.readFileSync("input.txt", "utf8");
const hands: Hand[] = parseInput(input);
const sortedHands = hands.sort(compareHands);
const winnings = sortedHands.map((hand, index) => hand.bid * (index + 1));
const totalWinnings = winnings.reduce((acc, curr) => acc + curr, 0);

console.log(totalWinnings);
