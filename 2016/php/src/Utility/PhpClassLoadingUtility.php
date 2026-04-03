<?php

namespace Aoc16\Utility;

use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;

class PhpClassLoadingUtility
{
    public static function findAndLoadImplementationsFromFiles(string $interface, string $path): array
    {
        $iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path));

        foreach ($iterator as $file) {
            if (!$file->isFile() || 'php' !== $file->getExtension()) {
                continue;
            }

            require_once $file->getPathname();
        }

        $classes = get_declared_classes();
        $implementations = array_filter(
            $classes,
            fn(string $class) => \in_array($interface, class_implements($class), true),
        );

        return array_values($implementations);
    }
}
