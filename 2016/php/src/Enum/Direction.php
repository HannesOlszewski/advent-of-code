<?php

namespace Aoc16\Enum;

enum Direction: string
{
    case Up = 'U';
    case Down = 'D';
    case Left = 'L';
    case Right = 'R';

    public function turn(self $direction): self
    {
        if (!\in_array($direction, [self::Left, self::Right])) {
            return $this;
        }

        $isLeftTurn = self::Left === $direction;

        return match ($this) {
            self::Up => $isLeftTurn ? self::Left : self::Right,
            self::Down => $isLeftTurn ? self::Right : self::Left,
            self::Left => $isLeftTurn ? self::Down : self::Up,
            self::Right => $isLeftTurn ? self::Up : self::Down,
        };
    }
}
