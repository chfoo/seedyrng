package seedyrng;

import haxe.Int64;
import haxe.io.Bytes;

/**
 * xorshift64+ generator.
 *
 * This is a variant of the xorshift128+ generator that does not use haxe.Int64
 * in the implementation to avoid performance issues.
 * For details about xorshift, see `Xorshift128Plus`.
 */
class Xorshift64Plus implements GeneratorInterface {
    public var seed(get, set):Int64;
    public var state(get, set):Bytes;
    public var usesAllBits(get, never):Bool;

    // Implementation based on
    // https://github.com/golang/go/issues/21806
    // https://go-review.googlesource.com/c/go/+/62530/
    static inline var PARAMETER_A = 17;
    static inline var PARAMETER_B = 7;
    static inline var PARAMETER_C = 16;

    var _seed:Int64;
    var _state0:Int;
    var _state1:Int;

    public function new() {
        this.seed = Int64.ofInt(1);
    }

    function get_usesAllBits():Bool {
        // false because weakness in the lower bits
        return false;
    }

    function get_seed():Int64 {
        return _seed;
    }

    function set_seed(value:Int64):Int64 {
        value = value != 0 ? value : 1; // must not be zero
        _seed = value;

        _state0 = value.high;
        _state1 = value.low;

        return value;
    }

    function get_state():Bytes {
        var bytes = Bytes.alloc(16);

        bytes.setInt64(0, _seed);
        bytes.setInt32(8, _state0);
        bytes.setInt32(12, _state1);

        return bytes;
    }

    function set_state(value:Bytes):Bytes {
        if (value.length != 16) {
            throw 'Wrong state size ${value.length}';
        }

        _seed = value.getInt64(0);
        _state0 = value.getInt32(8);
        _state1 = value.getInt32(12);

        return value;
    }

    public function nextInt():Int {
        var x = _state0;
        var y = _state1;

        _state0 = y;
        x ^= x << PARAMETER_A;
        _state1 = x ^ y ^ (x >> PARAMETER_B) ^ (y >> PARAMETER_C);

        return (_state1 + y) & 0xffffffff;
    }
}
