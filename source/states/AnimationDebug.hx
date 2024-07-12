package states;

import substates.CharacterList;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;

using StringTools;

/**
	*DEBUG MODE
 */
class AnimationDebug extends MusicBeatState
{
	public static var instance:AnimationDebug;
	var _file:FileReference;
	public var curStage:String = "stage";

	var UI_box:FlxUITabMenu;
	var bf:Boyfriend;
	var dad:Character;
	var char:Character;
	var mahBoa:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.onComplete =() ->{};
		FlxG.sound.music.volume = .5;
		FlxG.sound.music.looped=true;

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		if (daAnim == 'bf')
			isDad = false;
		mahBoa = new Character(0,0, daAnim);
		mahBoa.screenCenter();
		mahBoa.debugMode = true;
	
		mahBoa.alpha = .5;
		
		dad = new Character(0, 0, daAnim);
		dad.screenCenter();
		dad.debugMode = true;
		add(mahBoa);
		add(dad);

		char = dad;

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		char.dance();

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);
		mahBoa.dance();

		var tabs = [
			{name: "Assets", label: 'Assets'},
			{name: "Animation", label: 'Animation'},
		];

		UI_box = new FlxUITabMenu(null, tabs, true);

		UI_box.resize(300, 400);
		UI_box.x = FlxG.width / 2;
		UI_box.y = 20;
		add(UI_box);

		super.create();
		addSongUI();
	}
	function addSongUI():Void
		{
			var tab_group_song = new FlxUI(null, UI_box);
	
			var curSprite = new FlxUIInputText(10, 10, 70, char.charFile.image, 8);
	

			var saveButton:FlxButton = new FlxButton(110, 8, "Save", function()
			{
				//saveLevel();
			});
	
			var reloadSpr:FlxButton = new FlxButton(saveButton.x + saveButton.width + 10, saveButton.y, "Reload image", function()
			{
				trace(curSprite.text);
				//loadSong(_song.song);
			});
	
			var reloadSongJson:FlxButton = new FlxButton(reloadSpr.x, saveButton.y + 30, "Reload JSON", function()
			{
				trace("test");
			});
	
			var loadAutosaveBtn:FlxButton = new FlxButton(reloadSongJson.x, reloadSongJson.y + 30, 'load autosave', function loadAutosave(){trace("test");});
	
			var player1DropDown:FlxButton = new FlxButton(10,  reloadSongJson.y + 30, 'Change char', function(){
				var characters:Array<String> = Paths.text(Paths.txt('characterList'), "").trim().rtrim().replace("\r","").split("\n");
				openSubState( new CharacterList(characters, (data)->{
					FlxG.switchState(new AnimationDebug(data));
				}, char.curCharacter));
			});
	
			var stageDropDown:FlxButton = new FlxButton(player1DropDown.x + player1DropDown.width + 1, player1DropDown.y,'Change stage', function(){
				var stages:Array<String> = Paths.text(Paths.txt('stageList'), "").trim().rtrim().replace("\r","").split("\n");
				openSubState( new CharacterList(stages, reloadStage, curStage));
			});
	
			tab_group_song.name = "Assets";
			UI_box.addGroup(tab_group_song);

			tab_group_song.add(curSprite);
			tab_group_song.add(saveButton);
			tab_group_song.add(reloadSpr);
			tab_group_song.add(reloadSongJson);
			tab_group_song.add(loadAutosaveBtn);
			tab_group_song.add(player1DropDown);
			tab_group_song.add(stageDropDown);
			UI_box.scrollFactor.set();
	
		}
	function reloadStage(stage:String) {
	
		forEach(function (e) {
			remove(e);
		});
		add(mahBoa);
		add(dad);

		add(UI_box);
		add(dumbTexts);
		add(textAnim);
		add(camFollow);
	
		if ("default" == stage)
			return;
		
		forEach(function (e) {
			remove(e);
		});
		addScript(Paths.getDataPath() + 'stages/' + stage + ".hscript", false, "stage", this);
		callScripts('create');
		add(mahBoa);
		add(dad);

		add(UI_box);
		add(dumbTexts);
		add(textAnim);
		add(camFollow);
	}
	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animationOffsets)
		{
			if (anim.length > 0){
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
			}
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}
	override function beatHit() {
		if (curBeat % mahBoa.danceSpeed == 0)
			mahBoa.dance();

	}

	override function update(elapsed:Float)
	{
		if (char.animation.curAnim != null)
			textAnim.text = char.animation.curAnim.name;

		mahBoa.flipX = char.flipX;
		mahBoa.x = char.x;
		mahBoa.y = char.y;
		mahBoa.flipY = char.flipY;
		mahBoa.antialiasing = char.antialiasing;
		mahBoa.animationOffsets = char.animationOffsets;
		
		Conductor.songPosition += 1000 * elapsed;

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim], true);
			mahBoa.dance();

			updateTexts();
			genBoyOffsets(false);
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (upP)
				char.animationOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP)
				char.animationOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP)
				char.animationOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP)
				char.animationOffsets.get(animList[curAnim])[0] -= 1 * multiplier;
			mahBoa.animationOffsets = char.animationOffsets;
			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			var outputString:String = "";

			for (swagAnim in animList)
			{
				outputString += swagAnim + " " + char.animationOffsets.get(swagAnim)[0] + " " + char.animationOffsets.get(swagAnim)[1] + "\n";
			}

			outputString.trim();
			saveOffsets(outputString);
		}

		super.update(elapsed);
	}


	private function saveOffsets(saveString:String)
	{
		if ((saveString != null) && (saveString.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(saveString, daAnim + "Offsets.txt");
		}
	}

	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved LEVEL DATA.");
	}

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
	 * Called if there is an error while saving the gameplay recording.
	 */
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Level data");
	}
}
