<?php

include_once __DIR__ . '/../vendor/autoload.php';

$fileToCheck = ($argc >= 2) ? $argv[1] : null;

// 1. Load grammar.
$compiler = Hoa\Compiler\Llk\Llk::load(new Hoa\File\Read(__DIR__ . '/GraphQL.pp'));

if (!$fileToCheck)
{
	echo 'Check valid resources:', PHP_EOL;
	$result = checkGraphQl(__DIR__ . '/../resources/good', true, $compiler);
	echo PHP_EOL, '-----------', PHP_EOL, array_sum($result), '/', count($result), PHP_EOL;

	echo PHP_EOL, 'Check invalid resources:', PHP_EOL;
	$current = error_reporting();
	$current = error_reporting(E_ALL^E_WARNING);
	$result = checkGraphQl(__DIR__ . '/../resources/bad', false, $compiler);
	error_reporting($current);
	echo PHP_EOL, '-----------', PHP_EOL, array_sum($result), '/', count($result), PHP_EOL;
}
else
{
	$fileToCheck = new SplFileInfo($fileToCheck);

	echo $fileToCheck->getFilename();
	$result = checkTheValidityOfAFile((bool) $argv[2], $compiler, $fileToCheck, true);
	echo printResult($result), PHP_EOL;

}

function isResultGood($result, $shouldBeValid)
{
	return ($shouldBeValid && $result);
}

function printResult($result)
{
	return $result ? ' ✓' : ' ✗';
}

function checkGraphQl($path, $shouldBeValid, Hoa\Compiler\Llk\Parser $compiler)
{
	$results = array();
	foreach (new DirectoryIterator($path) as $fileInfo)
	{
		if ($fileInfo->isDir() || $fileInfo->isDot() || $fileInfo->getExtension() != 'gql')
		{
			continue;
		}

		echo $fileInfo->getFilename();
		$results[ $fileInfo->getFilename() ] = false;

		$result = checkTheValidityOfAFile($shouldBeValid, $compiler, $fileInfo);
		echo printResult($result), PHP_EOL;

		$results[ $fileInfo->getFilename() ] = $result;
	}

	return $results;
}

function checkTheValidityOfAFile($shouldBeValid, Hoa\Compiler\Llk\Parser $compiler, SplFileInfo $fileInfo, $printException = false)
{
	$result = false;
	try
	{
		$content = file_get_contents($fileInfo->getRealPath());
		$compiler->parse($content, null, false);

		$result = isResultGood(true, $shouldBeValid);
	}
	catch (\Hoa\Compiler\Exception\UnexpectedToken $e)
	{
		$result = isResultGood(false, $shouldBeValid);
		if ($printException)
		{
			echo $e;
		}
	}
	catch (\Hoa\Compiler\Exception\UnrecognizedToken $e)
	{

		$result = isResultGood(false, $shouldBeValid);
		if ($printException)
		{
			echo $e;
		}
	}

	return $result;
}
