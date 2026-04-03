<?php

declare(strict_types=1);

require_once __DIR__ . '/vendor/autoload.php';

use App\Day\DayInterface;
use App\Utility\FileUtility;
use App\Utility\PhpClassLoadingUtility;

$dayClasses = PhpClassLoadingUtility::findAndLoadImplementationsFromFiles(DayInterface::class, __DIR__ . '/src/Day');
/** @var DayInterface[] $days */
$days = array_map(static fn(string $class) => new $class(), $dayClasses);
usort(
    $days,
    static fn(DayInterface $a, DayInterface $b) => $a->getDayNumber() <=> $b->getDayNumber(),
);

$red = "\033[31m";
$green = "\033[32m";
$yellow = "\033[33m";
$bold = "\033[1m";
$nc = "\033[0m";

$successMark = "✔";
$errorMark = "✖";

foreach ($days as $day) {
    $dayIndex = $day->getDayNumber();
    $input = FileUtility::readDayInputFile($dayIndex);

    try {
        $startOne = (int) hrtime(true);
        $resultOne = $day->partOne($input);
        $endOne = (int) hrtime(true);
        $timeOneMicroSeconds = ($endOne - $startOne) / 1000;
        echo \sprintf(" $green$successMark$nc Day %d.1: $bold%s$nc $yellow(took %dμs)$nc\n", $dayIndex, $resultOne, $timeOneMicroSeconds);
    } catch (\Throwable $e) {
        echo \sprintf(" $red$errorMark$nc Day %d.1:$red$bold [ERROR] %s$nc\n", $dayIndex, $e->getMessage());
    }

    try {
        $startTwo = (int) hrtime(true);
        $resultTwo = $day->partTwo($input);
        $endTwo = (int) hrtime(true);
        $timeTwoMicroSeconds = ($endTwo - $startTwo) / 1000;
        echo \sprintf(" $green$successMark$nc Day %d.2: $bold%s$nc $yellow(took %dμs)$nc\n", $dayIndex, $resultTwo, $timeTwoMicroSeconds);
    } catch (\Throwable $e) {
        echo \sprintf(" $red$errorMark$nc Day %d.2:$red$bold [ERROR] %s$nc\n", $dayIndex, $e->getMessage());
    }
}
