package utils;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class SpriteFactory {
    private var _color:FlxColor;

    public function new(color:FlxColor) {
        _color = color;
    }

    public function create(X:Float, Y:Float, vertices:Array<FlxPoint>):FlxSprite {
        var sprite:FlxSprite = new FlxSprite(X, Y);
        var maxX:Float = 0;
        var maxY:Float = 0;
        for (v in vertices) {
            if (v.x > maxX) {
                maxX = v.x;
            }
            if (v.y > maxY) {
                maxY = v.y;
            }
        }
        sprite.makeGraphic(Std.int(maxX), Std.int(maxY), FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawPolygon(sprite, vertices, _color);
        return sprite;
    }
}
