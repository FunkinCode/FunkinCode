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
	public var descriptions:Array<String> = [];
	public var descriptionsPos:Array<Bool> = [];
	var items:TextMenuList;

	var checkboxes:Array<CheckboxThingie> = [];
	var numsArr:Array<TextMenuItem> = [];
	var sections:Array<TextMenuItem> = [];
	var defaultValues:Array<Dynamic> = [];
	var menuCamera:FlxCamera;
	var hudCamera:FlxCamera;
	var camFollow:FlxObject;
	var showSpritesWhenSelected:Array<{spr:FlxBasic, data:Dynamic, ID:Int}> = [];
	public static var instance:PreferencesMenu;
	public var maxObjectExists:Int = 5;
	public function new()
	{
		super();
		instance = this;

		menuCamera = new SwagCamera();
		hudCamera = new SwagCamera();
		FlxG.cameras.add(menuCamera, false);
		FlxG.cameras.add(hudCamera, false);
		menuCamera.bgColor = hudCamera.bgColor = 0x0;
		camera = menuCamera;

		add(items = new TextMenuList(Vertical, null, 1));

		createSection("Gameplay Preferences");
		createBoolPref('naughtyness', 'censor-naughty', true,  "Censor the obscene language contained in the game.");
		createBoolPref('downscroll', 'downscroll', false,  "Changes the note scroll from top to bottom, this can be ignored if any song requires it.");
		createBoolPref('middlescroll', 'middlescroll', false,  "Center the player's notes toward the middle.");
		createBoolPref('disable opponents notes', 'opponent', false,  "if checked, disables opponent's notes, leaving only the player's notes");
		createBoolPref('flashing menu', 'flashing-menu', true,  "This option removes/adds most flashing light effects that can cause noticeable damage or are very noticeable.");
		createBoolPref('Camera Zooming on Beat', 'camera-zoom', true,  "If unchecked, Disables per-beat zoom.");
		createPrefItem("speed multiplier", "song-speed", 1, 0.25, 0.25, 10, true, "Multiply the speed of the notes by x{val}.");
		createPrefItem("HealthBarSize", "healthsize", 1, 0.01, 0.5, 1.5, false, "Resize the healthbar!", true);
		createBoolPref("Disable Girlfriend", "disable-gf", false,  "If checked, disables girlfriend");
		createBoolPref("Unique rating sprite",'unique-rating-spr', true,  "If checked, Recycle the previous combo sprite to avoid creating a new one, this can help improve performance"); // for non-lag sections
		createBoolPref('Show rating',"show-rating", true,  "If checked, shows the rating when you press a note"); // for non-lag sections
		createBoolPref('Rating combo',"rating-combo", false,  "You are rewarded if you get a combo of a rating (the reward starts at 10) and your accuracy improves");
		createBoolPref('Old UI',"old-ui", false,  "The old UI used on Friday Night Funkin'");
		createBoolPref('Note splash',"note-splash", true,  "Disables/adds note splash when your rating is \"sick\"");
		createPrefItem("Song offsets", "offset", 1, 1, -1000, 1000, false, "Modify the offsets you will have when playing during a song");
		createSection("");

		createSection("Editors  Preferences");
		createBoolPref("Autosave mode", "autosave", true,  "Autosaves anything from the editors and loads if the state is null.");
		createBoolPref("Direct save path", "directpath", false,  "When saving, a common path (like mods/mymod/data/songs/lirical/lirical-hard.json) will be set for chart/character/stage or anything when saving\nthis also affects autosave");
		createBoolPref("Disable editors", "disableeditors", false,  "This toggles any editors (expect if is in debug)l.");

		createSection("");

		createSection("Game  Preferences");
		createBoolPref('FPS Counter', 'fps-counter', true,  "Toggle fps shows");
		createPrefItem("FPS", 'fps', 60, 1, 30, 240, false, "Enables/disables the max FPS for ya game");
		createPrefItem("Master Volume", 'master-volume', 100, 1, 0,100, false, "The current volume of the game");
		createBoolPref('Auto Pause', 'auto-pause', false,  "If checked, when the\"focus\" of the application is lost, it will pause automatically");
		createBoolPref("maximize", "maximize", false,  "Force a maximized at all times in the game");
		createBoolPref("fullscreen", "fullscreen", false,  "Force a fullscreen at all times in the game");
		createBoolPref("mouse", "enable-mouse", true, "Enables the use of the mouse in the menus of the game.");
		createSection("");

		createSection("Misc Preferences");
		createBoolPref("Enable DEBUG", "debug", false);
		createBoolPref("Crashlogger", "showlogscrash", true);
		createBoolPref("Crash handler", "crashhandler", true);
		createSection("");


		items.selectItem(1);
		camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);
		if (items != null)
			camFollow.y = items.selectedItem.y;

		menuCamera.follow(camFollow, null, 0.06);
		var margin = 160;
		camera.zoom = 0.75;

		menuCamera.deadzone.set(0, margin, menuCamera.width, 40);
		menuCamera.minScrollY = 0;

		camFollow.y = items.selectedItem.y - (150 * 2);

		items.onChange.add(function(selected)
		{
			camFollow.y = selected.y - (150 * 2);
					for (when in showSpritesWhenSelected) {
						when.spr.camera = hudCamera;
						if (when.ID == items.selectedIndex) {
							when.spr.exists = true;
							when.data.onChange(getPref(defaultValues[when.ID].pref));
						} else {
							when.spr.exists = false;
							when.data.onUnselect(getPref(defaultValues[when.ID].pref));
						}
					}	
			
					var lastIndexed:Array<TextMenuItem> = [];
					var index = 0;
					items.forEach(function(daItem:TextMenuItem)
					{
						daItem.ID = index;
						daItem.exists = Math.abs(items.selectedIndex - daItem.ID) <= maxObjectExists;
						if (sections.contains(daItem)) {
							daItem.exists = true;
							daItem.screenCenter(X);
							daItem.alpha = 1;
							daItem.y = 	itemsY[index];
					
							daItem.scrollFactor.set(1,1);
									
							if (index< items.selectedIndex) {
								for (i in lastIndexed){
									i.y = 	itemsY[i.ID];
									i.exists = Math.abs(items.selectedIndex - i.ID) <= maxObjectExists;
									i.scrollFactor.set(1,1);
								}
								daItem.y = -daItem.height;
								lastIndexed.push(daItem);
								daItem.scrollFactor.set();
							}
						} else {
						if (items.selectedItem == daItem)
							daItem.x = 150;
						else
							daItem.x = 120;
						}
						index ++;
					});
					for (i in checkboxes) {
						i.exists = items.members[i.ID].exists;
					}
					for (num in numsArr) {
						var item = items.members[num.ID];
						if (item != null){
							num.exists = item.exists;
							num.x =item.x + item.width + 32;
						}
						num.y = 120 * num.ID + 30;
					}
		});
		coolTextBG = new FlxSprite().makeGraphic(1,1,FlxColor.BLACK);
		coolTextBG.scrollFactor.set();
		add(coolTextBG);
		coolText = new FlxText(0, FlxG.height * 0.8, 940, "Pizzatower", 16);
		coolText.scrollFactor.set();
		coolText.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(coolText);
		coolText.camera = coolTextBG.camera = hudCamera;

	}
	var coolText:FlxText;
	var coolTextBG:FlxSprite;
	public function createBoolPref(name:String, value:String, val:Dynamic, description:String = "Not provied.", showUp:Bool = false) {
		createPrefItem(name, value, val, null, null, null, false,  description, showUp);

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
		preferenceCheck('unique-rating-spr', true); // for non-lag sections
		preferenceCheck('show-rating', true); // for non-lag sections
		preferenceCheck('rating-combo', false); // for non-lag sections
		preferenceCheck("old-ui", false);
		preferenceCheck("note-splash", true);
		preferenceCheck("maximize", true);
		preferenceCheck("offset", 0);
		#if muted
		setPref('master-volume', 0.0);
		FlxG.sound.muted = true;
		#end
		FlxG.sound.volume = Math.floor(getPref("master-volume")) / 100;

		if (!getPref('fps-counter'))
			FlxG.stage.removeChild(Main.fpsCounter);

		FlxG.autoPause = getPref('auto-pause');
		var fps =Math.floor( getPref("fps"));
		if (/*fps < 30 || fps> 240 &&*/ Math.isNaN(fps))
			fps = 60;
			Conductor.offset = getPref("offset");
		FlxG.drawFramerate = FlxG.updateFramerate=fps;
		if (FlxG.drawFramerate<30)
			FlxG.drawFramerate = FlxG.updateFramerate = 30;
		FlxG.save.flush();

	}
	public function createSpriteSizer(sprite:FlxBasic, data) {
		trace(sprite);
		add(sprite);
		sprite.exists = false;
		showSpritesWhenSelected.push({spr: sprite, data: data, ID: sprite.ID});
	}

	private function createSection(name:String) {
		createPrefItem(name, "section", null, 1.0, 0, 1, true);
		sections.push(items.members[items.length - 1]);
		for (section in sections) {
			if (!members.contains(section))
			add(section);
		}
	}
	public var itemsY:Array<Float> = [];

	private function createPrefItem(prefName:String, prefString:String, prefValue:Dynamic, ?multFloat:Float = 1.0, ?min:Float = 0, ?max:Float = 1, ?jp:Bool = false, ?description:String=  "Not implemented", ?shouldbeUp:Bool = false):Void
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
			
		}, isNumber, isNumber, jp, type == "TNull");
		itemsY.push(items.members[items.length - 1].y);
		descriptions.push(description);
		descriptionsPos.push(shouldbeUp);
		defaultValues.push({value: prefValue, pref: prefString, min:min, max:max});
		
		switch (type)
		{
			case 'TBool':
				createCheckbox(prefString);
			case "TInt", "TFloat":
				createSums(prefString, items.length - 1);
			default:
		}
		switch (prefString) {
			case "offset":
				trace("Hi");
				var l = new LatencyShit();
				l.ID = items.length - 1;

				createSpriteSizer(l, {onUnselect: function (val){ l.ondiscall();}, onChange: function (val){ l.onCall();}});
			case "healthsize":
				var healthbar = new FlxSprite().loadGraphic(Paths.image("healthBar"));
				healthbar.scale.x = getPref("healthsize");
				healthbar.updateHitbox();
				healthbar.screenCenter(X);
				healthbar.color = 0xFF099BE9;
				healthbar.y = FlxG.height * 0.9;
				healthbar.scrollFactor.set();
				healthbar.ID = items.length - 1;
				trace(healthbar);
				createSpriteSizer(healthbar, 
					{onUnselect: function (val){},onChange: (value)->{
						trace(healthbar);
						healthbar.scale.x = value;
						healthbar.updateHitbox();
						healthbar.screenCenter(X);
						healthbar.y = FlxG.height * 0.9;
					}}
					);
					var icon = new HealthIcon("bf", true);
					icon.ID = healthbar.ID;
					createSpriteSizer(icon,{
						onUnselect: (a)->{},
						onChange: (value)-> {
							trace(icon);
							icon.x = healthbar.x - icon.width + 40;
							icon.y = healthbar.y - (icon.height / 2);
						}
					});


		}

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
			case "offset":
				Conductor.offset = Math.floor(daSwap);
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
		coolText.text = descriptions[items.selectedIndex].replace("{val}",getPref( defaultValues[items.selectedIndex].pref));
		coolText.y = FlxG.height * 0.9;
		if (descriptionsPos[items.selectedIndex])
			coolText.y = FlxG.height * 0.1;

		coolTextBG.alpha = 0.7;
		coolText.screenCenter(X);
		coolTextBG.screenCenter(X);
		coolTextBG.y = coolText.y + (21 * 0.5);
		coolTextBG.setGraphicSize(1080, Math.floor(coolText.height * 1.25));
		if (controls.RESET) {
			var pref = defaultValues[items.selectedIndex];
			setPref(pref.pref, pref.value);
			syncAll();
		}

		// menuCamera.followLerp = CoolUtil.camLerpShit(0.05);
	
	}

	private static function preferenceCheck(prefString:String, prefValue:Dynamic):Void
	{
		if (preferences.get(prefString) == null)
		{
			preferences.set(prefString, prefValue);
		
		}
		else
		{
		}
		FlxG.save.data.prefrences = preferences;
		FlxG.save.flush();
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
