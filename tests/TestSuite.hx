#if munit
package;

import flash.Lib;
import flixel.FlxGame;
import massive.munit.TestSuite;

class TestSuite extends massive.munit.TestSuite {
    public function new() {
        super();

        Lib.current.stage.addChild(new FlxGame(1920, 1080, null, 1, 60, 60, true));

        add(TestDigit);
        add(TestPlayState);
    }
}
#end
