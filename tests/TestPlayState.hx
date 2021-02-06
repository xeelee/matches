#if munit
import flixel.math.FlxRandom;
import massive.munit.Assert;

@:access(PlayState)
class TestPlayState {
    private var _playState:PlayState;

    public function new() {}

    @Before
    public function setup() {
        var matchFactory:MatchFactory = new MatchFactory(PlayState.BLOCK_WIDTH, PlayState.BLOCK_HEIGHT);
        _playState = new PlayState();
        _playState._guidance = Guidance.create();
        _playState._factory = new DigitFactory(matchFactory);
        _playState._random = new FlxRandom(263469696);
        trace(_playState._random.currentSeed);
        trace(_playState._random.initialSeed);
        _playState._d1 = _playState._factory.create(0, 0);
        _playState._d2 = _playState._factory.create(100, 0);
        _playState._d3 = _playState._factory.create(200, 0);
        for (d in [_playState._d1, _playState._d2, _playState._d3]) {
            for (m in d.getMatches()) {
                m.enabled = true;
            }
        }
        _playState.markMatches(MatchState.InitialActive);
    }

    @Test
    public function testSetNumbersOldFixed() {
        _playState._setNumbers(false, 5, 7, 8);
        Assert.areEqual(5, _playState._first);
        Assert.areEqual(7, _playState._second);
        Assert.areEqual(8, _playState._result);
    }

    @Test
    public function testSetNumbersNewRandom() {
        _playState._setNumbers();
        Assert.areEqual(7, _playState._first);
        Assert.areEqual(1, _playState._second);
        Assert.areEqual(6, _playState._result);
        _playState._setNumbers();
        Assert.areEqual(6, _playState._first);
        Assert.areEqual(5, _playState._second);
        Assert.areEqual(1, _playState._result);
    }

    @Test
    public function testSetNumbersOldRandom() {
        _playState._setNumbers();
        Assert.areEqual(7, _playState._first);
        Assert.areEqual(1, _playState._second);
        Assert.areEqual(6, _playState._result);
        _playState._setNumbers(false);
        Assert.areEqual(7, _playState._first);
        Assert.areEqual(1, _playState._second);
        Assert.areEqual(6, _playState._result);
    }
}
#end
