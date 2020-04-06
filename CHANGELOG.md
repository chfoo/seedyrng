Change log
==========

1.1.0 (2020-04-06)
------------------

* Added `Xorshift64Plus`. The default `Xorshift128Plus` uses `haxe.Int64`
  in the implementation which can be very slow on targets without 64-bit
  integers.

1.0.0 (2019-03-23)
------------------

* Changed `randomSystemInt()` implementation to remove target specific code.
  Use the trandom library for high quality random numbers.
* Bumped version to 1.0 to indicate API is stable.

0.1.0 (2018-10-19)
------------------

* First release
