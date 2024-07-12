package forward;

import flixel.addons.util.FlxFSM.Transition;
import openfl.events.KeyboardEvent;
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
	public override function destroy() {
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);

		super.destroy();
	}
	public override function add(obj:FlxBasic) {
		return super.add(obj);
		
	}
	public function onFileDropped(str:String) {}
	public function new() {
		super();
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);

		stateClass = Type.getClass(this);
        var className = Type.getClassName(stateClass);

		scriptManager = new ScriptManager();
		scriptManager.addVariable("curStep");
		scriptManager.addVariable("curSection");
		scriptManager.addVariable("curBeat");
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
	private function onKeyPress(event:KeyboardEvent):Void
	{
		var input = resolveKey(event.keyCode);
		updateInput(input);
		
	}
	private function resolveKey(key:FlxKey):InputKey {
		try {
		return {
			name: key.toString(),
			ID: key,
			type: FlxG.keys.checkStatus(key, JUST_PRESSED) ? JUST_PRESSED : FlxG.keys.checkStatus(key, RELEASED) ?RELEASED : NONE
		};
	}catch(e) {
	
	}
	return {
		name: key.toString(),
		ID: key,
		type: NONE
	};
	}
	public static var outValues:Float = -2; 
	public function setOutvalues(s:Float = -1) {
		outValues = s;
	}
	public static var inValues:Float = 2; 
	public function setInvalues(s:Float = 1) {
		inValues = s;
	}
	override function createTransition(data:TransitionData):flixel.addons.transition.Transition {
		if (data.type == FADE)
			return new substates.Transition(data);
		return super.createTransition(data);
	}
	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var input = resolveKey(event.keyCode);
		updateInput(input);
	
	}
	public function updateInput(key:InputKey) {
		FlxG.watch.addQuick("Key", key.name);
		FlxG.watch.addQuick("Keyid", key.ID);
		if (key.type == JUST_PRESSED)
			keyJustPressed(key);
		if (key.type == RELEASED)
			keyReleased(key);
	}
	public function keyJustPressed(key:InputKey) {

	}
	public function keyReleased(key:InputKey) {

	}
	public function fixDir(dir:String) {
		return CoolUtil.fixDir(dir);
	}
	override function update(elapsed:Float)
	{
		
		if ( PreferencesMenu.getPref("maximize"))
		Lib.application.window.maximized= PreferencesMenu.getPref("maximize");
		if (camHUD != null && subState != null)
			subState.camera = camHUD;
		if (FlxG.keys.pressed.ALT) {
			if (FlxG.keys.pressed.I) {
				Main._width += 1;
				Main.resize(Main._width, Main._height);
			}
			if (FlxG.keys.pressed.K) {
				Main._height += 1;
				Main.resize(Main._width, Main._height);
			}
		}
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
