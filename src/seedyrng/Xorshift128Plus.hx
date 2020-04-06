package seedyrng;

import haxe.Int64;
import haxe.io.Bytes;


/**
    xorshift128+ generator.

    This is a very fast and high quality pseudorandom number generator.
    It is a variant of the xorshift algorithm that is closely related to LFSRs.

    On targets without 64-bit integers, the usage of haxe.Int64 may be very
    slow. If this is a concern, use `Xorshift64Plus`.
**/
class Xorshift128Plus implements GeneratorInterface {
    public var seed(get, set):Int64;
    public var state(get, set):Bytes;
    public var usesAllBits(get, never):Bool;

    // Implementation based on https://en.wikipedia.org/w/index.php?title=Xorshift&oldid=856827334
    static inline var PARAMETER_A = 23;
    static inline var PARAMETER_B = 17;
    static inline var PARAMETER_C = 26;

    // Randomly generated value
    static var SEED_1 = Int64.make(0x3239D498, 0x28D8D419);

    var _seed:Int64;
    var _state0:Int64;
    var _state1:Int64;
    var _current:Int64;
    var _currentAvailable = false;

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

        // Our API only supports 64 bit seed, so there is a hard-coded
        // value here
        _state0 = value;
        _state1 = SEED_1;
        _currentAvailable = false;

        return value;
    }

    function get_state():Bytes {
        var bytes = Bytes.alloc(33);

        bytes.setInt64(0, _seed);
        bytes.setInt64(8, _state0);
        bytes.setInt64(16, _state1);
        bytes.set(24, _currentAvailable ? 1 : 0);

        if (_currentAvailable) {
            bytes.setInt64(25, _current);
        }

        return bytes;
    }

    function set_state(value:Bytes):Bytes {
        if (value.length != 33) {
            throw 'Wrong state size ${value.length}';
        }

        _seed = value.getInt64(0);
        _state0 = value.getInt64(8);
        _state1 = value.getInt64(16);
        _currentAvailable = value.get(24) == 1 ? true : false;

        if (_currentAvailable) {
            _current = value.getInt64(25);
        }

        return value;
    }

    function stepNext() {
        var x = _state0;
        var y = _state1;

        _state0 = y;
        x ^= x << PARAMETER_A;
        _state1 = x ^ y ^ (x >> PARAMETER_B) ^ (y >> PARAMETER_C);

        _current = _state1 + y;
    }

    public function nextInt():Int {
        if (_currentAvailable) {
            _currentAvailable = false;
            return _current.low;

        } else {
            stepNext();
            _currentAvailable = true;

            return _current.high;
        }
    }
}
