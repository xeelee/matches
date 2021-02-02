package;

@:enum abstract MatchBlock(Int) from Int to Int {
    var UPPER = value(0);
    var MIDDLE = value(1);
    var LOWER = value(2);
    var UPPER_LEFT = value(3);
    var UPPER_RIGHT = value(4);
    var LOWER_LEFT = value(5);
    var LOWER_RIGHT = value(6);

    static inline function value(index:Int)
        return 1 << index;

    static public var map:MatchBlockMap = new MatchBlockMap([
        1 => MatchBlock.UPPER_RIGHT | MatchBlock.LOWER_RIGHT,
        2 => MatchBlock.UPPER | MatchBlock.MIDDLE | MatchBlock.LOWER | MatchBlock.UPPER_RIGHT | MatchBlock.LOWER_LEFT,
        3 => MatchBlock.UPPER | MatchBlock.MIDDLE | MatchBlock.LOWER | MatchBlock.UPPER_RIGHT | MatchBlock.LOWER_RIGHT,
        4 => MatchBlock.MIDDLE | MatchBlock.UPPER_LEFT | MatchBlock.LOWER_RIGHT | MatchBlock.UPPER_RIGHT,
        5 => MatchBlock.UPPER | MatchBlock.MIDDLE | MatchBlock.LOWER | MatchBlock.UPPER_LEFT | MatchBlock.LOWER_RIGHT,
        6 => MatchBlock.UPPER | MatchBlock.MIDDLE | MatchBlock.LOWER | MatchBlock.UPPER_LEFT | MatchBlock.LOWER_LEFT | MatchBlock.LOWER_RIGHT,
        7 => MatchBlock.UPPER | MatchBlock.UPPER_RIGHT | MatchBlock.LOWER_RIGHT,
        8 =>
        MatchBlock.UPPER | MatchBlock.MIDDLE | MatchBlock.LOWER | MatchBlock.UPPER_LEFT | MatchBlock.UPPER_RIGHT | MatchBlock.LOWER_LEFT | MatchBlock.LOWER_RIGHT,
        9 => MatchBlock.UPPER | MatchBlock.MIDDLE | MatchBlock.LOWER | MatchBlock.UPPER_LEFT | MatchBlock.UPPER_RIGHT | MatchBlock.LOWER_RIGHT,
        0 => MatchBlock.UPPER | MatchBlock.LOWER | MatchBlock.UPPER_LEFT | MatchBlock.UPPER_RIGHT | MatchBlock.LOWER_LEFT | MatchBlock.LOWER_RIGHT
    ]);
}

class MatchBlockMap {
    private var _map:Map<Int, MatchBlock>;
    private var _reverseMap:Map<MatchBlock, Int>;

    public function new(map:Map<Int, MatchBlock>) {
        _map = map;
        _reverseMap = new Map();
        for (key in _map.keys()) {
            _reverseMap.set(_map.get(key), key);
        }
    }

    public function getBlock(value:Int) {
        return _map.get(value);
    }

    public function getValue(block:MatchBlock) {
        return _reverseMap.get(block);
    }
}
