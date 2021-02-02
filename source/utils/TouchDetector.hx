package utils;

import flixel.FlxG;
import flixel.FlxSprite;

class TouchDetector {
    private var _margin:Float;

    public function new(margin:Float = 0) {
        _margin = margin;
    }

    public static function screenJustTouched():Bool {
        var touchesCount:Int = 0;

        #if FLX_TOUCH
        for (touch in FlxG.touches.list) {
            if (touch.justPressed) {
                touchesCount += 1;
            }
        }
        #end
        #if FLX_MOUSE
        if (FlxG.mouse.justPressed) {
            touchesCount += 1;
        }
        #end
        return touchesCount > 0;
    }

    public function justTouched(sprite:FlxSprite):Bool {
        var marginX = sprite.width < sprite.height ? _margin : 0;
        var marginY = sprite.width < sprite.height ? 0 : _margin;
        #if FLX_MOUSE
        if (FlxG.mouse.justPressed && _detectJustTouched(FlxG.mouse.x, FlxG.mouse.y, sprite, marginX, marginY)) {
            return true;
        }
        #end
        #if FLX_TOUCH
        for (touch in FlxG.touches.list) {
            if (touch.justPressed && _detectJustTouched(touch.x, touch.y, sprite, marginX, marginY)) {
                return true;
            }
        }
        #end
        return false;
    }

    private function _detectJustTouched(X:Float, Y:Float, sprite:FlxSprite, marginX:Float = 0, marginY:Float = 0) {
        return (X > sprite.x - marginX
            && X < sprite.x + sprite.width + marginX
            && Y > sprite.y - marginY
            && Y < sprite.height + sprite.y + marginY);
    }
}
