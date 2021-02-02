package;

import flixel.math.FlxRandom;

class Digit {
    private var _upper:Match;
    private var _middle:Match;
    private var _lower:Match;
    private var _upperLeft:Match;
    private var _upperRight:Match;
    private var _lowerLeft:Match;
    private var _lowerRight:Match;
    private var _lastArray:Array<Match>;

    public function new(upper:Match, middle:Match, lower:Match, upperLeft:Match, upperRight:Match, lowerLeft:Match, lowerRight:Match) {
        _upper = upper;
        _middle = middle;
        _lower = lower;
        _upperLeft = upperLeft;
        _upperRight = upperRight;
        _lowerLeft = lowerLeft;
        _lowerRight = lowerRight;
        _lastArray = getMatches();
    }

    public function invertMatchState(match:Match):Void {
        for (m in getMatches()) {
            if (m == match) {
                if (m.state == MatchState.InitialActive) {
                    m.state = MatchState.InitialInactive;
                    return;
                }
                if (m.state == MatchState.InitialInactive) {
                    m.state = MatchState.InitialActive;
                    return;
                }
            }
        }
    }

    public function removeMatch(?randomize:Bool = true):Null<Match> {
        var arr:Array<Match> = _lastArray;
        if (randomize) {
            var random:FlxRandom = new FlxRandom();
            random.shuffle(arr);
        }
        for (match in arr) {
            if (match.state == MatchState.InitialActive) {
                match.state = MatchState.InitialInactive;
                if (isProper())
                    return match;
                else
                    match.state = MatchState.InitialActive;
            }
        }
        return null;
    }

    public function addMatch(?randomize:Bool = true):Null<Match> {
        var arr:Array<Match> = _lastArray;
        if (randomize) {
            var random:FlxRandom = new FlxRandom();
            random.shuffle(arr);
        }
        for (match in arr) {
            if (match.state == MatchState.InitialInactive) {
                match.state = MatchState.InitialActive;
                if (isProper())
                    return match;
                else
                    match.state = MatchState.InitialInactive;
            }
        }
        return null;
    }

    public function set(value:Int):Void {
        for (match in getMatches()) {
            if (match.isCapableFor(value)) {
                match.onInitActive();
            }
            else {
                match.onInitInactive();
            }
        }
    }

    public function isProper():Bool {
        return getNumber() != null;
    }

    public function getNumber():Null<Int> {
        var block:MatchBlock = 0;
        for (match in getMatches()) {
            if (match.state == MatchState.InitialActive || match.state == MatchState.Placed) {
                block |= match.block;
            }
        }
        return MatchBlock.map.getValue(block);
    }

    public function getMatches():Array<Match> {
        return [_upper, _middle, _lower, _upperLeft, _upperRight, _lowerLeft, _lowerRight];
    }
}
