<?php

include_once __DIR__ . '/../vendor/autoload.php';

// 1. Load grammar.
$compiler = Hoa\Compiler\Llk\Llk::load(new Hoa\File\Read(__DIR__ . '/GraphQL.pp'));

// 2. Parse a data.
$ast      = $compiler->parse(file_get_contents(__DIR__ . '/../resources/good/7.gql'));

// 3. Dump the AST.
$dump     = new Hoa\Compiler\Visitor\Dump();
echo $dump->visit($ast);
