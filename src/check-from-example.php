<?php

include_once __DIR__ . '/../vendor/autoload.php';

$fileToCheck = ($argc >= 2) ? $argv[1] : null;

// 1. Load grammar.
$compiler = Hoa\Compiler\Llk\Llk::load(new Hoa\File\Read(__DIR__ . '/GraphQL.pp'));

if (!$fileToCheck)
{
	echo 'Check valid resources:', PHP_EOL;
	checkGraphQl(__DIR__ . '/../resources/good', true, $compiler);

	echo '----------', PHP_EOL, 'Check invalid resources:', PHP_EOL;
	checkGraphQl(__DIR__ . '/../resources/bad', false, $compiler);
}
else
{
	$fileToCheck = new SplFileInfo($fileToCheck);
	checkTheValidityOfAFile((bool) $argv[2], $compiler, $fileToCheck, true);
}

function isResultGood($result, $shouldBeValid)
{
	return $shouldBeValid && $result ? ' ✓' : ' ✗';
}

function checkGraphQl($path, $shouldBeValid, Hoa\Compiler\Llk\Parser $compiler)
{
	foreach (new DirectoryIterator($path) as $fileInfo)
	{
		if ($fileInfo->isDir() || $fileInfo->isDot() || $fileInfo->getExtension() != 'gql')
		{
			continue;
		}

		checkTheValidityOfAFile($shouldBeValid, $compiler, $fileInfo);
	}
}

function checkTheValidityOfAFile($shouldBeValid, Hoa\Compiler\Llk\Parser $compiler, SplFileInfo $fileInfo, $printException = false)
{
	echo $fileInfo->getFilename();

	try
	{
		$content = file_get_contents($fileInfo->getRealPath());
		$compiler->parse($content, null, false);

		echo isResultGood(true, $shouldBeValid);
	}
	catch (\Hoa\Compiler\Exception\UnexpectedToken $e)
	{
		echo isResultGood(false, $shouldBeValid);
		if ($printException)
		{
			echo $e;
		}
	}
	catch (\Hoa\Compiler\Exception\UnrecognizedToken $e)
	{
		//			var_dump($e->getMessage());
		echo isResultGood(false, $shouldBeValid);
		if ($printException)
		{
			echo $e;
		}
	}
	echo PHP_EOL;
}
