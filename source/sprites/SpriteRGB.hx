package sprites;

class SpriteRGB extends FlxSprite {
    public var respectScreenSize:Bool=false;
    public var bgSpeed:Float = 0.035;
    public var bgData:Float = 0;
    public var bgShif:Float = 0.1;
    public var animate:Bool = false;
    public function new(x:Float, y:Float) {
        super(x,y);
        
    }
    public override function update(elapsed:Float) {
        super.update(elapsed);
        if (animate) {
            bgData += elapsed * (100 * bgSpeed);
            if (bgData > 10000)
                bgData = -10000;
            var redValue = Math.sin(bgData) * 255;
            var greenValue = Math.cos(bgData) * 255;
            var blueValue = Math.tan(bgData) * 255;
            color  = FlxColor.interpolate(color,FlxColor.fromRGBFloat(redValue, greenValue, blueValue), bgShif);
        
        }
        if(respectScreenSize){
            scrollFactor.set();
            setGraphicSize(FlxG.width * camera.zoom,FlxG.height * camera.zoom);
            updateHitbox();
            screenCenter();

        }
    }
}