package;

import flash.Lib;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flixel.system.FlxBasePreloader;

@:font("assets/fonts/alarm_clock.ttf") class AlarmClockFont extends Font {}

class Preloader extends FlxBasePreloader {
    private var _txt:TextField;

    override function create():Void {
        var width:Int = Lib.current.stage.stageWidth;
        var height:Int = Lib.current.stage.stageHeight;

        var ratio:Float = height / 1080;
        Font.registerFont(AlarmClockFont);
        _txt = new TextField();
        _txt.defaultTextFormat = new TextFormat("alarm clock", Std.int(72 * ratio), 0xffffff, false, false, false, "", "", TextFormatAlign.RIGHT);
        _txt.textColor = 0xffffff;
        _txt.embedFonts = true;
        _txt.selectable = false;
        _txt.multiline = false;
        _txt.x = width * ratio - 300;
        _txt.y = height * ratio - 200;
        _txt.width = 200;
        _txt.height = Std.int(84 * ratio);
        _txt.text = "0%";
        addChild(_txt);
        super.create();
    }

    override function update(Percent:Float):Void {
        var percent:Int = Std.int(Percent * 100);
        _txt.text = '$percent%';
        super.update(Percent);
    }
}
