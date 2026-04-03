<?php

namespace Aoc16\Model;

use Aoc16\Enum\Direction;

class Point implements \Stringable
{
    public function __construct(
        public float $x = 0.0,
        public float $y = 0.0,
    ) {}

    public function move(float $length, Direction $direction): void
    {
        match ($direction) {
            Direction::Up => $this->y += $length,
            Direction::Down => $this->y -= $length,
            Direction::Left => $this->x -= $length,
            Direction::Right => $this->x += $length,
        };
    }

    public function countDistanceTo(self $other): float
    {
        $xDistance = abs($other->x - $this->x);
        $yDistance = abs($other->y - $this->y);

        return $xDistance + $yDistance;
    }

    public function __toString(): string
    {
        return "$this->x,$this->y";
    }
}
