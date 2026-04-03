<?php

use App\Kernel;

require_once dirname(__DIR__) . '/vendor/autoload_runtime.php';

return function (array $context) {
    $env = $context['APP_ENV'] ?? 'dev';

    if (!\is_string($env)) {
        throw new \LogicException('APP_ENV not set');
    }

    return new Kernel($env, (bool) $context['APP_DEBUG']);
};
