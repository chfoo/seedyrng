package seedyrng;

import haxe.io.BytesBuffer;
import haxe.crypto.Sha1;
import haxe.Int64;
import haxe.io.Bytes;


/**
    General featured interface to a pseudorandom number generator.
**/
class Random implements GeneratorInterface {
    public var seed(get, set):Int64;
    public var state(get, set):Bytes;
    public var usesAllBits(get, never):Bool;

    var generator:GeneratorInterface;

    /**
        @param seed Optional 64-bit seed to initialize the state of the
        generator. If not given, a seed from `randomSystemInt` will be used.
        @param generator Optional generator instance. If not given,
        a xorshift128+ generator is used.
    **/
    public function new(?seed:Int64, ?generator:GeneratorInterface) {
        if (seed == null) {
            seed = Int64.make(randomSystemInt(), randomSystemInt());
        }

        if (generator == null) {
            generator = new Xorshift128Plus();
        }

        this.generator = generator;
        this.seed = seed;
    }

    /**
        Returns a (non-secure) random integer from the system.

        This method can be used construct and obtain a seed. Unlike
        regular `Sys.random`, all bits are usable.

        For high-quality (cryptographic) random numbers, see the
        trandom library (https://lib.haxe.org/p/trandom).
    **/
    public static function randomSystemInt():Int {
        // There used to be target specific code here, but it's best to put it
        // into the 'trandom' library.

        // Ensures all bits are filled
        var value =
            (Std.random(0xff) << 24) |
            (Std.random(0xff) << 16) |
            (Std.random(0xff) << 8) |
            Std.random(0xff);

        return value;
    }

    function get_seed():Int64 {
        return generator.seed;
    }

    function set_seed(value:Int64):Int64 {
        return generator.seed = value;
    }

    function get_state():Bytes {
        return generator.state;
    }

    function set_state(value:Bytes):Bytes {
        return generator.state = value;
    }

    function get_usesAllBits():Bool {
        return generator.usesAllBits;
    }

    public function nextInt():Int {
        return generator.nextInt();
    }

    /**
        Returns an integer where all bits are uniformly distributed.
    **/
    public function nextFullInt():Int {
        if (generator.usesAllBits) {
            return generator.nextInt();
        } else {
            var num1 = generator.nextInt();
            var num2 = generator.nextInt();
            // Swap 16 bits to cover cases such as MSB zero or number never 0
            num2 = num2 >>> 16 | num2 << 16;
            return num1 ^ num2;
        }
    }

    /**
        Derives and sets a seed using the given string.

        This method encodes the string (supposedly UTF-8 all on targets) and
        derives a seed using `setBytesSeed`.
    **/
    public function setStringSeed(seed:String) {
        setBytesSeed(Bytes.ofString(seed));
    }

    /**
        Derives and sets a seed using the given bytes.

        This method works by using the SHA-1 hashing algorithm. A 64-bit
        integer is obtained from the first 64 bits of the digest with the order
        of bytes in little endian encoding.
    **/
    public function setBytesSeed(seed:Bytes) {
        var hash = Sha1.make(seed);
        this.seed = hash.getInt64(0);
    }

    /**
        Returns a floating point number in the range [0, 1), That is, a number
        greater or equal to 0 and less than 1.

        The distribution is approximately uniform.
    **/
    public function random():Float {
        // Implementation based on https://crypto.stackexchange.com/a/31659
        // Using 53 bits
        var upper = nextFullInt() & 0x1fffff;
        var lower:UInt = nextFullInt();
        var floatNum = upper * Math.pow(2, 32) + lower;
        var result = floatNum * Math.pow(2, -53);

        return result;
    }

    /**
        Returns an integer within the given range [`lower`, `upper`]. That is,
        a number within `lower` inclusive and `upper` inclusive.

        This method uses `random()` which the distribution approximately
        uniform. For large ranges greater than 2^53, the distribution will
        be noticeably biased.
    **/
    public function randomInt(lower:Int, upper:Int):Int {
        // randomInt and uniform implementation based on
        // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
        return Math.floor(random() * (upper - lower + 1)) + lower;
    }

    /**
        Returns a uniformly distributed floating point number within the
        given range [`lower`, `upper`). That is, a number within `lower`
        inclusive and `upper` exclusive.

        Note when `lower` or `upper` approach precision limits, the
        returned number may equal `upper` due to rounding.
    **/
    public function uniform(lower:Float, upper:Float):Float {
        return random() * (upper - lower) + lower;
    }

    /**
        Returns an element from the given array.
    **/
    public function choice<T>(array:Array<T>):T {
        return array[randomInt(0, array.length - 1)];
    }

    /**
        Shuffles the elements, in-place, in the given array.

        The shuffle algorithm is modern Fisher-Yates. The underlying number
        generator limits the number of permutations possible.
        This means that using this method alone to shuffle a deck of 52 cards
        will not result in all possible outcomes.
    **/
    public function shuffle<T>(array:Array<T>) {
        // Implementation https://en.wikipedia.org/w/index.php?title=Fisher%E2%80%93Yates_shuffle&oldid=864477677
        for (index in 0...array.length - 1) {
            var randIndex = randomInt(index, array.length - 1);
            var tempA = array[index];
            var tempB = array[randIndex];

            array[index] = tempB;
            array[randIndex] = tempA;
        }
    }
}
