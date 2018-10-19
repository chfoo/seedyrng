package seedyrng;

import haxe.Int64;
import haxe.io.Bytes;


/**
    Interface for pseudorandom number generators.
**/
interface GeneratorInterface {
    /**
        Initial starting state.

        Setting this value will reset the state.
    **/

    public var seed(get, set):Int64;

    /**
        Current generator state.

        The state can be saved and restored to allow resuming a generator.
    **/
    public var state(get, set):Bytes;

    /**
        Whether `nextInt` returns an integer with a uniform distribution of
        bits.

        When `false` for example, the generator may output an integer that is
        never zero or the most significant bit is zero.
    **/
    public var usesAllBits(get, never):Bool;

    /**
        Advances the generator and returns an integer.

        The returned value is subject to notes in `usesAllBits`.
    **/
    public function nextInt():Int;
}
