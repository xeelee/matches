package;

import FulscreenButton.FullscreenButton;
import TimeControl.Success;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import haxe.ds.Vector;
import openfl.geom.Vector3D;
import utils.TouchDetector;

class PlayState extends FlxState {
    private static var BLOCK_WIDTH:Int = 40;
    private static var BLOCK_HEIGHT:Int = 200;

    private var _random:FlxRandom;
    private var _backArrow:BackArrow;
    private var _btnFs:FlxSprite;
    private var _mute:FlxSprite;
    private var _touchDetector:TouchDetector;
    private var _factory:DigitFactory;
    private var _d1:Digit;
    private var _d2:Digit;
    private var _d3:Digit;
    private var _allMatches:Array<Match> = [];
    private var _operatorMatches:Array<Match> = [];
    private var _arrays:Array<Array<Digit>>;
    private var _timer:FlxTimer;
    private var _timeControl:TimeControl;
    private var _messageBar:MessageBar;
    private var _failSnd:FlxSound;
    private var _successSnd:FlxSound;
    private var _guidance:Guidance;
    private var _guidedTrialsLeft:Int;

    override public function create():Void {
        super.create();
        _btnFs = FullscreenButton.addToState(this, 2, 0);
        _guidedTrialsLeft = 3;
        _random = new FlxRandom();
        _touchDetector = new TouchDetector(10);
        _failSnd = FlxG.sound.load(AssetPaths.small_hit_in_a_game__ogg, 0.35);
        _successSnd = FlxG.sound.load(AssetPaths.unlock_game_notification__ogg, 0.1);
        _timer = new FlxTimer();
        bgColor = MConfig.BG_COLOR;
        var matchFactory:MatchFactory = new MatchFactory(BLOCK_WIDTH, BLOCK_HEIGHT);
        var offset:Float = 140;
        var margin:Float = (FlxG.width - 1920) / 2 + offset;
        trace(FlxG.width, margin);
        _backArrow = new BackArrow();
        add(_backArrow);
        _mute = new FlxSprite(160, 20);
        _mute.loadGraphic(AssetPaths.mute__png, false, 120, 120);
        add(_mute);
        _factory = new DigitFactory(matchFactory);
        _d1 = _addDigit(margin + 40, 240);
        _d2 = _addDigit(margin + 680, 240);
        _d3 = _addDigit(margin + 1320, 240);
        _allMatches = _allMatches.concat(_d1.getMatches());
        _allMatches = _allMatches.concat(_d2.getMatches());
        _allMatches = _allMatches.concat(_d3.getMatches());
        var coordinates:Array<Array<Float>> = [[margin + 400, 480], [margin + 1040, 420], [margin + 1040, 500]];
        for (coord in coordinates) {
            var operatorMatch = matchFactory.create(coord[0], coord[1], true);
            _operatorMatches.push(operatorMatch);
            for (sprite in operatorMatch.getObjects()) {
                add(sprite);
            }
        }
        _timeControl = new TimeControl(FlxG.width - 1610, 12, () -> _setNumbers(false), 20);
        for (obj in _timeControl.getObjects()) {
            add(obj);
        }
        #if FLX_MOUSE
        var action = "Click";
        #else
        var action = "Tap";
        #end
        _messageBar = MessageBar.create(FlxG.width / 2 - 900, 810, 1800, '$action when ready.', () -> {
            _setMatchesEnabled(true);
            _setNumbers();
            _timeControl.start();
        });
        for (obj in _messageBar.getObjects()) {
            add(obj);
        }
        if (FlxG.sound.music == null) {
            FlxG.sound.playMusic(AssetPaths.matches__ogg, 0.9);
        }
        else {
            FlxG.sound.music.fadeIn();
        }
        FlxG.camera.fade(MConfig.BG_COLOR, 0.33, true);

        _guidance = Guidance.create();
        for (obj in _guidance.getObjects()) {
            add(obj);
        }
    }

    private function _setNumbers(?newNumbers:Bool = true, ?first:Null<Int> = null, ?second:Null<Int> = null, ?result:Null<Int> = null):Bool {
        var counter:Int = 0;
        var m1:Null<Match> = null;
        var m2:Null<Match> = null;
        trace("set numbers");
        for (match in _operatorMatches) {
            match.state = MatchState.InitialActive;
        }
        var digits = [_d1, _d2, _d3];
        var numbersOverride = [first, second, result];
        while (m1 == null || m2 == null) {
            if (++counter > 100) {
                if (first == null && second == null) {
                    return _setNumbers(false, 5, 7, 8);
                }
                return false;
            }
            if (newNumbers) {
                var numbers = _generateNumbers(_random);
                for (i => d in digits) {
                    d.set(numbers[i]);
                }
            }
            for (i => number in numbersOverride) {
                if (number != null) {
                    digits[i].set(number);
                }
            }
            trace(_d1.value, _d2.value, _d3.value);
            _arrays = [[_d1, _d3], [_d2, _d3], [_d1, _d2], [_d3, _d1], [_d3, _d2], [_d2, _d1]];
            if (newNumbers) {
                _random.shuffle(_arrays);
            }
            for (arr in _arrays) {
                m1 = arr[0].removeMatch(if (newNumbers) _random else null);
                m2 = arr[1].addMatch(if (newNumbers) _random else null);
                if (m1 != null && m2 != null && !_verify()) {
                    if (!newNumbers) {
                        _guidance.clearMatches();
                    }
                    _guidance.setMatches(m2, m1);
                    _guidance.placePoint();
                    break;
                }
                else {
                    if (m1 != null) {
                        arr[0].invertMatchState(m1);
                    }
                    if (m2 != null) {
                        arr[1].invertMatchState(m2);
                    }
                }
            }
        }
        return true;
    }

    private function _generateNumbers(random:FlxRandom):Array<Int> {
        var arr:Array<Int> = [];
        for (i in 0...2) {
            arr.push(random.int(0, 9));
        }
        arr.sort((a:Int, b:Int) -> b - a);
        arr.push(arr[0] - arr[1]);
        return arr;
    }

    override public function update(elapsed:Float):Void {
        #if !mobile
        if (_touchDetector.justTouched(_btnFs)) {
            super.update(elapsed);
            return;
        }
        #end
        if (_touchDetector.justTouched(_backArrow)) {
            FlxG.camera.fade(MConfig.BG_COLOR, 0.33, false, function() {
                FlxG.sound.music.fadeOut(0.5, 0, (tween:FlxTween) -> {
                    FlxG.sound.music.stop();
                    FlxG.switchState(new MenuState());
                });
            });
        }
        else if (_touchDetector.justTouched(_mute)) {
            if (_mute.alpha == 1) {
                FlxG.sound.music.fadeOut();
                _mute.alpha = 0.2;
            }
            else {
                FlxG.sound.music.fadeIn();
                _mute.alpha = 1;
            }
        }
        else if (_messageBar.isWaiting() && TouchDetector.screenJustTouched()) {
            _messageBar.start();
        }
        else {
            updateMatches();
            super.update(elapsed);
        }
        _guidance.update(elapsed);
    }

    private function _addDigit(x:Float, y:Float):Digit {
        var digit = _factory.create(x, y);
        for (match in digit.getMatches()) {
            add(match);
            for (sprite in match.getObjects()) {
                add(sprite);
            }
        }
        return digit;
    }

    public function updateMatches():Void {
        var selected:Match = null;
        for (match in _allMatches) {
            if (match.selected) {
                selected = match;
                match.onSelected();
                if (!_guidance.placePoint(selected)) {
                    _guidance.clearMatches();
                }
                break;
            }
        }
        if (selected != null) {
            for (match in _allMatches) {
                match.selected = false;
                if (match != selected)
                    match.onDeselected(selected);
            }
        }
        for (match in _allMatches) {
            if (match.state == MatchState.Placed) {
                match.state = MatchState.InitialActive;
                trace('FINISHED!');
                if (_verify()) {
                    _successSnd.play();
                    markMatches(MatchState.Success);
                    var success:Success = _timeControl.success();
                    if (_guidance.isActive() && (success.timeTaken < 5 || _guidedTrialsLeft <= 1)) {
                        _guidance.deactivate();
                    }
                    else {
                        _guidedTrialsLeft -= 1;
                    }
                    if (_timeControl.isGameFinished()) {
                        FlxG.camera.fade(MConfig.BG_COLOR, 0.33, false, function() { // TODO: common state switcher
                            FlxG.sound.music.fadeOut(0.5, 0, (tween:FlxTween) -> {
                                FlxG.sound.music.stop();
                                FlxG.switchState(new FinishedState(_timeControl.getOverallTime(), success.newRecord));
                            });
                        });
                    }
                    else {
                        _messageBar.reset(if (success.newRecord) "New record!" else null);
                    }
                }
                else {
                    _failSnd.play();
                    markMatches(MatchState.Failed);
                    _timeControl.fail();
                    _timer.start(1, _retryNumbers);
                }
                _timeControl.stop();
                _setMatchesEnabled(false);
                break;
            }
        }
    }

    private function markMatches(state:MatchState) {
        for (match in _allMatches.concat(_operatorMatches)) {
            if ([MatchState.InitialActive, MatchState.Placed].indexOf(match.state) != -1) {
                match.state = state;
            }
        }
    }

    private function _setMatchesEnabled(enabled:Bool) {
        for (match in _allMatches.concat(_operatorMatches)) {
            match.enabled = enabled;
        }
    }

    private function _retryNumbers(timer:FlxTimer) {
        _setMatchesEnabled(true);
        _setNumbers(false);
        timer.cancel();
        _timeControl.start();
    }

    private function _verify():Bool {
        if (_d1.isProper())
            trace('_d1 OK')
        else
            trace('_d1 FAIL');
        if (_d2.isProper())
            trace('_d2 OK')
        else
            trace('_d2 FAIL');
        if (_d3.isProper())
            trace('_d3 OK')
        else
            trace('_d3 FAIL');
        if (_d1.isProper() && _d2.isProper() && _d3.isProper()) {
            if (_d1.getNumber() - _d2.getNumber() == _d3.getNumber()) {
                trace('Equation OK');
                return true;
            }
            else {
                trace('Equation FAIL');
                return false;
            }
        }
        trace('Numbers FAIL');
        return false;
    }
}
