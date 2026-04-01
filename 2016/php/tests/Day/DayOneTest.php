<?php

namespace Aoc16\Tests\Day;

use Aoc16\Day\DayOne;
use PHPUnit\Framework\Attributes\CoversClass;
use PHPUnit\Framework\TestCase;

#[CoversClass(DayOne::class)]
class DayOneTest extends TestCase
{
    public function testDayOnePartOne(): void
    {
        $day = new DayOne();

        self::assertSame('5', $day->partOne('R2, L3'));
        self::assertSame('2', $day->partOne('R2, R2, R2'));
        self::assertSame('12', $day->partOne('R5, L5, R5, R3'));
    }

    public function testDayOnePartTwo(): void
    {
        $day = new DayOne();

        self::assertSame('4', $day->partTwo('R8, R4, R4, R8'));
    }
}