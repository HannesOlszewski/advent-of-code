<?php

namespace Aoc16\Day;

class DayOne implements DayInterface
{
    private const string LEFT = 'L';
    private const string RIGHT = 'R';
    private const string UP = 'U';
    private const string DOWN = 'D';
    private const array START = [0, 0];

    public function partOne(string $input): string
    {
        $steps = self::parseInput($input);
        /** @var array{int,int} $start */
        $position = self::START;
        $facingDirection = self::UP;

        foreach ($steps as $step) {
            $facingDirection = self::turnFrom($facingDirection, $step['turn']);
            $position = self::walkFrom($position, $step['length'], $facingDirection);
        }

        return (string) self::countDistance(self::START, $position);
    }

    public function partTwo(string $input): string
    {
        $steps = self::parseInput($input);
        /** @var array{int,int} $start */
        $position = self::START;
        $facingDirection = self::UP;
        /** @var array<string, bool> $visitedPositions */
        $visitedPositions = [];
        $visitedPositions[self::hashPosition(self::START)] = true;

        foreach ($steps as $step) {
            $facingDirection = self::turnFrom($facingDirection, $step['turn']);
            
            for ($i = 0; $i < $step['length']; $i++) {
                $position = self::walkFrom($position, 1, $facingDirection);
                $positionId = self::hashPosition($position);

                if (isset($visitedPositions[$positionId])) {
                    return (string) self::countDistance(self::START, $position);
                }

                $visitedPositions[$positionId] = true;
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
     * @return array<array{turn:string,length:int}> the parsed input
     */
    private static function parseInput(string $input): array
    {
        $parts = explode(', ', $input);

        return array_map(static function (string $part) {
            $direction = $part[0];
            $length = (int) substr($part, 1);

            return ['turn' => $direction, 'length' => $length];
         }, $parts);
    }

    private static function turnFrom(string $currentDirection, string $turn): string
    {
        $isLeftTurn = self::LEFT === $turn;

        return match ($currentDirection) {
            self::UP => $isLeftTurn ? self::LEFT : self::RIGHT,
            self::LEFT => $isLeftTurn ? self::DOWN : self::UP,
            self::DOWN => $isLeftTurn ? self::RIGHT : self::LEFT,
            self::RIGHT => $isLeftTurn ? self::UP : self::DOWN,
            default => $currentDirection,
        };
    }

    /**
     * @param array{int,int} $currentPosition
     * 
     * @return array<array{turn:string,length:int}>
     */
    private static function walkFrom(array $currentPosition, int $steps, string $direction): array
    {
        return match ($direction) {
            self::UP => [$currentPosition[0], $currentPosition[1] + $steps],
            self::LEFT => [$currentPosition[0] - $steps, $currentPosition[1]],
            self::DOWN => [$currentPosition[0], $currentPosition[1] - $steps],
            self::RIGHT => [$currentPosition[0] + $steps, $currentPosition[1]],
            default => $currentPosition,
        };
    }

    /**
     * @param array{int,int} $from
     * @param array{int,int} $to
     */
    private static function countDistance(array $from, array $to): int
    {
        $xDifference = abs($to[0] - $from[0]);
        $yDifference = abs($to[1] - $from[1]);

        return $xDifference + $yDifference;
    }

    /**
     * @param array{int,int} $position
     */
    private static function hashPosition(array $position): string
    {
        return "$position[0],$position[1]";
    }
}