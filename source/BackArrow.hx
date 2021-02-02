import flixel.FlxSprite;

class BackArrow extends FlxSprite {
    public function new() {
        super(20, 20);
        loadGraphic(AssetPaths.back_arrow__png, false, 120, 120);
    }
}
