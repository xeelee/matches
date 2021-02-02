package;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import utils.TouchDetector;

class Guidance {
    private static var MARGIN:Int = 4;

    private var _hand:FlxSprite;
    private var _point:FlxSprite;
    private var _border:FlxSprite;
    private var _touchDetector:TouchDetector;
    private var _matches:Array<Match>;
    private var _lastMatch:Null<Match>;
    private var _isActive:Bool = true;

    public function new(point:FlxSprite, border:FlxSprite, hand:FlxSprite, touchDetector) {
        _point = point;
        _point.visible = false;
        _border = border;
        _border.visible = false;
        _hand = hand;
        hand.visible = false;
        _touchDetector = touchDetector;
    }

    public function deactivate() {
        _isActive = false;
    }

    public function isActive():Bool {
        return _isActive;
    }

    public function update(elapsed:Float):Void {
        if (!_point.visible || !_isActive) {
            return;
        }
        if (_touchDetector.justTouched(_border)) {
            _point.visible = false;
            _border.visible = false;
            _hand.visible = false;
        }
    }

    public function clearMatches() {
        _lastMatch = null;
        _matches = [];
    }

    public function setMatches(first:Match, second:Match):Bool {
        if (!_isActive) {
            return false;
        }
        _matches = [second, first];
        return true;
    }

    public function placePoint(from:Null<Match> = null):Bool {
        var match = _matches.pop();
        if (match != null && from == _lastMatch) {
            var point = match.getMiddlePoint();
            pointAt(point.x, point.y);
            _point.visible = true;
            _border.visible = true;
            _hand.visible = true;
            _lastMatch = match;
            return true;
        }
        _point.visible = false;
        _border.visible = false;
        _hand.visible = false;
        return false;
    }

    public function pointAt(X:Float, Y:Float) {
        _point.x = X - _point.graphic.width / 2 + MARGIN / 2;
        _point.y = Y - _point.graphic.height / 2 + MARGIN / 2;
        _border.x = X - _border.graphic.width / 2 + MARGIN / 2;
        _border.y = Y - _border.graphic.height / 2 + MARGIN / 2;
        _hand.x = X - _hand.graphic.width / 2 + 16 + MARGIN / 2;
        _hand.y = Y - _hand.graphic.height / 2 + 100 + MARGIN / 2;
        _point.visible = true;
        _border.visible = true;
        _hand.visible = true;
    }

    public static function create(radius:Int = 30) {
        var point = new FlxSprite();
        point.makeGraphic(radius * 2 + MARGIN, radius * 2 + MARGIN, FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawCircle(point, -1, -1, radius, FlxColor.WHITE);
        var border = new FlxSprite();
        border.makeGraphic(radius * 4 + MARGIN, radius * 4 + MARGIN, FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawCircle(border, -1, -1, radius, FlxColor.WHITE);
        border.alpha = 0.25;
        FlxTween.tween(border, {"scale.x": 1.5, "scale.y": 1.5}, 0.5, {type: FlxTweenType.PINGPONG, ease: FlxEase.circIn});
        var hand = new FlxSprite();
        hand.loadGraphic(AssetPaths.hand__png, false, 120, 120);
        return new Guidance(point, border, hand, new TouchDetector(10));
    }

    public function getObjects():Array<FlxBasic> {
        return [_point, _border, _hand];
    }
}
