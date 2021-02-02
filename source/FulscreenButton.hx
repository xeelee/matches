import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import utils.TouchDetector;

class FullscreenButton extends FlxSprite {
    private var _touchDetector:TouchDetector;

    public function new(X:Float, Y:Float) {
        super(X, Y);
        _touchDetector = new TouchDetector(10);
        loadGraphic(AssetPaths.fullscreen__png);
        setAlpha(FlxG.fullscreen);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        if (_touchDetector.justTouched(this)) {
            FlxG.fullscreen = !FlxG.fullscreen;
            setAlpha(FlxG.fullscreen);
        }
    }

    private function setAlpha(fullscreen:Bool) {
        if (fullscreen) {
            alpha = 1;
        }
        else {
            alpha = 0.2;
        }
    }

    public static function addToState(state:FlxState, cX:Float = 0, cY:Float = 0):Null<FlxSprite> {
        #if !mobile
        trace("add FS");
        var sprite = new FullscreenButton(20 + cX * 120 + cX * 20, 20 + cY * 120 + cY * 20);
        state.add(sprite);
        return sprite;
        #else
        return null;
        #end
    }
}
