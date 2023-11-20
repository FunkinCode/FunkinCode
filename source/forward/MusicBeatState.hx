package forward;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;

class MusicBeatState extends FlxUIState
{
	private var curStep:Int = 0;
	private var curSection:Int = 0;
	private var dontchangesectionplz:Bool = false;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;
	public var transitionCamera:FlxCamera;
	public var camHUD:FlxCamera;
	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
		inittransitionCamera();	
	}
	function downloadFile(url, file) {
		api.Iteractor.current.downloadArchive(url, file, function (){
				trace("Se ha descargado tio");
		}) ;
	}
	function createMod(n = "test")
	{
		utils.Mods.createMod(n);
	}
	override function openSubState(substate:FlxSubState) {
		super.openSubState(substate);
		//subState.camera = transitionCamera;
	}
	public function inittransitionCamera():FlxCamera {
		if ( Type.getClass(FlxG.state) != states.PlayState)
		{
			transitionCamera = FlxG.camera;
			return transitionCamera;
		}
		if (transitionCamera != null)
			return transitionCamera;
		transitionCamera = camHUD;
		return transitionCamera;
	}

	override function update(elapsed:Float)
	{
		if (FlxG.drawFramerate < 30)
			FlxG.drawFramerate = FlxG.updateFramerate = 30;
		if (FlxG.keys.justPressed.R)
			{
			trace("forcing reset of mods...");
				utils.Mods.readMods();
			}
		
		// everyStep();
		var oldStep:Int = curStep;
		var oldSection:Int = curSection;

		updateCurStep();
		updateBeat();
		if (!dontchangesectionplz)
		curSection = Math.floor(curStep / 16);
		if (oldSection != curSection)
			sectionHit();

		if (oldStep != curStep && curStep >= 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}
	public function sectionHit():Void
	{
	}
	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		// do literally nothing dumbass
	}
}
