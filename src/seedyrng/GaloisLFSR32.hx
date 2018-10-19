package seedyrng;

import haxe.Int64;
import haxe.io.Bytes;


/**
    Galois LFSR 32-bit generator.

    This is a very fast but low quality pseudorandom number generator. These
    kinds of LFSR generators are typically used in embedded devices with
    limited resources.

    In most cases, you do not want to use this generator.
**/
class GaloisLFSR32 implements GeneratorInterface {
    public var seed(get, set):Int64;
    public var state(get, set):Bytes;
    public var usesAllBits(get, never):Bool;

    // Implementation based on https://en.wikipedia.org/w/index.php?title=Linear-feedback_shift_register&oldid=863159640
    // Polynomial taps for 32 bit: 32, 22, 2, 1
    // 0b10000000001000000000000000000101
    static inline var TAPS:Int = 0x80200005;

    var _seed:Int64;
    var _state:Int;

    public function new() {
        this.seed = Int64.ofInt(1);
    }

    function get_usesAllBits():Bool {
        return false;
    }

    function get_seed():Int64 {
        return _seed;
    }

    function set_seed(value:Int64):Int64 {
        value = value != 0 ? value : 1; // must not be zero
        _seed = value;
        _state = _seed.high ^ _seed.low;

        return value;
    }

    function get_state():Bytes {
        var bytes = Bytes.alloc(12);
        bytes.setInt64(0, _seed);
        bytes.setInt32(8, _state);

        return bytes;
    }

    function set_state(value:Bytes):Bytes {
        if (value.length != 12) {
            throw 'Wrong state size ${value.length}';
        }

        _seed = value.getInt64(0);
        _state = value.getInt32(8);

        return value;
    }

    function stepNext() {
        var lsb = _state & 1;
        _state >>= 1;

        if (lsb != 0) {
            _state ^= TAPS;
        }
    }

    public function nextInt():Int {
        stepNext();
        return _state;
    }
}
