package ui;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
#if cpp
import sys.FileSystem;
#end

class ModMenu extends ui.OptionsState.Page
{
	var grpMods:FlxTypedGroup<ModMenuItem>;
	var enabledMods:Array<String> = [];
	var modFolders:Array<String> = [];

	var curSelected:Int = 0;
	var camFollow:FlxObject;
	var menuCamera:FlxCamera;

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

		if (controls.UI_UP_P)
			selections(-1);
		if (controls.UI_DOWN_P)
			selections(1);

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
		}

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
			grpMods.members[txt].color = FlxColor.WHITE;
			grpMods.members[txt].x = 30;
			if (txt == curSelected)
			{
				grpMods.members[txt].color = FlxColor.YELLOW;
				grpMods.members[txt].x = 120;
				camFollow.y = grpMods.members[txt].y - (20  * 2);


			}
		}

		organizeByY();
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
			txt.text = i;
			grpMods.add(txt);

			loopNum++;
		}
		#end
		organizeByY();
	}

	private function organizeByY():Void
	{
		for (i in 0...grpMods.length)
		{
			grpMods.members[i].y = 10 + (60 * i);
		}
	}
}

class ModMenuItem extends Alphabet
{
	public var modEnabled:Bool = false;
	public var daMod:String;

	public function new(x:Float, y:Float, str:String)
	{
		trace(str);
		super(x, y, str, true,false);
	}

	override function update(elapsed:Float)
	{
		if (modEnabled)
			alpha = 1;
		else
			alpha = 0.5;

		super.update(elapsed);
	}
}
