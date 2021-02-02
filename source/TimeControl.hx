import flixel.FlxBasic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

typedef Success = {
    timeTaken:Int,
    newRecord:Bool
}

class TimeControl {
    static inline final FONT_DIGITS = "assets/fonts/alarm_clock.ttf";

    private var _labelTime:FlxText;
    private var _labelSuccessCount:FlxText;
    private var _txtTime:FlxText;
    private var _txtSuccessCount:FlxText;
    private var _timer:FlxTimer;
    private var _time:Int;
    private var _onTimeout:() -> Void;
    private var _startFromTime:Int;
    private var _successCount:Int = 0;
    private var _overallTime:Int = 0;
    private var _hiScores:HiScores;

    public function new(X:Float, Y:Float, onTimeout:() -> Void, startFromTime:Int) {
        _hiScores = HiScores.create();
        _onTimeout = onTimeout;
        _startFromTime = startFromTime;
        _timer = new FlxTimer();

        _labelSuccessCount = new FlxText(X + 450, Y + 12, 600, "pts:");
        _labelSuccessCount.setFormat(FONT_DIGITS, 64, FlxColor.GRAY);

        _txtSuccessCount = new FlxText(X + 600, Y, 600, "000");
        _txtSuccessCount.setFormat(FONT_DIGITS, 144);

        _labelTime = new FlxText(X + 990 + 245, Y + 12, 600, "time:");
        _labelTime.setFormat(FONT_DIGITS, 64, FlxColor.GRAY);

        _txtTime = new FlxText(X + 1420, Y, 600, Std.string(startFromTime));
        _txtTime.setFormat(FONT_DIGITS, 144);
    }

    public function getOverallTime():Int {
        return _overallTime;
    }

    public function isGameFinished():Bool {
        return _successCount >= 1000;
    }

    public function success():Success {
        var delta:Int = _time + 1;
        var pointsBefore = _successCount;
        _successCount += delta;
        trace("T", _overallTime);
        _setSuccessCount(_successCount);
        return {
            newRecord: _hiScores.saveTime(_overallTime, pointsBefore, _successCount),
            timeTaken: _startFromTime - _time
        };
    }

    public function fail() {
        if (_successCount > 0) {
            _successCount -= _startFromTime;
            _successCount = if (_successCount > 0) _successCount else 0;
            _setSuccessCount(_successCount);
        }
    }

    public function start() {
        _time = _startFromTime;
        _timer.start(1, _countDown, 0);
    }

    public function stop() {
        _time = _startFromTime;
        _setTime(_time);
        _timer.cancel();
    }

    public function getObjects():Array<FlxBasic> {
        return [_txtTime, _txtSuccessCount, _labelTime, _labelSuccessCount];
    }

    private function _countDown(timer:FlxTimer) {
        _setTime(_time);
        if (_time <= 0) {
            _timer.cancel();
            fail();
            _onTimeout();
            start();
        }
        else {
            _time -= 1;
            _overallTime += 1;
        }
    }

    private function _setSuccessCount(count:Int) {
        _setNumber(count, _txtSuccessCount, 3);
    }

    private function _setTime(time:Int) {
        _setNumber(time, _txtTime);
    }

    private function _setNumber(number:Int, control:FlxText, numDigits:Int = 2) {
        control.text = utils.Number.format(number, numDigits);
    }
}
