package eastereggs.asriel_state_stuff;

class MenuListButtons extends FlxGroup {
	public var canUse:Bool = false;
  	private var swagButtons:Array<FlxSprite> = [];
    public var options = ["sex", "act", "item", "mercy", "mercy", "mercy", "mercy"];
    public var gamepad:FlxGamepad;
    public var box:SwagBox;
    public var heart:Heart;
    public var curItem:Int = 0;
    public var DEBUG_SPR:FlxSprite;

	public function new(?gamepad:FlxGamepad) {
		super();

		this.gamepad = gamepad;
			var _spr:FlxSprite = new FlxSprite(0,0);
			_spr.loadGraphic('assets/secrets/images/buttons-battle/debug.png');
			_spr.scale.set(0.25, 0.25);
			_spr.updateHitbox();
			_spr.screenCenter(X);
			DEBUG_SPR = _spr;

			#if debug
			_spr.alpha = 0.1;
			add(_spr);
			#end
		var loopNum:Int = 0;
		for (i in options)
		{
			var spr:FlxSprite = new FlxSprite(-1110,0);
			spr.loadGraphic('assets/secrets/images/buttons-battle/$i.png');
			spr.scale.set(0.25, 0.25);
			spr.updateHitbox();
			add(spr);
            spr.ID =loopNum;
          

			//	spr.graphic.key = './assets/images/buttons-battle/$i.png';
			swagButtons.push(spr);
			spr.alpha = 0.1;
			loopNum += 1;
		}
	}
	public override function update(elapsed:Float) {
		super.update(elapsed);
		var _spr = DEBUG_SPR;
		_spr.screenCenter(X);
		for (i in swagButtons) {
			// :brain:
				// posicion x depende de la ID, junto al tamaño del sprite "DEBUG"
				// y el tamaño actual del Juego, (teorico 720x720 x1 pixeles); pero
				// al full screen cambia a la resolucion aaaa, que bueno se divide entre
				// las opciones actuales, eu mano confio
			i.screenCenter();
			i.x -= (_spr.width * (options.length - 1)) / 2;

			i.x +=(i.ID * (_spr.width  )); // EU MANO CONFIO (le restamos el tamaño de lista teorico)  
			i.y =FlxG.height * 0.8;
		}
		   if (canUse) {
            for( b in swagButtons) {b.alpha = 0.6;}
            if (curItem < 0)
                curItem = swagButtons.length -1;
            if (curItem >= swagButtons.length)
                curItem = 0;
            swagButtons[curItem].alpha = 1;
            heart.x = swagButtons[curItem].x + 25;//- (swagButtons[curItem].width  - heart.width) ;
            var accept = FlxG.keys.justPressed.ENTER;
            var moveUp = FlxG.keys.justPressed.RIGHT;
            var moveDown = FlxG.keys.justPressed.LEFT;
            if (gamepad != null) {
                if (gamepad.justPressed.START || gamepad.justPressed.A ) {
                    accept = true;
                }
                if (gamepad.justPressed.DPAD_LEFT || gamepad.justPressed.LEFT_STICK_DIGITAL_LEFT ) {
                    moveDown = true;
                }
                if (gamepad.justPressed.DPAD_RIGHT || gamepad.justPressed.LEFT_STICK_DIGITAL_RIGHT ) {
                    moveUp = true;
                }
            }

            if (moveUp) {
                FlxG.sound.play("assets/secrets/sounds/select-1.wav");
                curItem += 1;
            }
            if (moveDown) {
                FlxG.sound.play("assets/secrets/sounds/select-1.wav");
                curItem -= 1;
            }
            if (accept) {
                FlxG.sound.play("assets/secrets/sounds/select.wav");
                var daItem = options[swagButtons[curItem].ID];
                box.setText(daItem + " no se ha implementado.");

                switch(daItem) {
                    case "mercy":
                        box.setText("??? rechazo tu movimiento.\n* No puedes perdonar a ???");

                    case "item":
                        box.setText("No tienes items en tu inventario.");

                    case "act":
                        box.setText("Intentas actuar, pero... ¿Cómo?\n* ??? rechazo tu movimiento.");
                        
                    case "sex":
                        box.setText("tu no puede atacar nub");
                        box.setGraphicSize(250,250, true, 0.25, 2.5,()->{
                            canUse = false;
                            box.text.visible = false;
                            for( b in swagButtons) {FlxTween.tween(b, {alpha: 0.0, y: b.y - 50}, 0.5);}

                        });
                        heart.canMove = true;
                    case "debug":
                        FlxG.sound.music.time =22500 - 3000;


                }
            
            } 
        } 
	}
	
}