package eastereggs;

import sprites.SpriteRGB;
import flixel.effects.FlxFlicker;
import eastereggs.asriel_state_stuff.Heart;
import eastereggs.asriel_state_stuff.SwagBox;
import eastereggs.asriel_state_stuff.AsrielStateIntro;
import eastereggs.asriel_state_stuff.MenuListButtons;

class AsrielState extends FlxState {
    var heart:Heart;
	var box:SwagBox;

    var bg:SpriteRGB;
    var menuList:MenuListButtons;

    public static function transition() {
        Main.resize(720,720, true);
        FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;

        if (FlxG.sound.music != null){
            FlxG.sound.music.pause();
        }

        FlxG.sound.play(Paths.sound("enter-battle", "secrets"));

        var heart = new Heart(0,0);
        FlxG.state.add(heart);
        heart.screenCenter();
        FlxG.stage.window.borderless = true;
     
        timeout(()-> FlxG.switchState(new AsrielStateIntro()), 250);
    }

    public override function create() {
        super.create();
        bg = new SpriteRGB(0,0);
        bg.makeGraphic(100, 100, FlxColor.fromRGB(50, 50, 50));
        bg.respectScreenSize = true;
        add(bg);
        //add(this.bg = new FlxEffectSprite(bg));
        this.bg.visible = false;
      
        add(box = new SwagBox());
        if (FlxG.sound.music != null)
            FlxG.sound.music.stop();
        heart = new Heart(0,0, box.fg);

    

        heart.screenCenter();
        add(heart);

        heart.flick(4);
        box.setGraphicSize(720 * 0.75, 125, true, .25);
     
        FlxTween.tween(heart, {y: FlxG.height * 0.85}, 0.4);
        

        FlxG.sound.playMusic("assets/secrets/songs/sueños y esperanzas.ogg");
        FlxG.sound.music.pause();

        new FlxTimer().start((4 * 0.1), (e)->{
            FlxG.sound.music.resume();
        });

        for (i in 0...6) {
            timeout(()->{
                if (i <= 4){
                    
                    FlxG.sound.play(Paths.sound("enter-battle-noise", "secrets"));
                } else {
                    FlxG.sound.play(Paths.sound("enter-battle-end", "secrets"));
    
                }
            }, i * 100);
           
        }
        menuList = new MenuListButtons();
        menuList.heart = heart;
        menuList.box = box;
        add(menuList);

    }
public var offsetYMult:Float = 0.6;
    override function update(elapsed:Float) {
        box.position.x = (FlxG.width / 2)-(box.width / 2);
        box.position.y = (FlxG.height ) * offsetYMult;
        if (!heart.canMove && !menuList.canUse) // DUMB
            menuList.canUse = true;

        if (FlxG.sound.music != null)
        if ( FlxG.sound.music.time > 22500 && ! bg.animate)
            {
                bg.animate = true;
                bg.visible = true;

            }
          
            var gamepad = FlxG.gamepads.getByID(0);
            super.update(elapsed);
            heart.gamepad = gamepad;
            menuList.gamepad = gamepad;
     
       
    }

}

