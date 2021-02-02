package;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import utils.TouchDetector;

class Match extends FlxBasic {
    public var selected:Bool = false;

    private var _initialAlpha:Float = 0.0;
    private var _touchDetector:TouchDetector;

    private var _sprite:FlxSprite;
    private var _spriteSuccess:FlxSprite;
    private var _spriteFailed:FlxSprite;
    private var _block:MatchBlock = 0;

    public var enabled:Bool = false;

    public var block(get, set):MatchBlock;

    public function get_block():MatchBlock {
        return _block;
    }

    public function set_block(block:MatchBlock):MatchBlock {
        return _block = block;
    }

    private var _state:MatchState;

    public var state(get, set):MatchState;

    public function get_state():MatchState {
        return _state;
    }

    public function set_state(state:MatchState):MatchState {
        if (!enabled) {
            return _state;
        }
        var previousState:MatchState = _state;
        _state = state;
        if (_state != previousState)
            onStateChanged(previousState, _state);
        return _state;
    }

    public function new(sprite:FlxSprite, spriteSuccess:FlxSprite, spriteFailed:FlxSprite, ?block:MatchBlock = 0) {
        super();
        _touchDetector = new TouchDetector(30);
        _sprite = sprite;
        _spriteSuccess = spriteSuccess;
        _spriteFailed = spriteFailed;
        _block = block;
        _spriteSuccess.visible = false;
        _spriteFailed.visible = false;
    }

    public function isCapableFor(value:Int):Bool {
        return MatchBlock.map.getBlock(value) & _block > 0;
    }

    public function isCandidate(value:Int):Bool {
        return !isCapableFor(value);
    }

    override public function update(elapsed:Float):Void {
        if (_touchDetector.justTouched(_sprite)) {
            selected = true;
        }
        super.update(elapsed);
    }

    public function onStateChanged(previousState:MatchState, newState:MatchState):Void {
        if (previousState == MatchState.Failed) {
            _spriteFailed.visible = false;
            _sprite.visible = true;
        }
        else if (previousState == MatchState.Success) {
            _spriteSuccess.visible = false;
            _sprite.visible = true;
        }

        if (newState == MatchState.Current) {
            _sprite.alpha = 0.5;
        }
        else if (newState == MatchState.InitialActive) {
            _sprite.alpha = 1.0;
        }
        else if (newState == MatchState.InitialInactive) {
            _sprite.alpha = 0.0;
        }
        else if (newState == MatchState.Candidate) {
            _sprite.alpha = 0.1;
        }
        else if (newState == MatchState.Removed) {
            _sprite.alpha = 0.0;
        }
        else if (newState == MatchState.Placed) {
            _sprite.alpha = 1.0;
        }
        else if (newState == MatchState.Success) {
            _sprite.visible = false;
            _spriteSuccess.visible = true;
        }
        else if (newState == MatchState.Failed) {
            _sprite.visible = false;
            _spriteFailed.visible = true;
        }
    }

    public function onInitActive():Void {
        state = MatchState.InitialActive;
    }

    public function onInitInactive():Void {
        state = MatchState.InitialInactive;
    }

    public function onSelected():Void {
        if (state == MatchState.Current)
            state = MatchState.InitialActive;
        else if (state == MatchState.InitialActive)
            state = MatchState.Current;
        else if (state == MatchState.Candidate)
            state = MatchState.Placed;
    }

    public function onDeselected(selected:Match):Void {
        if (selected.state == MatchState.Current) {
            if (state == MatchState.InitialInactive)
                state = MatchState.Candidate;
            else if (state == MatchState.Current)
                state = MatchState.InitialActive;
        }
        else if (selected.state == MatchState.Placed && state == MatchState.Current) {
            state = MatchState.Removed;
        }
        else if (state == MatchState.Candidate)
            state = MatchState.InitialInactive;
    }

    public function getObjects():Array<FlxBasic> {
        return [_sprite, _spriteSuccess, _spriteFailed];
    }

    public function getMiddlePoint():FlxPoint {
        var pos = _sprite.getPosition();
        return FlxPoint.get(pos.x + _sprite.width / 2, pos.y + _sprite.height / 2);
    }
}
