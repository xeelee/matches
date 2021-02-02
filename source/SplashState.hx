package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import utils.TouchDetector;

class SplashState extends FlxState {
    public static var SCALE:Float = 4;

    private var _logo:FlxSprite;
    private var _timer:FlxTimer;

    override public function create():Void {
        #if FLX_MOUSE
        FlxG.mouse.useSystemCursor = true;
        #end
        bgColor = FlxColor.BLACK;
        _logo = new FlxSprite();
        _logo.loadGraphic(AssetPaths.titil_logo__png, false);
        _logo.x = FlxG.width / 2 - _logo.width / 2;
        _logo.y = FlxG.height / 2 - _logo.height / 2;
        _logo.scale.x = SCALE;
        _logo.scale.y = SCALE;
        add(_logo);
        _timer = new FlxTimer();
        _timer.start(3, (timer:FlxTimer) -> _goToMenu());
        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
    }

    override public function update(elapsed:Float):Void {
        if (TouchDetector.screenJustTouched()) {
            _goToMenu();
        }
    }

    private function _goToMenu() {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> FlxG.switchState(new MenuState()));
    }
}
