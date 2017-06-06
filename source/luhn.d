module luhn;
import std.traits : isIntegral, isUnsigned;
import core.checkedint;

//TODO: checkedInt?

/**
    Returns: The Luhn Digit to append to the number.
*/
public @safe
ubyte luhnDigitOf(T)(T number)
if (isIntegral!T && isUnsigned!T)
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

/**
    Returns: The number with the digit appended.
*/
pragma(inline, true)
public @safe
T appendDigitTo(T, U)(T number, U digit)
if (isIntegral!T && isIntegral!U && isUnsigned!T && isUnsigned!U)
{
    bool arithmeticOverflow = false;
    number = mulu(number, 10u, arithmeticOverflow);
    number = addu(number, digit, arithmeticOverflow);
    //REVIEW: Should I really just return 0u for an overflow, or throw?
    return (arithmeticOverflow ? 0u : number);
}

///
@safe
unittest
{
    assert(appendDigitTo(7992739871u, 3u) == 79927398713u);
    assert(appendDigitTo(7992739871u, 0u) == 79927398710u);
    assert(appendDigitTo(7992739871u, 9u) == 79927398719u);
}

/**
    Returns: The number with the Luhn Checksum Digit appended.
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
    Returns: The last digit of the number.
*/
pragma(inline, true)
public @safe
ubyte lastDigitOf(T)(T number)
if (isIntegral!T && isUnsigned!T)
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
    Returns: The number, but with the last digit removed.
*/
pragma(inline, true)
public @safe
T removeLastDigitFrom(T)(T number)
if (isIntegral!T && isUnsigned!T)
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
    Returns: true if the Luhn checksum is valid.
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