<?php

namespace Aoc16\Utility;

class FileUtility
{
    private const string INPUT_FILES_DIR = __DIR__ . '/../../../inputs/';
    private const string INPUT_FILE_EXTENSION = '.txt';

    /**
     * @throws \InvalidArgumentException when the file could not be read
     */
    public static function readDayInputFile(int $dayIndex): string
    {
        $filePath = self::INPUT_FILES_DIR . $dayIndex . self::INPUT_FILE_EXTENSION;

        return self::readFile($filePath);
    }

    /**
     * @throws \InvalidArgumentException when the file could not be read
     */
    private static function readFile(string $path): string
    {
        $contents = @file_get_contents($path);

        if (false === $contents) {
            throw new \InvalidArgumentException(\sprintf("File %s could not be read", $path));
        }

        return $contents;
    }
}
