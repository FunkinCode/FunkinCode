package sprites;

class DecaySprite extends SpriteBase {

    public var recicle:Bool;
    public function new(recycled:Bool) {
        super(0,0);
        recicle = recycled;
    } 
    public function setSprite(spr:FlxGraphic, mult:Float = 0.7) {
        loadGraphic(spr);
        setGraphicSize(Std.int(width * mult));

		if (PlayState.curStage.startsWith('school'))
            setGraphicSize(Std.int(width * 6 * mult));
        else
            antialiasing = true;
        updateHitbox();
    }
    public var tween:FlxTween;
    public function appear(xOffset:Float, yOffset:Float) {
        if (tween != null){
            tween.cancel();
            tween.destroy();
        }
        velocity.set(0,0);
        alpha = 1;
        acceleration.set(0,550);
        x = FlxG.width * 0.55 - xOffset;
		// make sure rating is visible lol!
		if (x < FlxG.camera.scroll.x)
			x = FlxG.camera.scroll.x;
		else if (x > FlxG.camera.scroll.x + FlxG.camera.width - width)
			x = FlxG.camera.scroll.x + FlxG.camera.width - width;

		y = FlxG.camera.scroll.y + FlxG.camera.height * 0.4 - yOffset;
		velocity.y -= FlxG.random.int(140, 175);
		velocity.x -= FlxG.random.int(0, 10);
        tween = FlxTween.tween(this, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
                FlxG.state.remove(this,true);
                if (!recicle)
				    destroy();
        
			},
			startDelay: Conductor.crochet * 0.001
		});
    }
}