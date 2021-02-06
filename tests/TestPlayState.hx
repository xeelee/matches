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
        _playState._random = new FlxRandom();
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
    public function testSetNumbers() {
        _playState._setNumbers(false, 5, 7, 8);
        Assert.areEqual(_playState._first, 5);
        Assert.areEqual(_playState._second, 7);
        Assert.areEqual(_playState._result, 8);
    }
}
#end
