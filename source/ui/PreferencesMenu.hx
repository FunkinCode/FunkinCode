package ui;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import ui.AtlasText.AtlasFont;
import ui.TextMenuList.TextMenuItem;

class PreferencesMenu extends ui.OptionsState.Page
{
	public static var preferences:Map<String, Dynamic> = new Map();

	var items:TextMenuList;

	var checkboxes:Array<CheckboxThingie> = [];
	var numsArr:Array<TextMenuItem> = [];
	var sections:Array<TextMenuItem> = [];
	var defaultValues:Array<Dynamic> = [];
	var menuCamera:FlxCamera;
	var camFollow:FlxObject;
	var showSpritesWhenSelected:Array<{spr:FlxSprite, data:Dynamic, ID:Int}> = [];

	public function new()
	{
		super();

		menuCamera = new SwagCamera();
		FlxG.cameras.add(menuCamera, false);
		menuCamera.bgColor = 0x0;
		camera = menuCamera;

		add(items = new TextMenuList(Vertical, null, 1));

		createSection("Gameplay");
		createPrefItem('naughtyness', 'censor-naughty', true);
		createPrefItem('downscroll', 'downscroll', false);
		createPrefItem('middlescroll', 'middlescroll', false);
		createPrefItem('disable opponents notes', 'opponent', false);
		createPrefItem('flashing menu', 'flashing-menu', true);
		createPrefItem('Camera Zooming on Beat', 'camera-zoom', true);
		createPrefItem("speed multiplier", "song-speed", 1, 0.25, 0.25, 10, true);
		createPrefItem("HealthBarSize", "healthsize", 1, 0.01, 0.5, 1.5, false);
		createPrefItem("Disable Girlfriend", "disable-gf", false);
		createSection("");
		createSection("Game");
		createPrefItem('FPS Counter', 'fps-counter', true);
		createPrefItem("Enable DEBUG", "debug", false);
		createPrefItem("Crashlogger", "showlogscrash", true);
		createPrefItem("Crash handler", "crashhandler", true);
		createPrefItem("FPS", 'fps', 60, 1, 30, 240);
		createPrefItem('Auto Pause', 'auto-pause', false);
		createPrefItem("Master Volume", 'master-volume', 100, 1, 0,100, false);
		createSection("");


		items.selectItem(1);
		camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);
		if (items != null)
			camFollow.y = items.selectedItem.y;

		menuCamera.follow(camFollow, null, 0.06);
		var margin = 160;
		menuCamera.deadzone.set(0, margin, menuCamera.width, 40);
		menuCamera.minScrollY = 0;

		camFollow.y = items.selectedItem.y - (150 * 2);

		items.onChange.add(function(selected)
		{
			camFollow.y = selected.y - (150 * 2);
			try {
				try {
					for (when in showSpritesWhenSelected) {
						when.spr.visible = false;

						if (when.ID == items.selectedIndex) {
							when.spr.visible = true;
							when.data.onChange(getPref(defaultValues[when.ID].pref));
						}
					}	
				} catch(e) {
					trace(e);
				}
			} catch(e) {
				FlxG.watch.addQuick("getsprcatch", e);
			}
		});
	}

	public static function getPref(pref:String):Dynamic
	{
		return preferences.get(pref);
	}

	// easy shorthand?
	public static function setPref(pref:String, value:Dynamic):Void
	{
		preferences.set(pref, value);
	}

	public static function initPrefs():Void
	{
		preferences = FlxG.save.data.prefrences ;
		trace(preferences);
		if (preferences == null)
			preferences = new Map();

		preferenceCheck('censor-naughty', true);
		preferenceCheck('downscroll', false);
		preferenceCheck('flashing-menu', true);
		preferenceCheck('camera-zoom', true);
		preferenceCheck('fps', 60);
		preferenceCheck('fps-counter', true);
		preferenceCheck('auto-pause', false);
		preferenceCheck('master-volume', 100);
		preferenceCheck('middlescroll', false);
		preferenceCheck('opponent', false);
		preferenceCheck('valuetest', 1);
		preferenceCheck('song-speed', 1.0);
		preferenceCheck('healthize', 1.25);
		preferenceCheck('disable-gf', false);

		#if muted
		setPref('master-volume', 0.0);
		FlxG.sound.muted = true;
		#end
		FlxG.sound.volume = Math.floor(getPref("master-volume")) / 100;

		if (!getPref('fps-counter'))
			FlxG.stage.removeChild(Main.fpsCounter);

		FlxG.autoPause = getPref('auto-pause');
		var fps =Math.floor( getPref("fps"));
		trace(fps);
		if (/*fps < 30 || fps> 240 &&*/ Math.isNaN(fps))
			fps = 60;
		setPref('fps', fps);
		FlxG.drawFramerate = FlxG.updateFramerate=fps;
		if (FlxG.drawFramerate<30)
			FlxG.drawFramerate = FlxG.updateFramerate = 30;
		FlxG.save.flush();

	}
	public function createSpriteSizer(sprite:FlxSprite, data) {
		add(sprite);
		sprite.visible = false;
		showSpritesWhenSelected.push({spr: sprite, data: data, ID: sprite.ID});
	}

	private function createSection(name:String) {
		createPrefItem(name, "section", null, 1.0, 0, 1, true);
		sections.push(items.members[items.length - 1]);
	}

	private function createPrefItem(prefName:String, prefString:String, prefValue:Dynamic, ?multFloat:Float = 1.0, ?min:Float = 0, ?max:Float = 1, ?jp:Bool = false):Void
	{
		var type =Type.typeof(prefValue).getName() ;
		preferenceCheck(prefString, prefValue);

		var isNumber = (type == "TInt" || type == "TFloat" || type == "TNull");
		items.createItem(120, (120 * items.length) + 30, prefName, AtlasFont.Bold, function(?value:Dynamic)
		{
			preferenceCheck(prefString, prefValue);
			switch (type)
			{
				case 'TBool':
					prefToggle(prefString);
				case "TInt","TFloat":
					var num = value * multFloat;
					trace(type);
					/* if (Math.floor(multFloat) != multFloat)
						num = Math.floor(num);*/
					prefNumber(prefString, num, min, max);

				default:
					trace('swag');
			}
			defaultValues.push({value: prefValue, pref: prefString, min:min, max:max});
			
		}, isNumber, isNumber, jp, type == "TNull");
		
		switch (type)
		{
			case 'TBool':
				createCheckbox(prefString);
			case "TInt", "TFloat":
				createSums(prefString, items.length - 1);
			default:
				trace('swag');
		}
		switch (prefString) {
			case "healthsize":
				var healthbar = new FlxSprite().loadGraphic(Paths.image("healthBar"));
				healthbar.scale.x = getPref("healthsize");
				healthbar.updateHitbox();
				healthbar.screenCenter(X);
				healthbar.color = FlxColor.GREEN;
				healthbar.y = FlxG.height * 0.9;
				healthbar.scrollFactor.set();
				healthbar.ID = items.length - 1;
				trace(healthbar);
				createSpriteSizer(healthbar, 
					{onChange: (value)->{
						trace(healthbar);
						healthbar.scale.x = value;
						healthbar.updateHitbox();
						healthbar.screenCenter(X);
						healthbar.y = FlxG.height * 0.9;
					}}
					);
				var icon = new HealthIcon("bf", true);
				createSpriteSizer(icon,{
					onChange: (value)-> {
						trace(icon);
						icon.x = healthbar.x - icon.width;
						icon.y = healthbar.y - (icon.height / 2);
					}
				});

		}

		trace(type);
	}
	
	function createSums(prefString:String, ?num:Int) {
		var item = new TextMenuItem(0,  120 * (num), preferences.get(prefString), Default, (?v)->{});
		item.fireInstantly = false;
		item.isFloatMovement = false;
		item.ID = num;
		item.moves = false;
		numsArr.push(item);
		add(item);
	}
	function createCheckbox(prefString:String)
	{
		var checkbox:CheckboxThingie = new CheckboxThingie(0, 120 * (items.length - 1), preferences.get(prefString));
		checkboxes.push(checkbox);
		checkbox.ID = (items.length - 1);
		add(checkbox);
	}
	private function prefNumber(prefName:String, sum:Float, min, max) {
		var daSwap:Float = preferences.get(prefName);
		daSwap += sum;
		if (daSwap < min)
			daSwap = min;
		if (daSwap > max)
			daSwap = max;
		preferences.set(prefName, daSwap);
		for (e in numsArr) {
			if (e.ID == items.selectedIndex) {
				@:privateAccess e.setItem(Std.string(daSwap), (?a)-> trace("xd"));

			}
		}
		switch(prefName) {
			case "master-volume":
			FlxG.sound.volume = Math.floor(daSwap) / 100;
			case "fps":
				FlxG.drawFramerate = FlxG.updateFramerate= Math.floor(daSwap);
			case "healthsize":
				try {
					for (when in showSpritesWhenSelected) {
						if (when.ID == items.selectedIndex) {
							when.data.onChange(daSwap);
						}
					}	
				} catch(e) {
					trace(e);
				}
		}
	}
	/**
	 * Assumes that the preference has already been checked/set?
	 */
	private function prefToggle(prefName:String, ?specificValue:Bool, ?value:Bool = false)
	{
		var daSwap:Bool = preferences.get(prefName);

		daSwap = !daSwap;
		if (specificValue)
			daSwap = value;
		preferences.set(prefName, daSwap);
		for (box in checkboxes){
			if (box.ID == items.selectedIndex)
				box.daValue = daSwap;
		}
		trace('toggled? ' + preferences.get(prefName));

		switch (prefName)
		{
			case 'fps-counter':
				if (getPref('fps-counter'))
					FlxG.stage.addChild(Main.fpsCounter);
				else
					FlxG.stage.removeChild(Main.fpsCounter);
			case 'auto-pause':
				FlxG.autoPause = getPref('auto-pause');
		}

	}
	function syncAll() {
		for (num in numsArr) {
			var val =defaultValues[num.ID];
			prefNumber(val.pref, 0, val.min, val.max);
		}
		for (check in checkboxes) {
			var val =  defaultValues[check.ID];
			prefToggle(val.pref, true, getPref(val.pref));
		}
	}
	function getSpr() {
		/*var whe = null;
		for (when in showSpritesWhenSelected) {
			if (when.ID == items.selectedIndex) {
				trace(when);
				whe = when;
				break;
			}
		}
		trace(whe);*/
		return ;
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (controls.RESET) {
			var pref = defaultValues[items.selectedIndex];
			setPref(pref.pref, pref.value);
			syncAll();
		}

		// menuCamera.followLerp = CoolUtil.camLerpShit(0.05);
		for (num in numsArr) {
			var item = items.members[num.ID];
			if (item != null)
				num.x =item.x + item.width + 32;
			num.y = 120 * num.ID + 30;
		}
		
		items.forEach(function(daItem:TextMenuItem)
		{
			if (sections.contains(daItem)) {
				daItem.x = 0;
				daItem.alpha = 0.75;
			} else {
			if (items.selectedItem == daItem)
				daItem.x = 150;
			else
				daItem.x = 120;
			}
		});
	}

	private static function preferenceCheck(prefString:String, prefValue:Dynamic):Void
	{
		if (preferences.get(prefString) == null)
		{
			preferences.set(prefString, prefValue);
			trace('set preference!');
		
		}
		else
		{
			trace('found preference: ' + preferences.get(prefString));
		}
		FlxG.save.data.prefrences = preferences;
		FlxG.save.flush();
		trace(FlxG.save.data.prefrences );
	}
}

class CheckboxThingie extends FlxSprite
{
	public var daValue(default, set):Bool;

	public function new(x:Float, y:Float, daValue:Bool = false)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas('checkboxThingie');
		animation.addByPrefix('static', 'Check Box unselected', 24, false);
		animation.addByPrefix('checked', 'Check Box selecting animation', 24, false);

		antialiasing = true;

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();

		this.daValue = daValue;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (animation.curAnim.name)
		{
			case 'static':
				offset.set();
			case 'checked':
				offset.set(17, 70);
		}
	}

	function set_daValue(value:Bool):Bool
	{
		if (value)
			animation.play('checked', true);
		else
			animation.play('static');

		return value;
	}
}
