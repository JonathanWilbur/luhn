/**
	Calculates, appends, and verifies Luhn Algorithm checksum digits.

	Authors:
        $(LINK2 mailto:jonathan@wilbur.space, Jonathan M. Wilbur)
	Date: June 7th, 2017
	License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
	Version: 1.0.0
*/
module luhn;
import core.checkedint : addu, mulu;
import std.traits : isIntegral, isUnsigned;

/*
    NOTE: I think I have accidentally discovered that you cannot inline
    functions that have an out contract. You can, apparently, inline
    functions that have an in contract. This may not be news to other
    developers, but its news to me, and it is not in the D documentation
    as far as I can see.
*/

/**
    Calculates and returns the Luhn checksum digit and returns it, by itself.
    This only retuns the Luhn checksum digit and not the number that was used
    to determine it.

    Params:
        number = The number for which a checksum digit will be calculated.
    Returns: The Luhn Algorithm checksum digit for the given number.
*/
public nothrow @safe
ubyte luhnDigitOf(T)(T number)
if (isIntegral!T && isUnsigned!T)
out (result)
{
    assert(result >= 0u && result <= 9u);
}
body
{
    ubyte[] digits;
    for (uint exponent = 0; number > 10u; exponent++)
    {
        digits ~= lastDigitOf(number / (10u^^exponent));
        number = removeLastDigitFrom(number);
    }
    uint sum;
    bool doubleThisDigit = true;
    for (uint i = 0; i < digits.length; i++)
    {
        if (doubleThisDigit)
        {
            digits[i] <<= 1; // Shifting by 1 is faster than multiplication by 2.
            if (digits[i] > 9u) digits[i] -= 9u;
        }
        sum += digits[i];
        doubleThisDigit = !doubleThisDigit;
    }
    return lastDigitOf(sum * 9u);
}

///
@safe
unittest
{
    assert(luhnDigitOf(7992739871u) == 3u);
}

pragma(inline, true)
private @safe
T appendDigitTo(T, U)(T number, U digit)
if (isIntegral!T && isIntegral!U && isUnsigned!T && isUnsigned!U)
in
{
    assert(digit >= 0 && digit <= 9);
}
body
{
    bool arithmeticOverflow = false;
    number = mulu(number, 10u, arithmeticOverflow);
    number = addu(number, digit, arithmeticOverflow);
    //REVIEW: Should I really just return 0u for an overflow, or throw?
    return (arithmeticOverflow ? 0u : number);
}

@safe
unittest
{
    assert(appendDigitTo(7992739871u, 3u) == 79927398713u);
    assert(appendDigitTo(7992739871u, 0u) == 79927398710u);
    assert(appendDigitTo(7992739871u, 9u) == 79927398719u);
}

/**
    Calculates the Luhn checksum digit for the given number and appends the
    checksum digit to the end of the number. Note that, if appending the
    digit causes an arithmetic overflow, no exceptions will be thrown, but
    instead, the returned number will simply be 0.

    Params:
        number = The number for which a Luhn checksum digit will be calculated
            and to which said checksum digit will be appended.
    Returns: 
        The number with the Luhn checksum digit appended, or 0 if there is
        an arithmetic overflow.
*/
pragma(inline, true)
public @safe
T appendLuhnDigitTo(T)(T number)
if (isIntegral!T && isUnsigned!T)
{
    return number.appendDigitTo(luhnDigitOf(number));
}

///
@safe
unittest
{
    assert(appendLuhnDigitTo(7992739871u) == 79927398713u);
}

/**
    Returns the last digit of the number. Luhn checksum digits are usually
    appended to the number for which they are a checksum, meaning that, to
    obtain the checksum digit, one simply needs to take the last digit of
    the number. This function does that.

    Params:
        number = The number from which the last digit will be retrieved. The
            number itself will not be modified by reference.
    Returns: The last digit of the number.
*/
// pragma(inline, true)
public @safe
ubyte lastDigitOf(T)(T number)
if (isIntegral!T && isUnsigned!T)
out (result)
{
    assert(result >= 0 && result <= 9);
}
body
{
    return cast(ubyte) (number % 10u);
}

///
@safe
unittest
{
    assert(lastDigitOf(79927398713u) == 3u);
}

/**
    Returns the number, but with the last decimal digit removed. The number is
    not modified by reference, so the number passed in as the argument is not
    changed by this function; rather, the resulting number is returned.

    Params:
        number = The number from which the last decimal digit will be removed.
    Returns: The number, but with the last decimal digit removed.
*/
// pragma(inline, true)
public @safe
T removeLastDigitFrom(T)(T number)
if (isIntegral!T && isUnsigned!T)
out (result)
{
    assert(result <= number);
}
body
{
    return ((number - lastDigitOf(number)) / 10u);
}

///
@safe
unittest
{
    assert(lastDigitOf(79927398713u) == 3u);
}

/**
    Evaluates the provided number with the assumption that the last digit of
    the number is a Luhn checksum digit. If the last digit is the correct
    checksum digit for the number preceeding it, then the function returns
    true; if not, the function returns false. The function takes the Luhn
    Checksum of the number without the last digit, and compares the resulting
    digit to the last digit.

    Params:
        number = The number from which the checksum digit will be extracted
            and whose remainder will be checked against the checksum digit
    Returns: 
        True if the Luhn checksum is valid; false if the checksum is not valid.
*/
public @safe
bool luhnDigitIsValidFor(T)(T number)
if (isIntegral!T && isUnsigned!T)
{
    return (luhnDigitOf(removeLastDigitFrom(number)) == lastDigitOf(number));
}

///
@safe
unittest
{
    assert(luhnDigitIsValidFor(79927398713u));
    assert(!luhnDigitIsValidFor(79927398714u));
}