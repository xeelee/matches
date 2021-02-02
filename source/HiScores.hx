import flixel.util.FlxSave;
import haxe.ds.IntMap;

class HiScores {
    public static var thresholds:Array<Int> = [20, 50, 100, 200, 500, 1000];

    private var _save:FlxSave;

    public function new(save) {
        _save = save;
    }

    public function saveTime(time:Int, pointsBefore:Int, pointsAfter:Int):Bool {
        for (t in thresholds) {
            if (t > pointsBefore && t <= pointsAfter) {
                var hiTime:Null<Int> = null;
                var hiScores:Null<IntMap<Int>> = _save.data.hiScores;
                if (hiScores != null) {
                    hiTime = hiScores.get(t);
                }
                else {
                    _save.data.hiScores = new IntMap<Int>();
                }
                if (hiTime == null || hiTime > time) {
                    _save.data.hiScores.set(t, time);
                    _save.flush();
                    return true;
                }
                return false;
            }
        }
        return false;
    }

    public function eachThreshold(callback:(threshold:Int, time:Null<Int>, idx:Int) -> Void) {
        var getTime:(t:Int) -> Null<Int> = (t:Int) -> null;
        var hiScores:Null<IntMap<Int>> = _save.data.hiScores;
        if (hiScores != null) {
            getTime = (t:Int) -> hiScores.get(t);
        }
        for (i in 0...thresholds.length) {
            var t = thresholds[i];
            callback(t, getTime(t), i);
        }
    }

    public static function create():HiScores {
        var save = new FlxSave();
        save.bind("MatchesHiScores");
        return new HiScores(save);
    }
}
