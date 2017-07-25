# Luhn

* Author: Jonathan M. Wilbur
* Copyright: Jonathan M. Wilbur
* License: [Boost License 1.0](http://www.boost.org/LICENSE_1_0.txt)
* Publication Year: 2017

This library provides functionality for verifying and appending Luhn digits,
as well as a related command line tool.

## The Library

All of the exposed functionality of the library is pretty self-explanatory.
For all of the generics, `T` is any unsigned integral type.
There are four exposed functions:

* `ubyte luhnDigitOf(T)(T number)`
* `T appendLuhnDigitTo(T)(T number)`
* `bool luhnDigitIsValidFor(T)(T number)`

There are also two exposed functions that are not really specific to Luhn
checksums, but whatever:

* `T removeLastDigitFrom(T)(T number)`
* `ubyte lastDigitOf(T)(T number)`

## The Command-Line Tool

The command-line tool, called `luhn` by default, is also pretty straight-forward.
It has three subcommands:

Command                                   | Does
------------------------------------------|-----------------------------------------------------------
`luhn check {number with luhn digit}`     | Prints `valid` or `invalid`
`luhn digit {number without luhn digit}`  | Calculates and returns only the luhn digit
`luhn append {number without luhn digit}` | Calculate the luhn digit and return appended to the number

## Compile and Install

As of right now, there are no build scripts, since the source is a single file,
but there will be build scripts in the future, just for the sake of consistency
across all similar projects.

## See Also

* [The Wikipedia page on the Luhn Algorithm](https://en.wikipedia.org/wiki/Luhn_algorithm)

## Contact Me

If you would like to suggest fixes or improvements on this library, please just
comment on this on GitHub. If you would like to contact me for other reasons,
please email me at [jonathan@wilbur.space](mailto:jonathan@wilbur.space). :boar: