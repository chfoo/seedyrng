package seedyrng.tests;

import utest.Test;
import utest.Assert;


class TestXorshift64Plus extends GeneratorTester {
    public function new () {
        super(Xorshift64Plus.new);
    }
}
