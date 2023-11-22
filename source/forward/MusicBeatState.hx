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
	public var scriptManager:ScriptManager;
	inline function get_controls():Controls {
		try{
			return PlayerSettings.player1.controls;
		} catch(e){
			return null;
		}
	}
	public function new() {
		super();
		stateClass = Type.getClass(this);
        var className = Type.getClassName(stateClass);

		scriptManager = new ScriptManager();
		addScript(Paths.getDataPath() + 'global-script.hscript', false, "global-script");
		addScript(Paths.getDataPath() + 'source/${className.split(".")[className.split(".").length-1]}.hscript',false,"state" );


	}
  var stateClass:Class<Dynamic>;

	override function create()
	{
        var className = Type.getClassName(stateClass);


		if (transIn != null)
			trace('reg ' + transIn.region);
		if (stateClass != states.PlayState)
			callScripts("create");
		super.create();
		if (stateClass != states.PlayState)
			callScripts("postCreate");
		inittransitionCamera();	
        trace(className);
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
	  public function addScript(path:String, ?justOneRun:Bool = false, name:String, ?customPatern:Dynamic)
    {
    	trace(path);
    	if (name == null)
	        name = path;
	    var script = scriptManager.addScript(path, justOneRun, name, customPatern);
	    scriptAdded(script, path, name, customPatern);
    	return script;
    } 
	public function scriptAdded(script:Script, ?path:String, ?name:String, ?customPatern:Dynamic) {
            callScripts("scriptAdded", script, path, name, customPatern);
    }	
      public function callScripts(fun:String, ...args:Dynamic):Dynamic {
      	return scriptManager.callScripts(fun, ...args);
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
		if (stateClass != states.PlayState)
			callScripts("update");
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
		
			callScripts("sectionHit");
	}
	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
		if (stateClass != states.PlayState)
			callScripts("stepHit");
	}

	public function beatHit():Void
	{
		if (stateClass != states.PlayState)
			callScripts("beatHit");
		// do literally nothing dumbass
	}
}
