<?php

namespace App\Utility;

use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;

class PhpClassLoadingUtility
{
    /**
     * @return array<class-string>
     */
    public static function findAndLoadImplementationsFromFiles(string $interface, string $path): array
    {
        $iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path));

        /** @var \SplFileInfo $file */
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
