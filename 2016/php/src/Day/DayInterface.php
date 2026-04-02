<?php

namespace Aoc16\Day;

interface DayInterface
{
    public function partOne(string $input): string;

    public function partTwo(string $input): string;

    public function getDayNumber(): int;
}
