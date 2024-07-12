package states;


import utils.Stage;
import forward.InputKey;
import openfl.events.KeyboardEvent;
import sprites.DecaySprite;
import sprites.CoolText;
import sprites.StrumArrow;
import utils.Script;
import utils.CheatsManager;
import sys.thread.Thread;
import openfl.events.EventType;
using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var instance:PlayState;
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var deathCounter:Int = 0;
	public static var botplay:Bool = true;
	public static var practiceMode:Bool = false;

	private var simulateBeat:Float = 0;
	private var beat:Int = 0;

	private var vocals:FlxSound;
	private var vocalsFinished:Bool = false;
	
	public var testField:Int;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;
	public var shader:ColorSwap;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<StrumArrow>;
	private var playerStrums:FlxTypedGroup<StrumArrow>;
	private var player2Strums:FlxTypedGroup<StrumArrow>;

	private var camZooming:Bool = true;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	var curSongPositionData:Float = 0.0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	public var oldtimestamp:Float;
	private var iconP2:HealthIcon;
	private var camGame:FlxCamera;
	
	private var directions:Array<String> = ["left", "down", "up", "right"];

	private var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	public static var seenCutscene:Bool = false;

	var foregroundSprites:FlxTypedGroup<BGSprite>;

	var tankmanRun:FlxTypedGroup<TankmenBG>;
	public var cancelCountDown:Bool = false;
	public var cheatsManager:CheatsManager;

	var kys:Bool = false;
	var forceRating:String = "";

	var songScore:Int = 0;
	var misses:Int = 0;
	public var accuracy:String;
	var hit_data:Float = 1;
	var ratingCombo:Int = 0;
	var lastRating:String = "sick";
	var totalHits:Int = 1; // FOr better acc?!??!?!? and nan bug ajdlaskdjaslkd
 	var scoreTxt:CoolText;

	var scripts:Array<Script> = [];
	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;
	var defaultCamHUDZoom:Float = 0.975;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	#if discord_rpc
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	var camPos:FlxPoint;
	var doof:DialogueBox;
    var events:Array<Dynamic> = [];


	override public function create()
	{
	
		FlxGay.waitDeleteRam = true;
		unspawnNotes = [];
		events = [];
		instance = this;
		// Do a trace of the song data 
		
		
		curStage = SONG.stage;
		curSong = SONG.song.toLowerCase();
		scriptManager.addVariable("boyfriend");
		scriptManager.addVariable("dad");
		scriptManager.addVariable("gf");


		var e = Paths.readDir(Paths.getDataPath() + 'songs/$curSong/');
		for (i in e)
		{

			var name = i.split(".")[0];
			var extension = i.split(".")[1];

			if (["hscript", "hxs", "hx", "hscript"].contains(extension)) {
				addScript(Paths.getDataPath() + 'songs/$curSong/$i', false, "script");
		
			}
		}
		addScript(Paths.getDataPath() + 'stages/$curStage.hscript', false, "stage");

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		camGame = new SwagCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;


		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);

		persistentUpdate = true;
		persistentDraw = true;

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		foregroundSprites = new FlxTypedGroup<BGSprite>();
		for (path in [
			'songs/${curSong}/${curSong}Dialogue',
			'songs/${curSong}/dialogue',
			'songs/${curSong}-dialogue',
			'songs/${curSong}/$curSong-dialogue',
		]){
		if (Paths.exists(Paths.txt(path), TEXT)) {
			dialogue = Paths.text(Paths.txt(path)).trim().rtrim().replace("\r","").split("\n");
		}
		}
		if (dialogue == null || dialogue.length < 1) {
			dialogue = [":bf:Testing"];
		}
	
       	doof= new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.cameras = [camHUD];
		#if discord_rpc
		initDiscord();
		#end
		tankmanRun = new FlxTypedGroup<TankmenBG>();


		callScripts("create");


		switch (curStage)
		{
			case "stage":
				defaultCamZoom = 0.9;
				curStage = 'stage';

				var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
		}


		gf = new Character(400, 130, SONG.players[2]);
		gf.scrollFactor.set(0.95, 0.95);

		addScript(Paths.getDataPath() + 'characters/${SONG.players[0]}.hscript', false, 'bf-script', boyfriend);
		addScript(Paths.getDataPath() + 'characters/${SONG.players[1]}.hscript', false, 'dad-script', dad);
		addScript(Paths.getDataPath() + 'characters/${SONG.players[2]}.hscript', false, 'gf-script', gf);

		dad = new Character(100, 100, SONG.players[1]);

		camPos = new FlxPoint(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y);

		if (SONG.players[1] == SONG.players[2]) {
			dad.setPosition(gf.x, gf.y);
			gf.visible = false;
		}
		boyfriend = new Boyfriend(770, 450, SONG.players[0]);

		callScripts("repositionChars");

		add(gf);
		add(dad);
		add(boyfriend);
		var stageData = Stage.loadFromJSON();
		defaultCamZoom = stageData.zoom;

		for (i in stageData.positions) {
			if (i.name == "bf")
				i.name = "boyfriend";
			var ch =  Reflect.getProperty(this, i.name);
			try {
				ch.x += i.x;
				ch.y += i.y;
			} catch (e){}
		}
		add(foregroundSprites);

		gf.x += gf.position[0];
		gf.y += gf.position[1];
		boyfriend.x += boyfriend.position[0];
		boyfriend.y += boyfriend.position[1];
		dad.x += dad.position[0];
		dad.y += dad.position[1];


		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);

		if (PreferencesMenu.getPref('downscroll'))
			strumLine.y = FlxG.height - 150; // 150 just random ass number lol

		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<StrumArrow>();
		add(strumLineNotes);

		// fake notesplash cache type deal so that it loads in the graphic?

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		var noteSplash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(noteSplash);
		noteSplash.alpha = 0.1;

		add(grpNoteSplashes);

		playerStrums = new FlxTypedGroup<StrumArrow>();
		player2Strums = new FlxTypedGroup<StrumArrow>();

		generateSong();

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		healthBarBG.scale.x = getPref("healthsize");
		healthBarBG.updateHitbox();
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		if (PreferencesMenu.getPref('downscroll'))
			healthBarBG.y = FlxG.height * 0.1;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);
		
		songBar = new FlxBar(0, 720 - 30, LEFT_TO_RIGHT, Std.int(FlxG.width /2), Std.int(healthBarBG.height - 8), this,
			'curSongPositionData', 0, 1);
			songBar.scrollFactor.set();
			songBar.screenCenter(X);
			songBar.numDivisions=Math.floor(FlxG.width /4);
			songBar.createFilledBar(0xFFFFFFFF, 0xFF313131);
		// healthBar
 

		scoreTxt = new CoolText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 30, 0, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.screenCenter(X);
		add(scoreTxt);
		scoreTxt.separator = " | ";
	
		scoreTxt.addVariableToListen(this, 'songScore', "Score");
		if (!getPref('old-ui')) {
			scoreTxt.addVariableToListen(this, 'accuracy', "Accuracy");
			scoreTxt.addVariableToListen(this, 'misses', "Misses");
			scoreTxt.addVariableToListen(this, 'combo', "Combo");
			if (getPref("rating-combo"))
				scoreTxt.addVariableToListen(this, 'ratingCombo', "Rating Combo");

			
		}


		iconP1 = new HealthIcon(SONG.players[0], true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.players[1], false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		grpNoteSplashes.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];

		cheatsManager = new CheatsManager(camHUD, this);

		shader = new ColorSwap();
		FlxG.camera.filters = [new ShaderFilter(shader.shader)];

			
		startingSong = true;
		callScripts("postCreate");

		if (isStoryMode && !seenCutscene)
		{
			seenCutscene = true;
			switch (curSong.toLowerCase())
			{
				case 'ugh' |"stress" | "guns":
					cancelCountDown = true;
					playVideo('${curSong}Cutscene');
				

			}
		}
			if(!cancelCountDown)
				startCountdown();
			

		super.create();
		add(songBar);
		songBar.camera = camHUD;

	}

	public function getPref(str:String):Dynamic
		return PreferencesMenu.getPref(str);

	public function playVideo(name:String)
	{

		#if VIDEOS
		trace(Sys.getCwd() +Paths.file('music/${name}.mp4'));
		inCutscene = true;

		var blackShit:FlxSprite = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackShit.scrollFactor.set();
		add(blackShit);

		var vid:FlxVideo = new FlxVideo();
		vid.play(Paths.file('music/${name}.mp4'));
		vid.onStopped.add( function()
		{
			remove(blackShit);
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, (Conductor.crochet / 1000) * 5, {ease: FlxEase.quadInOut});
			startCountdown();
			cameraMovement();
		});

		FlxG.camera.zoom = defaultCamZoom * 1.2;

		camFollow.x += 100;
		camFollow.y += 100;
		#else
			trace("Invalid target");
			startCountdown();
		#end
	}
	private function dispatchNote(note:Note) {
		note.kill();
		notes.remove(note, true);
		note.destroy();
	}
	private function checkNote(key:Int)
	{
		if (botplay || !startedCountdown || paused || key < 0)
			return;
		if (notes.length > 0 && generatedMusic)
		{

			var pressNotes:Array<Note> = [];
			var canHit:Bool = true;
			var daNotes:Array<Note> = [];
			var canMiss = !true; // for 

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.player == 0 && !daNote.isSustainNote)
				{
					if (daNote.noteData == key) daNotes.push(daNote);
					canMiss = true;
				}
			});

			daNotes.sort(sortByShit);

			if (daNotes.length > 0)
			{
				for (epicNote in daNotes)
				{
					for (note in pressNotes)
					{
						if (Math.abs(note.strumTime - epicNote.strumTime) < 10)
							dispatchNote(note);
						else
							canHit = false;
					}

					if (canHit)
					{
						goodNoteHit(epicNote);
						pressNotes.push(epicNote);
						return;
					}
				}
			}
				
			
			if (canMiss) noteMiss(key);

		}

		var spr:StrumArrow = playerStrums.members[key];
		if (spr != null && spr.animation.curAnim.name != 'confirm')
		{
			spr.press();
		}
	}
			
	override function keyJustPressed(key:InputKey):Void
	{
		super.keyJustPressed(key);
		var key:Int = CoolUtil.resolveKey(key.ID);
		checkNote(key);

	}
	override function keyReleased(key:InputKey) {
		super.keyReleased(key);

		var key:Int = CoolUtil.resolveKey(key.ID);
	
		if(key > -1){
			if(!botplay && startedCountdown && !paused)
				{
					var spr:StrumArrow = playerStrums.members[key];
					if(spr != null)
						spr.enableStatic();
				}
		}
	}
	
	
	function updateDiscord():Void {
		
		#if discord_rpc
		if(scoreTxt != null)
		storyDifficultyText = CoolUtil.difficultyString();
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);

		#end
	}
	function initDiscord():Void
	{
		#if discord_rpc
		iconRPC = SONG.players[1];

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		detailsText = isStoryMode ? "Story Mode"  : "Freeplay";
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		updateDiscord();
		#end
	}



	var startTimer:FlxTimer = new FlxTimer();
	var perfectMode:Bool = false;

	function startCountdown():Void
	{

		inCutscene = false;
		camHUD.visible = true;

		generateStaticArrows(0);
		generateStaticArrows(1);

		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;
		updateDiscord();

		startTimer.start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			beatHit();

			var introSprPaths:Array<String> = ["ready", "set", "go"];
			var altSuffix:String = "";

			if (curStage.startsWith("school"))
			{
				altSuffix = '-pixel';
				introSprPaths = ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel'];
			}

			var introSndPaths:Array<String> = ["intro3" + altSuffix, "intro2" + altSuffix,
				"intro1" + altSuffix, "introGo" + altSuffix];

			if (swagCounter > 0)
				readySetGo(introSprPaths[swagCounter - 1]);
			FlxG.sound.play(Paths.sound(introSndPaths[swagCounter]), 0.6);
			swagCounter += 1;
		}, 4);
	}

	function readySetGo(path:String):Void
	{
		var spr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(path));
		spr.scrollFactor.set();

		if (curStage.startsWith('school'))
			spr.setGraphicSize(Std.int(spr.width * daPixelZoom));

		spr.updateHitbox();
		spr.screenCenter();
		add(spr);
		FlxTween.tween(spr, {y: spr.y += 100, alpha: 0}, Conductor.crochet / 1000, {
			ease: FlxEase.cubeInOut,
			onComplete: function(twn:FlxTween)
			{
				spr.destroy();
			}
		});
	}

	var previousFrameTime:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		#if discord_rpc
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		#end
		updateDiscord();

	}
	var _songGeneratorActive= false;
	private function createSectionsByEventloop() {
		_songGeneratorActive = true;
			
	}

	private function generateSong():Void
	{
		// FlxG.log.add(ChartParser.parse());
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);
		Paths.inst(SONG.song);
		vocals = new FlxSound();
		if (Paths.hasVocals(songData.song))
			vocals.loadEmbedded(Paths.voices(SONG.song));

		vocals.onComplete = function()
		{
			vocalsFinished = true;
		};
		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		generatedMusic = true;
		createSections(32, -1);
		createSectionsByEventloop();


	}
	override function sectionHit()
	{
		try {
			createSections(6, curSection - 6); // four next sections
		} catch (e) {}
	}
	var sectionsCreated:Array<Int>=  [];
	function createSections(loops:Int, index:Int)
	{
		var songData = SONG;
		var noteData = songData.sections;
		
		for (i in index...(index + loops))
		{
			if (!sectionsCreated.contains(i)){
			        sectionsCreated.push(i);

			        var section = noteData[i];
			        if (section != null)
				        createSection(section);
		    } 
		}
	}

	// Now you are probably wondering why I made 2 of these very similar functions
	// sortByShit(), and sortNotes(). sortNotes is meant to be used by both sortByShit(), and the notes FlxGroup
	// sortByShit() is meant to be used only by the unspawnNotes array.
	// and the array sorting function doesnt need that order variable thingie
	// this is good enough for now lololol HERE IS COMMENT FOR THIS SORTA DUMB DECISION LOL
	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return sortByValues(Obj1.strumTime,Obj2.strumTime);
 	}
	function sortNotes(Order:Int = FlxSort.ASCENDING, Obj1:Note, Obj2:Note)
	{	
		return FlxSort.byY(Order, Obj1, Obj2);
	
	}
	function sortEvents(eventNote, eventNote2) {
		return sortByValues(eventNote.time,eventNote2.time);
	}
    function sortByValues(Value1:Float, Value2:Float) {
        var Order = -1;
		var result:Int = Order;

		if (Value1 < Value2)
		{
			result = Order;
		}
		else if (Value1 > Value2)
		{
			result = -Order;
		}
        return result;

    }

	// ^ These two sorts also look cute together ^
	public var playersBg:Array<FlxSprite> = [];
	private function generateStaticArrows(player:Int):Void
	{
		if (player != 1 && getPref("opponent")) return;
		var playerBg:FlxSprite = new FlxSprite();
		playerBg.makeGraphic(Math.floor(150 * 3.5), 950);
		playerBg.color =FlxColor.BLACK;
		playerBg.alpha = 0.5;
		playerBg.scrollFactor.set();
		playerBg.screenCenter(Y);
		playersBg.push(playerBg);
		playerBg.camera = camHUD;
		insert(0,playerBg);

		for (i in 0...4)
		{
			// FlxG.log.add(i);
		
			var babyArrow:StrumArrow = new StrumArrow( strumLine.y, player, i, curStage);
			if (i == 0)
				playerBg.x = babyArrow.x - playerBg.width * 0.05;

			var colorswap:ColorSwap = new ColorSwap();
			babyArrow.shader = colorswap.shader;
			colorswap.update(Note.arrowColors[i]);

			if (player == 1)
				playerStrums.add(babyArrow);
			else
				player2Strums.add(babyArrow);
			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}
        try {
            subState.camera = camHUD;
        }catch(e) {}
		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
				resyncVocals();

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if discord_rpc
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition, oldtimestamp);
			#end
		}

		super.closeSubState();
	}

	#if discord_rpc
	override public function onFocus():Void
	{
		if (health > 0 && !paused && FlxG.autoPause)
		{
			DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		if (health > 0 && !paused && FlxG.autoPause)
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);

		super.onFocusLost();
	}
	#end

	function resyncVocals():Void
	{
		if (_exiting)
			return;

		vocals.pause();
		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time ;

		if (vocalsFinished)
			return;

		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;


	public function independementupdate(elapsed:Float)
	{
		callScripts("independementUpdate", [elapsed]);
		if (inCutscene)
			{
				FlxG.sound.music.time = 0;
				FlxG.sound.music.volume = 0;
				Conductor.songPosition = -5000;
				vocals.time = 0;
				vocals.volume = 0;
			}
		FlxG.watch.addQuick("testField",testField);

		cheatsManager.update(elapsed);
	
		boyfriend.cpu = botplay;
	
		if (boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished)
			{
				if (kys)
					boyfriend.startedDeath = true;
			}	
	}
	
	public override function add(object:FlxBasic) {
	return	super.add(object);
	}
	
	override public function update(elapsed:Float)
	{
		accuracy = CoolUtil.calculateAccuracyFrom(hit_data, totalHits);

		if (inCutscene) {
			simulateBeat += elapsed * 1000;
			var oldBeat = beat;
			beat = Math.floor((simulateBeat / Conductor.stepCrochet) / 4);
			FlxG.watch.addQuick("beats", beat);
			if (oldBeat != beat)
				beatHit();
		}
		callScripts("update", [elapsed]);

		independementupdate(elapsed);

		#if !debug
		perfectMode = false;
		#end

		// do this BEFORE super.update() so songPosition is accurate
		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition = FlxG.sound.music.time ; // 20 is THE MILLISECONDS??

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
			}
		}


		super.update(elapsed);
	
	
		scoreTxt.screenCenter(X);

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
			{
				var boyfriendPos = boyfriend.getScreenPosition();
				var pauseSubState = new PauseSubState(boyfriendPos.x, boyfriendPos.y);
				openSubState(pauseSubState);
				pauseSubState.camera = camHUD;
				boyfriendPos.put();
			}

			#if discord_rpc
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());

			#if discord_rpc
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		if (FlxG.keys.justPressed.NINE)
			iconP1.swapOldIcon();

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);
		try { 
			events.sort(sortEvents);

			var event =events[0];
			FlxG.watch.addQuick("event", event);
			if (event != null){
			if (event.time <= Conductor.songPosition) {
				events.remove(events[0]);
				onEvent(event.type, event.data.v1,event.data.v2);
			}
			}
		} catch(e){}
		iconP1.scale.x = FlxMath.lerp(1, iconP1.scale.x, 0.85);
		iconP1.scale.set(iconP1.scale.x,iconP1.scale.x);

		iconP2.scale.x = FlxMath.lerp(1, iconP2.scale.x, 0.85);
		iconP2.scale.set(iconP2.scale.x,iconP2.scale.x);

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 - iconOffset);

		if (health > 2)
			health = 2;
		try {
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;
	}catch(e){}

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		if (FlxG.keys.justPressed.EIGHT)
		{
			if (FlxG.keys.pressed.SHIFT)
				if (FlxG.keys.pressed.CONTROL)
					FlxG.switchState(new AnimationDebug(gf.curCharacter));
				else 
					FlxG.switchState(new AnimationDebug(boyfriend.curCharacter));
			else
				FlxG.switchState(new AnimationDebug(dad.curCharacter));
		}
		if (FlxG.keys.justPressed.PAGEUP || ( FlxG.keys.pressed.ALT && FlxG.keys.justPressed.RIGHT))
			changeSection(1);
		if (FlxG.keys.justPressed.PAGEDOWN || ( FlxG.keys.pressed.ALT && FlxG.keys.justPressed.LEFT))
			changeSection(-1);
		#end

		if (generatedMusic && SONG.sections[curSection] != null)
		{
			cameraRightSide = SONG.sections[curSection].mustHitSection;

		}
		var char = cameraRightSide ? boyfriend : dad;
		#if debug
		if (FlxG.keys.pressed.CONTROL) {
		if (FlxG.keys.pressed.J)
			char.cameraOffsets[0] -= 10;
		if (FlxG.keys.pressed.L)
			char.cameraOffsets[0] += 10;
		if (FlxG.keys.pressed.I)
			char.cameraOffsets[1] -= 10;
		if (FlxG.keys.pressed.K)
			char.cameraOffsets[1] += 10;
		}
		#end
		cameraMovement();

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom * Main.shouldZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(defaultCamHUDZoom * Main.shouldZoom, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

	
	

		if (!inCutscene && !_exiting)
		{
			// RESET = Quick Game Over Screen
			if (controls.RESET)
			{
				health = 0;
				trace("RESET = True");
			}

			#if CAN_CHEAT // brandon's a pussy
			if (controls.CHEAT)
			{
				health += 1;
				trace("User is cheating!");
			}
			#end

			if (health <= 0 && !practiceMode)
			{
				// boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				// unloadAssets();

				deathCounter += 1;

				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if discord_rpc
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
				#end
			}
		}
		unspawnNotes.sort(sortByShit);

		FlxG.watch.addQuick("dunceNote", unspawnNotes[0]);
		curSongPositionData = Conductor.songPosition / FlxG.sound.music.length;

		while (unspawnNotes[0] != null && unspawnNotes[0].strumTime - Conductor.songPosition < 1800 / (SONG.speed * PreferencesMenu.getPref("song-speed")))
		{
			var dunceNote:Note = unspawnNotes[0];

			notes.add(dunceNote);
			unspawnNotes.shift();
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				callScripts("repositionNotes", [daNote]);
				var strumLine:StrumArrow = (daNote.player == 0 ? playerStrums.members : player2Strums.members)[daNote.noteData];
				daNote.strumLine = strumLine;
				@:privateAccess daNote.repositionNote();
				if (daNote.player != 0 && daNote.willHit)
					goodEnemyNoteHit(daNote);
				if (daNote.willHit && daNote.player == 0 && botplay) 
					goodNoteHit(daNote);
				daNote.visible = daNote.active = !(!PreferencesMenu.getPref('downscroll') && daNote.y < -daNote.height)
				|| (PreferencesMenu.getPref('downscroll') && daNote.y > FlxG.height);
				daNote.drawSwagRect= daNote.wasGoodHit|| daNote.prevNote.wasGoodHit || daNote.prevNote.prevNote.wasGoodHit || daNote.prevNote.prevNote.prevNote.wasGoodHit;
				if (daNote.isSustainNote && daNote.wasGoodHit)
				{
					daNote.drawSwagRect=true;
					if ((!PreferencesMenu.getPref('downscroll') && daNote.y < -daNote.height)
						|| (PreferencesMenu.getPref('downscroll') && daNote.y > FlxG.height))
					{
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote,true);
						daNote.destroy();
					}
				}
				else if (daNote.tooLate || daNote.wasGoodHit)
				{
					daNote.drawSwagRect=false;
					if (daNote.tooLate && daNote.player == 0)
						noteMiss(daNote.noteData, false);
					daNote.kill();
					notes.remove(daNote,true);
					daNote.destroy();
				}
			});
        }
			checkNotes();
	}

	function killCombo():Void
	{
		if (combo > 5 && gf.animationOffsets.exists('sad'))
			gf.playAnim('sad');
		if (combo != 0)
		{
			combo = 0;
			displayCombo();
		}
	}

	public function onKeyGetDown(event) {

	}
	#if debug
	function changeSection(sec:Int):Void
	{
		FlxG.sound.music.pause();

		var daBPM:Float = SONG.bpm;
		var daPos:Float = 0;
		for (i in 0...(Std.int(curSection + sec)))
		{
			
			if (SONG.sections != null && SONG.sections[i].changeBPM)
			{
				daBPM = SONG.sections[i].bpm;
			}
			daPos += 4 * (1000 * 60 / daBPM);
		}
		Conductor.songPosition = FlxG.sound.music.time = daPos;
		updateCurStep();
		resyncVocals();
	}
	#end

	function endSong():Void
	{
		callScripts("endSong");
		_songGeneratorActive = false;

		FlxG.sound.music.onComplete  = null;
		seenCutscene = false;
		deathCounter = 0;
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
		}
		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);
			if (storyPlaylist.length <= 0)
			{
			Paths.currentLevel = null;

				Paths.currentMod = "";
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
				FlxG.switchState(new StoryMenuState());

				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(storyPlaylist[0].toLowerCase() + difficulty);

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;

				FlxG.sound.music.stop();
				vocals.stop();
				var diabl = true;
				storyPlaylist[0] = storyPlaylist[0].toLowerCase();
				callScripts("loadingNextSong", storyPlaylist[0],function (disable){
					if (disable)
							diabl = false;
				}, function
					(disable:Bool, esotilin:Bool) {
						
						if (!esotilin)
							prevCamFollow = camFollow;

						SONG = Song.loadFromJson(storyPlaylist[0] + difficulty, storyPlaylist[0]);
						LoadingState.loadAndSwitchState(new PlayState());
					}
				);
			
				if (diabl)
				{
					prevCamFollow = camFollow;
					SONG = Song.loadFromJson(storyPlaylist[0]+ difficulty, storyPlaylist[0]);
					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
		}
		else
		{
			Paths.currentLevel = null;
			Paths.currentMod = "";

			trace('WENT BACK TO FREEPLAY??');
			callScripts("exitState");
			FlxG.switchState(new FreeplayState());
		}
	}

	// gives score and pops up rating
	public var ratingSpr:DecaySprite;
	private function popUpScore(strumtime:Float, dir:Int):Void
	{
		combo += 1;

		callScripts("popUpScore", strumtime, dir, combo);

		var noteDiff:Float = boyfriend.cpu ? 0 : Math.abs(strumtime - (Conductor.songPosition - Conductor.offset));
		if (ratingSpr == null)
			ratingSpr = new DecaySprite(getPref("unique-rating-spr"));
		var score:Int = 350;
	
	    var daRating = CoolUtil.calculateRating(noteDiff);
		totalHits += 1;
		ratingCombo += 1;
		
		score = daRating.score;
		misses += daRating.missAdd;
		    if (lastRating != daRating.daRating)
		    {
			    ratingCombo = 0;
		    }
        

		if (ratingCombo % 10 == 0)
		{
			score += Math.floor(100 * ((ratingCombo / 2) / 10) 	);
		}

		lastRating = daRating.daRating;

		hit_data += score / 350;

		if (daRating.daRating == "sick" && getPref("note-splash"))
		{
			var noteSplash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
			var daNote = playerStrums.members[dir];
			noteSplash.setupNoteSplash(daNote.x, daNote.y, dir);
			// new NoteSplash(daNote.x, daNote.y, daNote.noteData);
			grpNoteSplashes.add(noteSplash);
		}

		// Only add the score if you're not on practice mode
		if (!practiceMode)
			songScore += score;
		if (!getPref("show-rating"))
			return;
		var ratingPath:String = daRating.daRating;

		if (curStage.startsWith('school'))
			ratingPath = "weeb/pixelUI/" + ratingPath + "-pixel";
		ratingSpr.setSprite(Paths.image(ratingPath));
		ratingSpr.appear(40, 60);
		add(ratingSpr);

		displayCombo();
	}
	public var comboSpr:DecaySprite;
	public var numsArray:Array<DecaySprite> = [];
	function displayCombo():Void
	{
		if (!getPref("show-rating"))
			return;
		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}
		if (comboSpr == null)
			comboSpr = new DecaySprite(getPref("unique-rating-spr"));
		comboSpr.setSprite(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.appear(0, -90);

		add(comboSpr);
		var seperatedScore:Array<String> = '$combo'.split("");
	
		seperatedScore.reverse();
		while (seperatedScore.length < 3)
			seperatedScore.push("0");
		FlxG.watch.addQuick("score",seperatedScore);
		for (i in 0...seperatedScore.length)
		{
			var numScore = numsArray[i];
			if (numScore == null)
				numScore =  new DecaySprite(getPref("unique-rating-spr"));

			numScore.setSprite(Paths.image('${pixelShitPart1}num${seperatedScore[i]}$pixelShitPart2'), pixelShitPart1 == "" ? 0.5 : 1.0);

			numScore.updateHitbox();
			numScore.appear((43 * i) + 30,-90);


			numsArray[i] = numScore;
			add(numScore);
		}
	}

	var cameraRightSide:Bool = false;

	function cameraMovement()
	{
		if (!cameraRightSide)
		{
			camFollow.setPosition((dad.getMidpoint().x + 100) + dad.cameraOffsets[0], (dad.getMidpoint().y - 100) + dad.cameraOffsets[1]);

			if (SONG.song.toLowerCase() == 'tutorial')
				tweenCamIn();
		}else
		{
			camFollow.setPosition((boyfriend.getMidpoint().x - 100 )+boyfriend.cameraOffsets[0], (boyfriend.getMidpoint().y - 100) + boyfriend.cameraOffsets[1]);

			if (SONG.song.toLowerCase() == 'tutorial')
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		}
	}

	private function checkNotes():Void
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.NOTE_LEFT, controls.NOTE_DOWN, controls.NOTE_UP, controls.NOTE_RIGHT];

		if (inCutscene || botplay || kys) 
			return;
		if (!holdArray.contains(true) || !generatedMusic)
			return;
		boyfriend.holdTimer = 0;
		var gamepad = FlxG.gamepads.getByID(0);
		if (gamepad != null)
			{
				if (gamepad.justPressed.ANY) {
					for (i in 0...holdArray.length) {
						if (holdArray[i])
							checkNote(i);
					}
				}
			}
		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.isSustainNote && daNote.canBeHit && daNote.player == 0 && holdArray[daNote.noteData])
				goodNoteHit(daNote);
		});
	}

	function noteMiss(direction:Int = 1, wasPressed:Bool = true):Void
	{
		if (kys || botplay)
			return;
		callScripts("noteMiss", direction);
		if(!wasPressed)
		vocals.volume = 0;

		
		misses += 1;
		health -= 0.04;
		killCombo();

		songScore -= 100;
		totalHits += 1;
		hit_data -= .01;

		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));


		boyfriend.playAnim('sing${directions[direction].toUpperCase()}miss', true);
	}
	function noteHitted(daNote:Note, player:Int, char:Character)
	{
		callScripts("noteHitted", daNote, player);
		daNote.wasGoodHit = true;
		daNote.drawSwagRect = true;
		vocals.volume = 1;
		var altAnim:String = "";

		if (daNote.altNote)
			altAnim = '-alt';
		char.holdTimer = 0;
		char.playAnim('sing${directions[daNote.noteData].toUpperCase()}${altAnim}',true);
		playSrumAnim(player, daNote.noteData, char.cpu);

		if (!daNote.isSustainNote)
		{
			daNote.kill();
			notes.remove(daNote,true);
			daNote.destroy();
		}

	}
	function goodEnemyNoteHit(daNote:Note) {

		callScripts("goodEnemyNoteHit", daNote);
		if (SONG.song != 'Tutorial')
			camZooming = true;

		noteHitted(daNote, daNote.player, dad);
	}
	public function playSrumAnim(player:Int, data:Int, cpu:Bool) {
		(player == 0 ? playerStrums : player2Strums).forEach(function(spr:StrumArrow)
			{
				if (data == spr.ID)
					spr.confirm(cpu);
			});
	}
	function goodNoteHit(note:Note):Void
	{
		if (kys || note.wasGoodHit)
			return;
		callScripts("goodNoteHit", note);


		if (!note.isSustainNote)
			popUpScore(note.strumTime, note.noteData);

		health += 0.02;

		noteHitted(note, note.player, boyfriend);
	}
	
	function createSection(section:Section)
	{
		callScripts("createSection", section);

		for (songNotes in section.notes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(Math.abs(songNotes[1]));
				setupNoteBy(daStrumTime, daNoteData, songNotes);
			}
	}
	function setupNoteBy(daStrumTime:Float, daNoteData:Int,  ?songNotes:Array<Dynamic>){
		var susLength:Float = songNotes[2];
		var player = Math.floor((daNoteData) / 4);

		var oldNote:Note = null;
		if (unspawnNotes.length > 0)
			oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

		if ((player != 0)) {
			if (getPref("opponent")) {
				var altAnim = '';
				if (songNotes[3] == "alt")
					altAnim = "-alt";
				pushEvent(daStrumTime, "sing", {v1: "dad", v2: "sing"+ directions[daNoteData % 4].toUpperCase() + altAnim});
				susLength = susLength / Conductor.stepCrochet;
				for(susNote in 0...Math.floor(susLength)) {
					 pushEvent(
						daStrumTime + ((Conductor.stepCrochet )* susNote) + (Conductor.stepCrochet) - (susNote == Math.floor(susLength) ? Conductor.stepCrochet  : 1)
						, "sing", {v1: "dad", v2: "sing"+ directions[daNoteData % 4].toUpperCase()+ altAnim});
				}
			return;
			}
		}
		var swagNote:Note =  new Note();
	
		swagNote.ID = unspawnNotes.length;
		swagNote.prevNote = null;

		swagNote.setupNote(daStrumTime, daNoteData, oldNote);
		swagNote.sustainLength =susLength;
		swagNote.altNote = songNotes[3];
		swagNote.scrollFactor.set(0, 0);
	
		var strumLine:StrumArrow = (swagNote.player == 0 ? playerStrums.members : player2Strums.members)[swagNote.noteData];
		swagNote.strumLine = strumLine;
		var speed = SONG.speed * getPref("song-speed");
		susLength = susLength / Conductor.stepCrochet;
		unspawnNotes.push(swagNote);
		swagNote.player = player;

		callScripts("newNote", swagNote, player, susLength, susLength > 0, false);
		for (susNote in 0...Math.floor(susLength))
		{
			oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

			var sustainNote:Note = new Note();
			sustainNote.setupNote(daStrumTime + ((Conductor.stepCrochet )* susNote) + (Conductor.stepCrochet * 1.5) , daNoteData, oldNote, true);
			sustainNote.scrollFactor.set();
			sustainNote.player = player;
			sustainNote.ID = unspawnNotes.length;
			sustainNote.strumLine = strumLine;
			unspawnNotes.push(sustainNote);
			callScripts("newNote", sustainNote, player, susLength, susLength > 0, true);
		}	
	}



    function pushEvent(time, type:String, data) {
        events.push({time:time,type: type,data:data});
    }
    function onEvent(type:String, value1:String, value2:String) {
		if (inCutscene)
			return;
           switch(type){
				case "volume":
					vocals.volume = 1;
				case 'sing': 
					var char:Character = boyfriend;
					switch(value1){
						case "dad": char = dad;
						case "gf": char = gf;
					}
					vocals.volume = 1;
					char.holdTimer = 0;
                    char.playAnim(value2,true);
                case "play-anim":
                    switch(value1) {
                       case "dad":
							dad.holdTimer = 0;
                         	dad.playAnim(value2,true);
                       case "bf", "boyfriend":
							boyfriend.holdTimer = 0;

                         	boyfriend.playAnim(value2,true);
                       case "gf", "girlfriend":
							gf.holdTimer = 0;
                         	gf.playAnim(value2,true);
                    }
            }
    }
	override function stepHit()
	{
		super.stepHit();
		callScripts("stepHit");

		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition )) > 20
			|| (Math.abs(vocals.time - (Conductor.songPosition )) > 20))
		{
			resyncVocals();
		}

		
	}
	public function setOffsetNote(a:Float = 1) {
		FlxG.sound.music.pitch = .25;
		vocals.pitch = .25;
		Note.offsetYData = a;
	}
	function iconBump(player:Int, ?mult:Float = 1.25) {
		switch(player) {
			case 0:
				iconP1.scale.set(1 * mult,1 * mult);
			case 1:
				iconP2.scale.set(1 * mult,1 * mult);
			case 2:
				//iconP3.scale.set(1 * mult,1 * mult);

		}
		iconP1.updateHitbox();
		iconP2.updateHitbox();
	}



	override function beatHit()
	{
		if (!PreferencesMenu.getPref("camera-zoom"))
			camZooming = false;
		callScripts("beatHit");

		super.beatHit();

		if (generatedMusic && !inCutscene)
		{
			try {
			notes.sort(sortNotes, FlxSort.DESCENDING);
			} catch(e) {}
		}

		if (SONG.sections[Math.floor(curSection)] != null && !inCutscene)
		{
			if (SONG.sections[Math.floor(curSection)].changeBPM)
			{
				Conductor.changeBPM(SONG.sections[Math.floor(curSection)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
		}
	
		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0 && !inCutscene)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}	

        try {
			if (curBeat % gfSpeed ==  0){
				var gfScript = scriptManager.getScript("gf-script");
				var doitAnyThing:Bool  =false;

				if (gfScript != null){
					gfScript.call("onDanceTime", [function skipDance(skip:Bool) {
						doitAnyThing=true;

						if (!skip)
							gf.dance();
					}]);

				}
				if (!doitAnyThing) 
					gf.dance();
			} // REDO
			if (!boyfriend.animation.curAnim.name.startsWith("sing") && !kys && curBeat % boyfriend.danceSpeed == 0)
				boyfriend.dance();
			if (!dad.animation.curAnim.name.startsWith("sing") && curBeat % dad.danceSpeed == 0)
				dad.dance();
        } catch(e){}
		iconBump(0);
		iconBump(1);
	
		foregroundSprites.forEach(function(spr:BGSprite)
		{
			spr.dance();
		});

	}

}
