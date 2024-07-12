package substates;

import flixel.addons.transition.TransitionData.TransitionType;
import flixel.addons.transition.TransitionEffect;
import flixel.addons.transition.TransitionTiles;
import flixel.addons.transition.FlxTransitionSprite.TransitionStatus;

class Transition extends flixel.addons.transition.Transition 
{
	
	override function createEffect(Data:TransitionData):TransitionEffect
	{
		switch (Data.type)
		{
			case TransitionType.TILES:
				return new TransitionTiles(Data);
			case TransitionType.FADE:
				return new TransitionFade(Data);
			default:
				return null;
		}
	}

}
