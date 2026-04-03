<?php

namespace App\Tests\Utility;

use App\Utility\FileUtility;
use PHPUnit\Framework\Attributes\CoversClass;
use PHPUnit\Framework\TestCase;

#[CoversClass(FileUtility::class)]
class FileUtilityTest extends TestCase
{
    public function testReadDayInputFileWithInvalidIndex(): void
    {
        $this->expectException(\InvalidArgumentException::class);

        FileUtility::readDayInputFile(-1);
    }

    public function testReadDayInputFileWithValidIndex(): void
    {
        $actual = FileUtility::readDayInputFile(0);

        $this->assertSame('foo', $actual);
    }
}
