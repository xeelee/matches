package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import utils.Number;
import utils.TouchDetector;

class HiScoresState extends FlxState {
    private var _backArrow:BackArrow;
    private var _hiScores:HiScores;
    private var _touchDetector:TouchDetector;

    override public function create():Void {
        _touchDetector = new TouchDetector(10);
        _backArrow = new BackArrow();
        add(_backArrow);
        bgColor = MConfig.BG_COLOR;
        var font = AssetPaths.software_tester_7__ttf;
        _hiScores = HiScores.create();

        _hiScores.eachThreshold((t:Int, time:Null<Int>, i:Int) -> {
            var number:String = Number.format(t, 4, " ");
            var seconds:String = Number.format(time, 5, ".");
            var timeLabel = time == null ? 'pts - never' : 'pts ..........${seconds} sec';
            var parts:Array<String> = [number, timeLabel];
            var startFrom:Int = Math.floor(FlxG.width / 2 - 820);
            for (partNo in 0...parts.length) {
                var txt = parts[partNo];
                var part:FlxText = new FlxText(startFrom + partNo * 265, 120 + 150 * i, 1800, txt);
                part.setFormat(font, 96, time == null ? FlxColor.GRAY : FlxColor.WHITE, FlxTextAlign.LEFT);
                add(part);
            }
        });
    }

    override public function update(elapsed:Float) {
        if (_touchDetector.justTouched(_backArrow)) {
            FlxG.switchState(new MenuState());
        }
    }
}
