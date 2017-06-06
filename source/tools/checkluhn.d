import std.stdio : writeln;
import luhn;

void main(string[] args)
{
    if (luhnChecksumIsValidFor(79927398713))
    {
        writeln("Valid!");
    }
    else
    {
        writeln("Invalid!");
    }

    writeln("Checksum of 7992739871: ", luhnDigitOf(7992739871));
}