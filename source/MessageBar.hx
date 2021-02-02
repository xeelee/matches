import flixel.FlxBasic;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import flixel.util.FlxColor;

class MessageBar {
    private var _txt:FlxText;
    private var _initialText:String;
    private var _onStart:() -> Void;
    private var _tween:VarTween;

    public function new(txt:FlxText, onStart:() -> Void) {
        _txt = txt;
        _initialText = txt.text;
        _onStart = onStart;
        _txt.alpha = 0.25;
        _tween = _makeTween(_txt);
    }

    public function start() {
        _onStart();
        _txt.visible = false;
    }

    public function isWaiting():Bool {
        return _txt.visible;
    }

    public function setText(text:String) {
        _tween.cancel();
        _tween.destroy();
        _txt.text = text;
        _txt.alpha = 0.25;
        _tween = _makeTween(_txt);
    }

    private function _makeTween(obj:FlxText):VarTween {
        return FlxTween.tween(obj, {"alpha": 1}, 1, {type: FlxTweenType.PINGPONG});
    }

    public function reset(message:Null<String> = null) {
        if (message != null) {
            _txt.text = message;
            _txt.visible = true;
            FlxTween.color(_txt, 2, FlxColor.ORANGE, _txt.color, {
                type: FlxTweenType.ONESHOT,
                onComplete: (tween) -> {
                    setText(_initialText);
                }
            });
        }
        else {
            setText(_initialText);
            _txt.visible = true;
        }
    }

    public function getObjects():Array<FlxBasic> {
        return [_txt];
    }

    static public function create(X:Float, Y:Float, width:Float, text:String, onStart:() -> Void):MessageBar {
        var txt = new FlxText(X, Y, width, text);
        txt.setFormat(AssetPaths.alarm_clock__ttf, 96, FlxColor.WHITE, FlxTextAlign.CENTER);
        return new MessageBar(txt, onStart);
    }
}
