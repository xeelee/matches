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
    public function testGenerateNumbers() {
        Assert.areEqual([5, 2, 3], _playState._generateNumbers(_playState._random));
    }

    @Test
    public function testSetNumbersOldFixed() {
        Assert.isTrue(_playState._setNumbers(false, 5, 7, 8));
        Assert.areEqual(5, _playState._d1.value);
        Assert.areEqual(7, _playState._d2.value);
        Assert.areEqual(8, _playState._d3.value);
    }

    @Test
    public function testSetNumbersOldFixedInvalid() {
        Assert.isFalse(_playState._setNumbers(false, 1, 1));
        Assert.areEqual(1, _playState._d1.value);
        Assert.areEqual(1, _playState._d2.value);
        Assert.areEqual(null, _playState._d3.value);
    }

    @Test
    public function testSetNumbersNewRandom() {
        Assert.isTrue(_playState._setNumbers());
        Assert.areEqual(7, _playState._d1.value);
        Assert.areEqual(1, _playState._d2.value);
        Assert.areEqual(6, _playState._d3.value);
        Assert.isTrue(_playState._setNumbers());
        Assert.areEqual(6, _playState._d1.value);
        Assert.areEqual(5, _playState._d2.value);
        Assert.areEqual(1, _playState._d3.value);
    }

    @Test
    public function testSetNumbersOldRandom() {
        Assert.isTrue(_playState._setNumbers());
        Assert.areEqual(7, _playState._d1.value);
        Assert.areEqual(1, _playState._d2.value);
        Assert.areEqual(6, _playState._d3.value);
        Assert.isTrue(_playState._setNumbers(false));
        Assert.areEqual(7, _playState._d1.value);
        Assert.areEqual(1, _playState._d2.value);
        Assert.areEqual(6, _playState._d3.value);
    }
}
#end
