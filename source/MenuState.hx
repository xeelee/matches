package;

import FulscreenButton.FullscreenButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import utils.SpriteFactory;
import utils.TouchDetector;

class MenuState extends FlxState {
    private var _fsBtn:FlxSprite;
    private var _logo:FlxText;
    private var _start:FlxText;
    private var _exit:FlxText;
    private var _hiScores:FlxText;
    private var _loading:FlxText;
    private var _decorLeft:FlxSprite;
    private var _decorRight:FlxSprite;
    private var _touchDetector:TouchDetector;
    private var _spriteFactory:SpriteFactory;

    public override function create():Void {
        bgColor = MConfig.BG_COLOR;
        var fontDigits = AssetPaths.alarm_clock__ttf;
        var font = AssetPaths.software_tester_7__ttf;

        _fsBtn = FullscreenButton.addToState(this);

        _logo = new FlxText(FlxG.width / 2 - 600, 100, 1200, "MATCHES", 50);
        _logo.setFormat(fontDigits, 284, FlxColor.ORANGE, FlxTextAlign.CENTER);
        add(_logo);

        _start = new FlxText(FlxG.width / 2 - 350, 520, 700, "START");
        _start.setFormat(font, 108, FlxColor.WHITE, FlxTextAlign.CENTER);
        add(_start);

        _hiScores = new FlxText(FlxG.width / 2 - 350, 660, 700, "HI SCORES");
        _hiScores.setFormat(font, 108, FlxColor.WHITE, FlxTextAlign.CENTER);
        add(_hiScores);

        _exit = new FlxText(FlxG.width / 2 - 350, 800, 700, "EXIT");
        _exit.setFormat(font, 108, FlxColor.WHITE, FlxTextAlign.CENTER);
        #if !html5
        add(_exit);
        #end

        _loading = new FlxText(FlxG.width / 2 - 300, FlxG.height / 2 - 100, 600, "LOADING");
        _loading.setFormat(fontDigits, 128, FlxColor.WHITE, FlxTextAlign.CENTER);
        _loading.visible = false;
        add(_loading);

        _spriteFactory = new SpriteFactory(FlxColor.ORANGE);
        _decorLeft = _spriteFactory.create(FlxG.width / 2 - 660, 400, [
            FlxPoint.get(0, 20),
            FlxPoint.get(570, 0),
            FlxPoint.get(630, 0),
            FlxPoint.get(670, 40),
            FlxPoint.get(610, 40)
        ]);
        add(_decorLeft);
        _decorRight = _spriteFactory.create(FlxG.width / 2 - 20, 400, [
            FlxPoint.get(0, 0),
            FlxPoint.get(70, 0),
            FlxPoint.get(650, 20),
            FlxPoint.get(50, 40),
            FlxPoint.get(40, 40)
        ]);
        add(_decorRight);

        _touchDetector = new TouchDetector(10);
        FlxG.camera.fade(MConfig.BG_COLOR, 0.33, true);
    }

    public override function update(elapsed:Float):Void {
        if (_loading.visible) {
            return;
        }
        if (_touchDetector.justTouched(_start)) {
            _start.color = FlxColor.WHITE;
            _logo.visible = false;
            _start.visible = false;
            _exit.visible = false;
            _decorLeft.visible = false;
            _decorRight.visible = false;
            _hiScores.visible = false;
            if (_fsBtn != null) {
                _fsBtn.visible = false;
            }
            FlxG.camera.fade(MConfig.BG_COLOR, 0.33, false, function() {
                _loading.visible = true;
                FlxG.camera.fade(MConfig.BG_COLOR, 0.33, true, () -> {
                    FlxG.switchState(new PlayState());
                });
            });
        }
        else if (_touchDetector.justTouched(_hiScores)) {
            FlxG.camera.fade(MConfig.BG_COLOR, 0.33, false, function() {
                FlxG.switchState(new HiScoresState());
            });
        }
        #if !html5
        else if (_touchDetector.justTouched(_exit)) {
            FlxG.camera.fade(MConfig.BG_COLOR, 0.33, false, function() {
                Sys.exit(0);
            });
        }
        #end
        super.update(elapsed);
    }
}
