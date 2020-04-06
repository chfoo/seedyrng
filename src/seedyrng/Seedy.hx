package seedyrng;

import haxe.io.Bytes;
import haxe.io.Error;
import haxe.io.Eof;
import haxe.Int64;


private typedef Args = {
    algorithm:String,
    seed:Int64
};


/**
    Convenience functions
**/
class Seedy {
    /**
        `Random` singleton.
    **/
    public static var instance:Random = newInstance();

    static function newInstance():Random {
        return new Random(new Xorshift128Plus());
    }

    #if sys
    /**
        Entry point for generating binary output to standard out.

        This is useful piping output to statistical testing programs.
    **/
    public static function main() {
        var generator:GeneratorInterface;
        var args = parseArgs();

         switch args.algorithm {
            case "GaloisLFSR32":
                generator = new GaloisLFSR32();
            case "xorshift128+":
                generator = new Xorshift128Plus();
            case "xorshift64+":
                generator = new Xorshift64Plus();
            default:
                throw "Unknown generator name";
        }

        var random = new Random(generator);
        var stdout = Sys.stdout();
        var buffer = Bytes.alloc(4 * 256);

        while (true) {
            for (index in 0...256) {
                var num = random.nextFullInt();
                buffer.setInt32(index * 4, num);
            }

            try {
                stdout.write(buffer);
            } catch (exception:Eof) {
                break;
            } catch (exception:Error) {
                break;
            }
        }
    }

    static function parseArgs():Args {
        var algorithm:String;
        var seed:Int64;
        var args = Sys.args();

        if (args.length >= 1) {
            algorithm = args[0];
        } else {
            algorithm = "xorshift128+";
        }

        if (args.length >= 2) {
            if (args[1] == "random") {
                seed = Int64.make(
                    Random.randomSystemInt(),
                    Random.randomSystemInt());
            } else {
                seed = Int64.parseString(args[1]);
            }
        } else {
            seed = Int64.ofInt(1);
        }

        return {
            algorithm: algorithm,
            seed: seed
        };
    }
    #end

    /**
        Returns a floating point number in the range [0, 1), That is, a number
        greater or equal to 0 and less than 1.

        See also `Random.random`.
    **/
    public static function random():Float {
        return instance.random();
    }

    /**
        Returns an integer within the given range [`lower`, `upper`]. That is,
        a number within `lower` inclusive and `upper` inclusive.

        See also `Random.randomInt`.
    **/
    public static function randomInt(lower:Int, upper:Int):Int {
        return instance.randomInt(lower, upper);
    }

    /**
        Returns a uniformly distributed floating point number within the
        given range [`lower`, `upper`). That is, a number within `lower`
        inclusive and `upper` exclusive.

        See also `Random.uniform`.
    **/
    public static function uniform(lower:Float, upper:Float):Float {
        return instance.uniform(lower, upper);
    }

    /**
        Returns an element from the given array.

        See also `Random.choice`.
    **/
    public static function choice<T>(array:Array<T>):T {
        return instance.choice(array);
    }

    /**
        Shuffles the elements, in-place, in the given array.

        See also `Random.shuffle`.
    **/
    public static function shuffle<T>(array:Array<T>) {
        instance.shuffle(array);
    }
}
