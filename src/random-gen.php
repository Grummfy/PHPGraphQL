<?php

include_once __DIR__ . '/../vendor/autoload.php';

$sampler = new Hoa\Compiler\Llk\Sampler\Uniform(
	// Grammar.
	Hoa\Compiler\Llk\Llk::load(new Hoa\File\Read(__DIR__ .'/GraphQL.pp')),
	// Token sampler.
	new Hoa\Regex\Visitor\Isotropic(new Hoa\Math\Sampler\Random()),
	// Length.
7
);

for ($i = 0; $i < 10; ++$i) {
echo $sampler->uniform(), "\n";
}
