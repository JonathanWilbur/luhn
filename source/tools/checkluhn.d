import std.stdio : writeln;
import luhn;

void main()
{
    if (luhnDigitIsValidFor(79927398713u))
    {
        writeln("Valid!");
    }
    else
    {
        writeln("Invalid!");
    }

    writeln("Checksum of 7992739871: ", luhnDigitOf(7992739871u));
}