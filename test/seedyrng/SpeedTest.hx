package seedyrng;

import haxe.Int64;
import haxe.Timer;

class SpeedTest {
    public static function main() {
        final seed = Int64.make(0, 123);
        final xorshift128pRandom = new Random(seed, new Xorshift128Plus());
        final xorshift64pRandom = new Random(seed, new Xorshift64Plus());
        final galoisLFSR32Random = new Random(seed, new GaloisLFSR32());
        final count = 1000000;

        Timer.measure(() -> {
            for (dummy in 0...count) {
                xorshift128pRandom.random();
            }
        });

        Timer.measure(() -> {
            for (dummy in 0...count) {
                xorshift64pRandom.random();
            }
        });

        Timer.measure(() -> {
            for (dummy in 0...count) {
                galoisLFSR32Random.random();
            }
        });
    }
}
