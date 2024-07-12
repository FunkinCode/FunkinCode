
package substates;

import flixel.addons.transition.TransitionData ;
import flixel.addons.transition.TransitionFade as OldTransFade;
import flixel.addons.transition.FlxTransitionSprite.TransitionStatus;


class TransitionFade extends OldTransFade
{
    private var isIn:Bool =  false;
	private var backOfBack:FlxSprite;

	public function new(data:TransitionData)
	{
		super(data);
        if (PlayState.instance == FlxG.state)
            camera = PlayState.instance.camHUD;
		backOfBack = new FlxSprite().makeGraphic(1,1);
		backOfBack.scrollFactor.set(0,0);
		add(backOfBack);
	
        // For now not
        backOfBack.setGraphicSize(back.width * 2, 1280);
	}
	

	
	public override function start(newStatus:TransitionStatus):Void
	{
		super.start(newStatus);
		
		isIn = newStatus == IN;
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
		back.screenCenter(X);
		backOfBack.y = back.y;
		backOfBack.x = back.x;
        backOfBack.color = _data.color;
        backOfBack.y -= backOfBack.height;
		// ME QUIERO SUICIDAR ayud, atentamente niz
        /*FlxG.watch.addQuick("isIn?", isIn);
        FlxG.watch.addQuick("MusicBeatState.inValues?", MusicBeatState.inValues);
        FlxG.watch.addQuick("MusicBeatState.outValues?", MusicBeatState.outValues);*/

        if (isIn){
		    backOfBack.y += back.height * 0.15 ;
        }
        else{
             backOfBack.y += back.height * (1 -  0.15 );
        }

	}
	
}
