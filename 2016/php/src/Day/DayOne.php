<?php

namespace Aoc16\Day;

use Aoc16\Enum\Direction;
use Aoc16\Map\StringHashMap;
use Aoc16\Model\Point;
use Aoc16\Model\Step;

class DayOne implements DayInterface
{
    public function getDayNumber(): int
    {
        return 1;
    }

    public function partOne(string $input): string
    {
        $steps = self::parseInput($input);
        $position = new Point();
        $facingDirection = Direction::Up;

        foreach ($steps as $step) {
            $facingDirection = $facingDirection->turn($step->direction);
            $position->move($step->length, $facingDirection);
        }

        return (string) new Point()->countDistanceTo($position);
    }

    public function partTwo(string $input): string
    {
        $steps = self::parseInput($input);
        $position = new Point();
        $facingDirection = Direction::Up;
        $visitedPositions = new StringHashMap();
        $visitedPositions->set($position, true);

        foreach ($steps as $step) {
            $facingDirection = $facingDirection->turn($step->direction);

            for ($i = 0; $i < $step->length; $i++) {
                $position->move(1, $facingDirection);

                if ($visitedPositions->has($position)) {
                    return (string) new Point()->countDistanceTo($position);
                }

                $visitedPositions->set($position, true);
            }
        }

        throw new \LogicException('No step resulted in reaching the target');
    }

    /**
     * Parses the input into the direction+length parts.
     * Input must be a single line.
     *
     * @param string $input the input line
     *
     * @return Step[] the parsed input
     */
    private static function parseInput(string $input): array
    {
        $parts = explode(', ', $input);

        return array_map(static function (string $part) {
            $direction = Direction::from($part[0]);
            $length = (int) substr($part, 1);

            return new Step($direction, $length);
        }, $parts);
    }
}
