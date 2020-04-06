SeedyRNG
========

SeedyRNG (Seedy) is a pseudorandom number generator library for Haxe.

Seedy is intended for generating numbers for applications that require reproducible sequences. Such examples include video game world generation or unit tests.

It provides a general featured interface such as producing an integer within a range or choosing an item from an array. It also allows you to use your own generator implementation if you desire.

Seedy is deterministic or predictable which means it is *not* suitable for secure cryptographic purposes. (You may be interested in the [trandom library](https://lib.haxe.org/p/trandom) or a libsodium binding which provides an API to the OS cryptographic random number generator.)

Quick start
-----------

Requires Haxe 3 or 4.

Install it from Haxelib:

    haxelib install seedyrng

(To install the latest from the git repository, use `haxelib git`.)

If you simply need a random integer:

```haxe
Seedy.randomInt(0, 10); // => Int
```

If you need finer control, such as specifying the seed, use an instance of `Random`:

```haxe
var random = new Random();
random.setStringSeed("hello world!");
random.randomInt(0, 10); // => Int
```

By default, the generator is xorshift128+. It is a relatively new generator based on the xorshift family. It is comparable to the popular Mersenne Twister but it is faster and simpler.

If you want to use another generator, you can specify it on the constructor:

```haxe
var random = new Random(new GaloisLFSR32());
// or
var random = new Random(new Xorshift64Plus());
```

The included `Xorshift128Plus` generator may be very slow on targets withouts 64-bit integers. For a generator that is fast on all targets, it is recommended to use `Xorshift64Plus` instead.

For details on all the methods, see the [API documentation](https://chfoo.github.io/seedyrng/api/).

Randomness testing
------------------

If you desire, you can statistically test the generator using something like:

    haxe hxml/app.cpp.hxml && out/cpp/Seedy | dieharder -g 200 -a

Alternatively, you can [inspect a visualization](https://unix.stackexchange.com/a/289670) of the output:

    export X=1000 Y=1000; haxe hxml/app.cpp.hxml && out/cpp/Seedy | head -c "$((3*X*Y))" | display -depth 8 -size "${X}x${Y}" RGB:-

Contributing
------------

Please file bug reports, features, or pull requests using the repo's GitHub Issues.
