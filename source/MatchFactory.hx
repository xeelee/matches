package;

import flash.filters.BitmapFilter;
import flash.filters.GlowFilter;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFilterFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class MatchFactory {
    private var _lineWidth:Float = 4;
    private var _drawStyle:DrawStyle;

    private var _blockWidth:Int;
    private var _blockHeight:Int;

    public var W(get, never):Int;
    public var H(get, never):Int;

    public function get_W():Int {
        return _blockWidth;
    }

    public function get_H():Int {
        return _blockHeight;
    }

    public function new(blockWidth:Int, blockHeight:Int) {
        _drawStyle = {smoothing: true};
        _blockWidth = blockWidth;
        _blockHeight = blockHeight;
    }

    public function create(x:Float, y:Float, ?block:MatchBlock = 0, ?horizontal:Bool = false):Match {
        return new Match(createSprite(FlxColor.ORANGE, x, y, horizontal), createSprite(FlxColor.LIME, x, y, horizontal),
            createSprite(FlxColor.RED, x, y, horizontal), block);
    }

    function createSprite(color:FlxColor, x:Float, y:Float, horizontal:Bool):FlxSprite {
        var vertices:Array<FlxPoint> = [];
        var canvas:FlxSprite = new FlxSprite(x, y);
        var w:Int;
        var h:Int;
        if (horizontal) {
            w = _blockHeight;
            h = _blockWidth;
        }
        else {
            w = _blockWidth;
            h = _blockHeight;
        }
        if (horizontal) {
            vertices.push(FlxPoint.get(h / 2, 0));
            vertices.push(FlxPoint.get(0, h / 2));
            vertices.push(FlxPoint.get(h / 2, h));
            vertices.push(FlxPoint.get(w - h / 2, h));
            vertices.push(FlxPoint.get(w, h / 2));
            vertices.push(FlxPoint.get(w - h / 2, 0));
        }
        else {
            vertices.push(FlxPoint.get(0, w / 2));
            vertices.push(FlxPoint.get(w / 2, 0));
            vertices.push(FlxPoint.get(w, w / 2));
            vertices.push(FlxPoint.get(w, h - w / 2));
            vertices.push(FlxPoint.get(w / 2, h));
            vertices.push(FlxPoint.get(0, h - w / 2));
        }
        canvas.makeGraphic(w + 1, h + 1, FlxColor.TRANSPARENT, true);
        var lineStyle:LineStyle = {color: color, thickness: _lineWidth};
        var innerColor:FlxColor = FlxColor.fromRGB(color.red + 120, color.green + 120, color.blue + 120);
        FlxSpriteUtil.drawPolygon(canvas, vertices, innerColor, lineStyle, _drawStyle);
        var filter = new GlowFilter(color, 1, 28, 28, 3.5, 1);
        createFilterFrames(canvas, filter);
        return canvas;
    }

    function createFilterFrames(sprite:FlxSprite, filter:BitmapFilter) {
        var filterFrames = FlxFilterFrames.fromFrames(sprite.frames, 50, 50, [filter]);
        updateFilter(sprite, filterFrames);
        return filterFrames;
    }

    function updateFilter(spr:FlxSprite, sprFilter:FlxFilterFrames) {
        sprFilter.applyToSprite(spr, false, true);
    }
}
