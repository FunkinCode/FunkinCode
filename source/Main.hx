package;

import utils.OptionsDotIni;
import flixel.system.scaleModes.*;

class Main extends Sprite
{
	public static var mainData:Main;
	public var game:FlxGay;

	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var drawgSys:DragDropping;
	public static var api:api.Iteractor;
	public static var fpsCounter:FPS;
	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		utils.Server.main();

		Lib.current.addChild(mainData = new Main());

	}

	public function new()
	{
		OptionsDotIni.init();
		Utils.setup();
		OptionsDotIni.save();
		trace("Setuped the trace");

		super();
		api = new api.Iteractor({
			canDownload: true,
			blockedUsers: [],
			disableServices: false,
		});
		api.getLocalUser((data)->{
			trace(data);
		});


		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}



	private function setupGame():Void
	{

		#if !debug
		initialState = TitleState;
		#end
		FlxGraphic.defaultPersist = true;
		addChild(game = new FlxGay(0, 0, initialState, framerate, framerate, skipSplash, startFullscreen));
		FlxG.scaleMode = new StageSizeScaleMode();
		//FlxG.scaleMode = new SwagScale();
		FlxGraphic.defaultPersist = true;

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		#end

		//stage.window.borderless = true;
		
		drawgSys = new DragDropping(onFile);
		drawgSys.filters = [];
		drawgSys.register();
		stage.window.onResize.add((w, h)-> resize(w,h, false));
		resize(0, 0);

	}
	public static var _width:Float = 0;
	public static var _height:Float = 0;
	public static function resize(w:Float, h:Float, ?resizeWindow = false) {
		_width = w;
		_height = h;
		Main.mainData._resize(Math.floor(w), Math.floor(h), resizeWindow);
	}
	public static var shouldZoom:Float = 1.0;
	static function resi(width:Int, height:Int):Void
	{
		return;
		if (width < 0)
			width = -width;
		if (height < 0)
			height = -height;
		
		eval('
		FlxG.width = ${width};
		FlxG.height = ${height};

		FlxG.initialWidth = ${width};
		FlxG.initialHeight = ${height};

		');

		FlxG.resizeGame(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
	
		
		@:privateAccess
		for ( i in FlxG.cameras.list)
		{
			i.x = 0;
			i.y = 0;
			i.width = FlxG.width;
			i.height = FlxG.height;
			i.zoom = shouldZoom;

			i.updateScrollRect();
			i.updateFlashOffset();
			i.updateFlashSpritePosition();
			i.updateInternalSpritePositions();
		}
	
			
	}
	
	public function _resize(w:Int, h:Int, ?resizeWindow:Bool = false) {
		if (w == 0) w = 1280;
		if (h == 0) h = 720;
		
		if (resizeWindow)
			mainData.stage.window.resize(w, h);
		resi(w, h);



	}
	public function onFile(str:String) {

	}
}
