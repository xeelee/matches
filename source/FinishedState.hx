package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import utils.TouchDetector;

class FinishedState extends FlxState {
    private var _congrats:FlxText;
    private var _finished:FlxText;
    private var _hiScores:FlxText;
    private var _back:FlxText;
    private var _seconds:Int;
    private var _newRecord:Bool;
    private var _touchDetector:TouchDetector;

    public function new(seconds:Int = 0, newRecord:Bool = false) {
        super();
        _seconds = seconds;
        _newRecord = newRecord;
    }

    override public function create():Void {
        _touchDetector = new TouchDetector(20);
        bgColor = MConfig.BG_COLOR;
        var fontDigital = AssetPaths.alarm_clock__ttf;
        var font = AssetPaths.software_tester_7__ttf;

        _congrats = new FlxText(FlxG.width / 2 - 900, 100, 1800, if (_newRecord) "NEW RECORD!" else "CONGRATULATIONS!");
        _congrats.setFormat(fontDigital, 192, FlxColor.ORANGE, FlxTextAlign.CENTER);
        add(_congrats);

        _finished = new FlxText(FlxG.width / 2 - 900, 300, 1800, 'You\'ve finished the game in $_seconds seconds');
        _finished.setFormat(font, 72, FlxColor.GRAY, FlxTextAlign.CENTER);
        add(_finished);

        _hiScores = new FlxText(FlxG.width / 2 - 800, 600, 1600, "SEE HI SCORES");
        _hiScores.setFormat(font, 128, FlxColor.WHITE, FlxTextAlign.CENTER);
        add(_hiScores);

        _back = new FlxText(FlxG.width / 2 - 800, 750, 1600, "BACK TO MAIN MENU");
        _back.setFormat(font, 128, FlxColor.WHITE, FlxTextAlign.CENTER);
        add(_back);
    }

    override public function update(elapsed:Float) {
        if (_touchDetector.justTouched(_hiScores)) {
            FlxG.switchState(new HiScoresState());
        }
        else if (_touchDetector.justTouched(_back)) {
            FlxG.switchState(new MenuState());
        }
    }
}
