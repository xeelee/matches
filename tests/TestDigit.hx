package;

import massive.munit.Assert;

class TestDigit {
    var digitFactory:DigitFactory;
    var digit:Digit;

    public function new() {}

    @Before
    public function setup() {
        digitFactory = new DigitFactory(new MatchFactory(100, 10));
        digit = digitFactory.create(0, 0);
        for (match in digit.getMatches()) {
            match.enabled = true;
        }
    }

    @Test
    public function testInvertMatchState() {
        digit.set(8);
        var match:Match = digit.getMatches()[2];
        digit.invertMatchState(match);
        Assert.areEqual(MatchState.InitialInactive, match.state);
        digit.invertMatchState(match);
        Assert.areEqual(MatchState.InitialActive, match.state);
    }

    @Test
    public function testSet() {
        digit.set(7);
        Assert.areEqual(MatchState.InitialActive, digit.getMatches()[0].state);
        Assert.areEqual(MatchState.InitialInactive, digit.getMatches()[1].state);
        Assert.areEqual(MatchState.InitialInactive, digit.getMatches()[2].state);
        Assert.areEqual(MatchState.InitialInactive, digit.getMatches()[3].state);
        Assert.areEqual(MatchState.InitialActive, digit.getMatches()[4].state);
        Assert.areEqual(MatchState.InitialInactive, digit.getMatches()[5].state);
        Assert.areEqual(MatchState.InitialActive, digit.getMatches()[6].state);
    }
}
