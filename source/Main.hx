package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
#if html5
import js.Browser;
import js.html.CanvasElement;
#end

class Main extends Sprite {
    public function new() {
        super();
        var stageWidth:Float = FlxG.stage.window.width;
        var stageHeight:Float = FlxG.stage.window.height;
        var resX:Float = openfl.system.Capabilities.screenResolutionX;
        var resY:Float = openfl.system.Capabilities.screenResolutionY;
        var calculatedX = Math.floor(resX * stageHeight / resY);
        var width:Int = if (calculatedX > stageWidth) calculatedX else Math.floor(stageWidth);
        trace("Resoultion", resX, resY, calculatedX, width);
        #if html5
        var calculatedY = Math.floor(stageHeight * resX / stageWidth);
        var canvas:CanvasElement = cast Browser.document.getElementsByTagName("canvas")[0];
        canvas.style.cssText = StringTools.replace(canvas.style.cssText, '$stageWidth', '$resX');
        canvas.style.cssText = StringTools.replace(canvas.style.cssText, '$stageHeight', '$calculatedY');
        width = Math.floor(1080 * resX / calculatedY);
        #end
        addChild(new FlxGame(width, 1080, SplashState, 1, 60, 60, true));
    }
}
