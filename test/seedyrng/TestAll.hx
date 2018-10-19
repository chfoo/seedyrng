package seedyrng;

import utest.Runner;
import utest.ui.Report;

class TestAll {
    public static function main() {
        var runner = new Runner();
        runner.addCases(seedyrng.tests);

        Report.create(runner);
        runner.run();
    }
}
