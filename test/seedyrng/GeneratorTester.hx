package seedyrng;

import haxe.Int64;
import utest.Assert;
import utest.Test;


class GeneratorTester extends Test {
    var generatorFactory:Void->GeneratorInterface;

    public function new(generatorFactory:Void->GeneratorInterface) {
        super();
        this.generatorFactory = generatorFactory;
    }

    public function testStateRestore() {
        var generator = generatorFactory();
        generator.nextInt();

        var state = generator.state;
        var values = [];

        for (index in 0...5) {
            values[index] = generator.nextInt();
        }

        generator.state = state;

        for (index in 0...5) {
            Assert.equals(values[index], generator.nextInt());
        }
    }

    public function testNext() {
        var generator = generatorFactory();
        var counter = new Map<Int,Int>();
        var trials = 10;

        for (index in 0...trials) {
            var value = generator.nextInt();

            if (!counter.exists(value)) {
                counter.set(value, 1);
            } else {
                counter.set(value, counter.get(value) + 1);
            }
        }

        for (key in counter.keys()) {
            var count = counter.get(key);

            Assert.isTrue(count < 2, 'Value=$key Count=$count');
        }
    }
}
