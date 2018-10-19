package seedyrng.tests;

import haxe.Int64;
import utest.Assert;
import utest.Test;


class TestRandom extends Test {
    public function testRandomSystemInt() {
        Assert.notNull(Random.randomSystemInt());
    }

    public function testNextInt() {
        var random = new Random(Int64.ofInt(1));
        var num = random.nextInt();

        Assert.notNull(num);
    }

    public function testNextFullInt() {
        var random = new Random(Int64.ofInt(1));
        var num = random.nextFullInt();

        Assert.notEquals(0, num);
    }

    public function testSetStringSeed() {
        var random1 = new Random();
        var random2 = new Random();
        var random3 = new Random();

        random1.setStringSeed("hello world!");
        random2.setStringSeed("hello world!");
        random3.setStringSeed("abc");

        var num1 = random1.nextInt();
        var num2 = random2.nextInt();
        var num3 = random3.nextInt();

        Assert.equals(num1, num2);
        Assert.notEquals(num1, num3);
    }

    public function testRandom() {
        var random = new Random(Int64.ofInt(1));

        for (index in 0...10) {
            var num = random.random();

            Assert.isTrue(num >= 0.0);
            Assert.isTrue(num < 1.0);
        }
    }

    public function testRandomInt() {
        var random = new Random(Int64.ofInt(1));

        for (index in 0...10) {
            var num = random.randomInt(-100, 500);

            Assert.isTrue(num >= -100);
            Assert.isTrue(num <= 500);
        }
    }

    public function testUniform() {
        var random = new Random(Int64.ofInt(1));

        for (index in 0...10) {
            var num = random.uniform(-100.8, 500.3);

            Assert.isTrue(num >= -100.8);
            Assert.isTrue(num < 500.3);
        }
    }

    public function testChoice() {
        var array = ["a", "b", "c", "d", "e", "f"];
        var random = new Random(Int64.ofInt(1));

        var selected = random.choice(array);

        Assert.notEquals(-1, array.indexOf(selected));
    }

    public function testShuffle() {
        var array = ["a", "b", "c", "d", "e", "f"];
        var shuffledArray = array.copy();
        var random = new Random(Int64.ofInt(1));

        random.shuffle(shuffledArray);

        Assert.notEquals(array.toString(), shuffledArray.toString());
    }
}
