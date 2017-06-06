module luhn;
import std.traits : isIntegral, isUnsigned;
// import std.math : log10, ceil, abs;

// debug
// {
//     import std.stdio : writeln, writefln;
// }

//TODO: checkedInt?

/**
    Returns: true if the Luhn checksum is valid.
*/
public
bool luhnChecksumIsValidFor(T)(T number)
if (isIntegral!T && isUnsigned!T)
{
    T luhnDigit = (number % 10);
    T verifand = ((number - luhnDigit) / 10); // 'Verifand' should be considered a real word, IMO.
    return (luhnDigitOf(verifand) == luhnDigit ? true : false); //REVIEW: "? true : false" is unnecessary
}

/**
    Returns: The Luhn Digit to append to the number.
*/
public
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

//TODO: Inline
/**
    Returns: The number with the digit appended.
*/
public
T appendDigit(T, U)(T number, U digit)
if (isIntegral!T && isIntegral!U && isUnsigned!T && isUnsigned!U)
{
    return ((number * 10) + digit);
}

/**
    Returns: The number with the Luhn Checksum Digit appended.
*/
public
T appendLuhnDigit(T)(T number)
if (isIntegral!T && isUnsigned!T)
{
    return ((number * 10) + luhnDigitOf(number));
}

/**
    Returns: The last digit of the number.
*/
public
T lastDigitOf(T)(T number)
if (isIntegral!T && isUnsigned!T)
{
    return (number % 10);
}

/**
    Returns: The number, but with the last digit removed.
*/
T removeLastDigit(T)(T number)
if (isIntegral!T && isUnsigned!T)
{
    return ((number - (number % 10)) / 10);
}

/*
    Functions:
        Creation:
            luhnDigitOf(number)
            appendDigit(number, lastDigit)
            appendLuhnDigit(number)
        Verification:
            lastDigitOf(number)
            removeLastDigit(number)
            removeLuhnDigit(number)

*/

// TODO: sum(T[])(T[] values ...) if (T.isIntegral)
// TODO: product(T[])(T[] values ...) if (T.isIntegral)
// TODO: toggle(bool value)