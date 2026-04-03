<?php

declare(strict_types=1);

require_once __DIR__ . '/../vendor/autoload.php';

use Aoc16\Day\DayInterface;
use Aoc16\Utility\FileUtility;
use Aoc16\Utility\PhpClassLoadingUtility;

$dayClasses = PhpClassLoadingUtility::findAndLoadImplementationsFromFiles(DayInterface::class, __DIR__ . '/Day');
/** @var DayInterface[] $days */
$days = array_map(static fn(string $class) => new $class(), $dayClasses);
usort(
    $days,
    static fn(DayInterface $a, DayInterface $b) => $a->getDayNumber() <=> $b->getDayNumber(),
);

foreach ($days as $day) {
    $dayIndex = $day->getDayNumber();
    $input = FileUtility::readDayInputFile($dayIndex);

    $startOne = (int) hrtime(true);
    $resultOne = $day->partOne($input);
    $endOne = (int) hrtime(true);
    $timeOneMicroSeconds = ($endOne - $startOne) / 1000;
    echo \sprintf("Day %d.1: %s (took %dμs)\n", $dayIndex, $resultOne, $timeOneMicroSeconds);

    $startTwo = (int) hrtime(true);
    $resultTwo = $day->partTwo($input);
    $endTwo = (int) hrtime(true);
    $timeTwoMicroSeconds = ($endTwo - $startTwo) / 1000;
    echo \sprintf("Day %d.2: %s (took %dμs)\n", $dayIndex, $resultTwo, $timeTwoMicroSeconds);
}
