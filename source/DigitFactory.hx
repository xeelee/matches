package;

class DigitFactory {
    private var _mf:MatchFactory;

    public var offset:Int = 6;

    public function new(matchFactory) {
        _mf = matchFactory;
    }

    public function create(x:Float, y:Float):Digit {
        return new Digit(_mf.create(x - offset + _mf.W, y, MatchBlock.UPPER, true),
            _mf.create(x - offset + _mf.W, y - 2 * offset + _mf.W + _mf.H, MatchBlock.MIDDLE, true),
            _mf.create(x - offset + _mf.W, y - 4 * offset + 2 * (_mf.W + _mf.H), MatchBlock.LOWER, true),
            _mf.create(x, y - offset + _mf.W, MatchBlock.UPPER_LEFT), _mf.create(x - 2 * offset + _mf.W + _mf.H, y - offset + _mf.W, MatchBlock.UPPER_RIGHT),
            _mf.create(x, y - 3 * offset + _mf.H + 2 * _mf.W, MatchBlock.LOWER_LEFT),
            _mf.create(x - 2 * offset + _mf.W + _mf.H, y - 3 * offset + _mf.H + 2 * _mf.W, MatchBlock.LOWER_RIGHT));
    }
}
