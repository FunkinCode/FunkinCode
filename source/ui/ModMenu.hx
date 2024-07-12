package ui;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
#if cpp
import sys.FileSystem;
#end

class ModMenu extends ui.OptionsState.Page
{
	var grpSections:FlxTypedGroup<FlxTypedGroup<ModMenuItem>>;
	var sectionList = [
		"DOWNLOADED",
		"NEW MODS",
		"BEST OF ALL",
		"MOST DOWNLOADED"
	];
	var grpMods:FlxTypedGroup<ModMenuItem>;

	var enabledMods:Array<String> = [];
	var modFolders:Array<String> = [];

	var curSelected:Int = 0;
	var curSection:Int = 0;

	var camFollow:FlxObject;
	var menuCamera:FlxCamera;
	public var isMovingMod:Bool = false;
	public var curMod:ModMenuItem;
	

	public function new():Void
	{
		super();
		menuCamera = new SwagCamera();
		FlxG.cameras.add(menuCamera, false);
		menuCamera.bgColor = 0x0;
		camera = menuCamera;
		camFollow = new FlxObject(0,0,1,1);
		add(camFollow);

		grpMods = new FlxTypedGroup<ModMenuItem>();
		add(grpMods);
		
		menuCamera.follow(camFollow, null, 0.06);
		var margin = 160;
		menuCamera.deadzone.set(0, margin, menuCamera.width, 40);
		menuCamera.minScrollY = 0;
		refreshModList();

	}
	public function moveMod(from,to)
	{
		if (sectionList[curSection].toLowerCase()!="DOWNLOADED")
			return;
		curSelected = to;
		utils.Mods.moveMod(from,to);
		refreshModList();
		selections(0);

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.R)
			refreshModList();

		selections();

		if (controls.UI_LEFT_P)
			selections(-1);
		if (controls.UI_RIGHT_P)
			selections(1);

		if (FlxG.keys.justPressed.ENTER) {
			isMovingMod = true;
			curMod = grpMods.members[curSelected];
		}
		/*
		if (FlxG.keys.justPressed.SPACE)
			grpMods.members[curSelected].modEnabled = !grpMods.members[curSelected].modEnabled;
	
		if (FlxG.keys.justPressed.I && curSelected != 0)
		{
			moveMod(curSelected,curSelected - 1);
		}
		if (FlxG.keys.justPressed.O)
		{
			moveMod(curSelected,0);

		}
		if (FlxG.keys.justPressed.K && curSelected < grpMods.members.length - 1)
		{
			moveMod(curSelected,curSelected + 1);
		}*/

	}

	private function selections(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected >= modFolders.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = modFolders.length - 1;

		for (txt in 0...grpMods.length)
		{
	
		}

	}

	inline static var MOD_PATH = "./mods";
	private function refreshModList():Void
	{
		while (grpMods.members.length > 0)
		{
			grpMods.remove(grpMods.members[0], true);
		}

		#if desktop
		modFolders = utils.Mods.mods;


		var loopNum:Int = 0;
		for (i in modFolders)
		{
			var txt:ModMenuItem = new ModMenuItem(0, 0, i);
			grpMods.add(txt);

			loopNum++;
		}
		#end
	}


}

class ModMenuItem extends FlxTypedSpriteGroup<FlxSprite>
{
	public var modEnabled:Bool = false;
	public var daMod:String;
	
	/**
	 * If has internet & isn't local mod.
	 * **/
	public var modInfo:api.routes.Mod;
	public var id:Int; //REDO!!
	public var text:FlxText;

	public function new(x:Float, y:Float, str:String)
	{
		super(x, y);
		text = new FlxText(0,0,0, str, 32);
		add(text);

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
