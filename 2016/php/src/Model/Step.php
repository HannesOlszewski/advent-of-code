<?php

namespace Aoc16\Model;

use Aoc16\Enum\Direction;

class Step
{
    public function __construct(
        public readonly Direction $direction,
        public readonly int $length,
    ) {}
}
