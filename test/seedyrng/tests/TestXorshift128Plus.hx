package seedyrng.tests;

import utest.Test;
import utest.Assert;


class TestXorshift128Plus extends GeneratorTester {
    public function new () {
        super(Xorshift128Plus.new);
    }
}
