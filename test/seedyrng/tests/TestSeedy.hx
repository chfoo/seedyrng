package seedyrng.tests;

import utest.Assert;
import utest.Test;


class TestSeedy extends Test {
    public function testRandom() {
        var num = Seedy.random();
        Assert.isTrue(num >= 0.0);
        Assert.isTrue(num < 1.0);
    }

    public function testRandomInt() {
        var num = Seedy.randomInt(-100, 500);

        Assert.isTrue(num >= -100);
        Assert.isTrue(num <= 500);
    }

    public function testUniform() {
        var num = Seedy.uniform(-100.8, 500.3);

        Assert.isTrue(num >= -100.8);
        Assert.isTrue(num < 500.3);
    }

    public function testChoice() {
        var array = ["a", "b", "c", "d", "e", "f"];

        var selected = Seedy.choice(array);
        Assert.notEquals(-1, array.indexOf(selected));
    }

    public function testShuffle() {
        var array = ["a", "b", "c", "d", "e", "f"];
        var shuffledArray = array.copy();

        Seedy.shuffle(shuffledArray);
        Assert.notEquals(array.toString(), shuffledArray.toString());
    }
}
