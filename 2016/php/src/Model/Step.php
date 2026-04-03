<?php

namespace App\Model;

use App\Enum\Direction;

class Step
{
    public function __construct(
        public readonly Direction $direction,
        public readonly int $length,
    ) {}
}
