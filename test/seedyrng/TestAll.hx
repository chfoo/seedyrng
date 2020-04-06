package seedyrng;

import utest.Runner;
import utest.ui.Report;

class TestAll {
    public static function main() {
        #if sys
        if (Sys.args().indexOf("--speed-test") >= 0) {
            SpeedTest.main();
        }
        #end

        var runner = new Runner();
        runner.addCases(seedyrng.tests);

        Report.create(runner);
        runner.run();
    }
}
