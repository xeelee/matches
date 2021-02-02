#if !production
package;

import haxe.unit.TestCase;
import haxe.unit.TestRunner;

class TestDigit extends TestCase {
    var digitFactory:DigitFactory = new DigitFactory(new MatchFactory(100, 10));
    var digit:Digit;

    override public function setup() {
        digit = digitFactory.create(0, 0);
        for (match in digit.getMatches()) {
            match.enabled = true;
        }
    }

    public function testInvertMatchState() {
        digit.set(8);
        var match:Match = digit.getMatches()[2];
        digit.invertMatchState(match);
        assertEquals(MatchState.InitialInactive, match.state);
        digit.invertMatchState(match);
        assertEquals(MatchState.InitialActive, match.state);
    }

    public function testSet() {
        digit.set(7);
        assertEquals(MatchState.InitialActive, digit.getMatches()[0].state);
        assertEquals(MatchState.InitialInactive, digit.getMatches()[1].state);
        assertEquals(MatchState.InitialInactive, digit.getMatches()[2].state);
        assertEquals(MatchState.InitialInactive, digit.getMatches()[3].state);
        assertEquals(MatchState.InitialActive, digit.getMatches()[4].state);
        assertEquals(MatchState.InitialInactive, digit.getMatches()[5].state);
        assertEquals(MatchState.InitialActive, digit.getMatches()[6].state);
    }
}

class TestMain {
    static function main() {
        var runner = new TestRunner();
        runner.add(new TestDigit());
        var success = runner.run();
        if (!success) {
            Sys.exit(1);
        }
        Sys.exit(0);
    }
}
#end
