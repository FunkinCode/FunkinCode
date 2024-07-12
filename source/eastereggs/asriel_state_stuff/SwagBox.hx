package eastereggs.asriel_state_stuff;


class SwagBox extends FlxGroup
{
    public var width:Float = 125;
    public var height:Float = 125;
    public var resizeTween:FlxTween;
    public function setGraphicSize(width:Float = 0, height:Float = 0, ?tweenIt:Bool, ?speed:Float = 0.5, ?delay:Float = 0.0,?onComplete:()->Void, ?onStart:()->Void) {
        if (width <= 0) width = 125;
        if (height <= 0) height = 125;
        if (!tweenIt){
            this.height = height;
            this.width = width;
            return;
        }
        resizeTween = FlxTween.tween(this, {width: width, height: height},speed, {startDelay: delay, onStart: (e)->{if (onStart != null) onStart();}, onComplete: (e)-> {if (onComplete != null) onComplete();}});
    }
	public var bg:FlxSprite;
	public var fg:FlxSprite;

	public function new()
	{
		super();
        border = FlxRect.get(-7.5,-7.5, 15, 15);
        position = FlxPoint.get(FlxG.width / 2, FlxG.height * 0.6);
        
		bg = new FlxSprite();
		bg.makeGraphic(1, 1);
		add(bg);

		fg = new FlxSprite();
		fg.makeGraphic(1, 1, 0xFF000000);
		add(fg);
        
        add(text = new FlxText(0,0,0, "", 16));
        setText("es el fin.\n* Se está contactando con el servidor...");
		// resizeCosas();
	}
    public var text:FlxText;
    public var showText:String;
    var rest:Array<String> = [];
    public function setText(texts:String ) {
        showText = '* '+ texts;
        rest = showText.split("");
        text.text  = "";
        toNext = 0;

    }
    public function nextText() {
        if (rest.length < 1)
            return;
        var toadd = rest.shift();
        text.text += toadd;
        FlxG.sound.play("assets/secrets/sounds/text1.wav");
        toNext = 0;
      

    }

    var toNext:Float = 0;
    public var border:FlxRect ;
    public var position:FlxPoint;
	public override function update(e)
	{
        toNext += e;
        if (toNext >= 0.04)
            nextText();
		super.update(e);
		bg.setGraphicSize(width, height);
        text.fieldWidth = bg.width * 0.75;
		fg.setGraphicSize(Math.floor(bg.width - border.width), Math.floor(bg.height - border.height));

		bg.updateHitbox();
		fg.updateHitbox();

        bg.setPosition(position.x,position.y);
        text.setPosition(bg.x + 25, (bg.y - 25) + 20 * 3);
        fg.setPosition(bg.x - border.x,bg.y - border.y);


	}

  
}