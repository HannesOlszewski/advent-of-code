<?php

namespace Aoc16\Map;

/**
 * @template T
 */
class StringHashMap
{
    /** @var array<string, T> */
    private array $map = [];

    public function has(\Stringable $key): bool
    {
        return isset($this->map[(string) $key]);
    }

    /**
     * @return T|null
     */
    public function get(\Stringable $key): mixed
    {
        return $this->map[(string) $key] ?? null;
    }

    /**
     * @param T $value
     */
    public function set(\Stringable $key, mixed $value): void
    {
        $this->map[(string) $key] = $value;
    }
}
