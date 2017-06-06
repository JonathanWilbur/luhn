module luhn;
import std.traits : isIntegral, isUnsigned;

//TODO: checkedInt?

/**
    Returns: The Luhn Digit to append to the number.
*/
public @safe
T luhnDigitOf(T)(T number)
if (isIntegral!T && isUnsigned!T)
{
    T[] digits;
    for (int exponent = 0; number > 10; exponent++)
    {
        digits ~= ((number / (10^^exponent)) % 10);
        number = ((number - (number % 10)) / 10);
    }
    T sum;
    bool doubleThisDigit = true;
    for (T i = 0; i < digits.length; i++)
    {
        if (doubleThisDigit)
        {
            digits[cast(uint) i] <<= 1; // Shifting by 1 is faster than multiplication by 2.
            if (digits[cast(uint) i] > 9) digits[cast(uint) i] -= 9;
        }
        sum += digits[cast(uint) i];
        doubleThisDigit = !doubleThisDigit;
    }
    return ((sum * 9) % 10);
}

///
@safe
unittest
{
    assert(luhnDigitOf(7992739871u) == 3u);
}

//TODO: Inline
/**
    Returns: The number with the digit appended.
*/
public @safe
T appendDigitTo(T, U)(T number, U digit)
if (isIntegral!T && isIntegral!U && isUnsigned!T && isUnsigned!U)
{
    return ((number * 10) + digit);
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
public @safe
T lastDigitOf(T)(T number)
if (isIntegral!T && isUnsigned!T)
{
    return (number % 10);
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
public @safe
T removeLastDigitFrom(T)(T number)
if (isIntegral!T && isUnsigned!T)
{
    return ((number - lastDigitOf(number)) / 10);
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