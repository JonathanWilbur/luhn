/**
	Calculates, appends, and verifies Luhn Algorithm checksum digits.

	Authors:
        $(LINK2 mailto:jonathan@wilbur.space, Jonathan M. Wilbur)
	Date: June 7th, 2017
	License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
	Version: 1.0.0
*/
module main; // Put here to prevent potential name conflict with library names.
import luhn : appendLuhnDigitTo, luhnDigitIsValidFor, luhnDigitOf;
import std.algorithm.iteration : each;
import std.ascii : toLower;
import std.conv : ConvException, ConvOverflowException, to;
import std.stdio : writeln;

private immutable string usageMessage = 
    "Usage: luhn {check|digit|append} number";

int main(string[] args)
{
    
    if (args.length != 3)
    {
        writeln(usageMessage);
        return 1;
    }

    // Converts each character of the second argument to lowercase.
    args[1].each!"a.toLower()";

    // Converts the string argument to a ulong.
    ulong number;
    try
    {
        number = args[2].to!ulong();
    }
    catch (ConvOverflowException coe)
    {
        writeln("That number is too big to determine Luhn digit.");
        return 1;
    }
    catch (ConvException ce)
    {
        writeln("The second argument was not a number.");
        return 1;
    }

    switch(args[1])
    {
        case "check":
        {
            const bool luhnChecksumIsValid = luhnDigitIsValidFor(number);
            writeln(luhnChecksumIsValid ? "Valid" : "Invalid");
            return (luhnChecksumIsValid ? 0 : 1);
        }
        case "digit":
        {
            const ubyte digit = luhnDigitOf(number);
            writeln(digit.to!string());
            return 0;
        }
        case "append":
        {
            if (number < ((ulong.max/10)-9))
            {
                writeln(appendLuhnDigitTo(number).to!string());
                return 0;
            }
            else
            {
                writeln("That number is too big to append a Luhn digit.");
                return 1;
            }
        }
        default:
        {
            writeln(usageMessage);
            return 1;
        }
    }
}