package sprites;


class StrumArrow extends SpriteBase {

    private var dirs:Array<String> = [
        "left", "down", "up", "right",
        "1", "2", "4", "3"
    ];
    public var holdTimer:Float = 0;
    public var curStage:String;
    public var useHoldTimer:Bool = false;
    public function new(Y:Float, player:Int, i:Int, curStage:String) {
        super(0, Y);
        this.curStage = curStage;
        switch (curStage)
        {
            case 'school' | 'schoolEvil':
                loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels', "week6"), true, 17, 17);

                setGraphicSize(Std.int(width * PlayState.daPixelZoom));
                updateHitbox();
                antialiasing = false;
                x += Note.swagWidth * i;
                animation.add('static', [0 +i]);
                animation.add('pressed', [4+i, 8+i], 12, false);
                animation.add('confirm', [12+i, 16+i], 24, false);

            default:
                frames = Paths.getSparrowAtlas('NOTE_assets');
            

                antialiasing = true;
                setGraphicSize(Std.int(width * 0.7));
                x += Note.swagWidth * i;

                animation.addByPrefix('static', 'arrow static instance ${dirs[i +4]}');
                animation.addByPrefix('pressed', '${dirs[i]} press', 24, false);
                animation.addByPrefix('confirm', '${dirs[i]} confirm', 24, false);
              
        }

        updateHitbox();
        scrollFactor.set();
        var mult = PlayState.isStoryMode ? 1 : .5;
        y -= 10;
        alpha = 0;
        FlxTween.tween(this, {y: y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: (0.5 + (0.2 * i)) * mult});

        ID = i;

        animation.play('static');
        x += Note.swagWidth;
        x += ((FlxG.width / 2) * player);


    }
    public function press() {
        animation.play('pressed'); 
        centerOffsets();

        useHoldTimer = false;
    }
    public function enableStatic() {

        animation.play('static'); 
        centerOffsets();

        useHoldTimer = false;
    }
    public function confirm(hold = false) {
        useHoldTimer = hold;
        holdTimer = 0;
        animation.play('confirm',true); 
        centerOffsets();

        if (!curStage.startsWith('school'))
            {
                offset.x -= 13;
                offset.y -= 13;
            }
            
    }
    override function update(elapsed:Float) {
        super.update(elapsed);
        if (useHoldTimer){
            holdTimer+=elapsed;
        if (holdTimer > Conductor.stepCrochet * 2 * 0.001 )
            enableStatic(); 
        }
     
    }
}
