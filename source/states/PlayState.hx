package states;


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
	public var testField:Int;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var deathCounter:Int = 0;
	public var botplay:Bool = true;
	public static var practiceMode:Bool = false;
	private var simulateBeat:Float = 0;
	private var beat:Int = 0;
	private var vocals:FlxSound;
	private var vocalsFinished:Bool = false;

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

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	public var oldtimestamp:Float;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	
	
	private var directions:Array<String> = ["left", "down", "up", "right"];

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	public static var seenCutscene:Bool = false;
	

	var foregroundSprites:FlxTypedGroup<BGSprite>;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var tankmanRun:FlxTypedGroup<TankmenBG>;
	public var cancelCountDown:Bool = false;
	public var cheatsManager:CheatsManager;

	var kys:Bool = false;
	var forceRating:String = "";

	var talking:Bool = true;
	var songScore:Int = 0;
	var misses:Int = 0;
	var hit_data:Float = 1;
	var ratingCombo:Int = 0;
	var lastRating:String = "sick";
	var totalHits:Int = 1; // FOr better acc?!??!?!? and nan bug ajdlaskdjaslkd
 	var scoreTxt:FlxText;

	var scripts:Array<Script> = [];
	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

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
	var lightFadeShader:BuildingShaders;
    var events:Array<Dynamic> = [];

	override public function create()
	{
		unspawnNotes = [];
		events = [];
		instance = this;
		curStage = SONG.stage;
		curSong = SONG.song.toLowerCase();
		addScript(Paths.getDataPath() + 'songs/${SONG.song.toLowerCase()}/script.hscript', false, "script");
		addScript(Paths.getDataPath() + 'global-script.hscript', false, "global-script");
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


		gf = new Character(400, 130, SONG.player3);
		gf.scrollFactor.set(0.95, 0.95);

		addScript(Paths.getDataPath() + 'characters/${SONG.player1}.hscript', false, 'bf-script', boyfriend);
		addScript(Paths.getDataPath() + 'characters/${SONG.player2}.hscript', false, 'dad-script', dad);
		addScript(Paths.getDataPath() + 'characters/${SONG.player3}.hscript', false, 'gf-script', gf);

		dad = new Character(100, 100, SONG.player2);

		camPos = new FlxPoint(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y);

		if (SONG.player2 == SONG.player3) {
			dad.setPosition(gf.x, gf.y);
			gf.visible = false;
		}
		boyfriend = new Boyfriend(770, 450, SONG.player1);

		callScripts("repositionChars");

		add(gf);
		add(dad);
		add(boyfriend);

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

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 30, 0, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.screenCenter(X);
		add(scoreTxt);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
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
	}
	var scriptsIDS:Int =-1;
	var beforeAdding:Map<FlxObject, FlxObject> = [];
	function ch(i = 1) {
		shader.update(i);
		FlxG.camera.filters = [new ShaderFilter(shader.shader)];

	}
	public function addScript(path:String, ?justOneRun:Bool = false, name:String, ?customPatern:Dynamic)
	{
		trace('founded '+  path);
		if (!sys.FileSystem.exists(path))
			return null;
		var data = sys.io.File.getContent(path).trim().rtrim().replace("\r", "");
		var script = new Script(data);
		script.ID = scriptsIDS+=1;
		script.setVar("addBefore", Reflect.makeVarArgs(function (args) {
			if (args[1] == null)
				return add(args[0]);
			beforeAdding.set(args[1], args[0]);
			return args[0] ;
		}));
		script.name = name;
		script.call("init", ["PlayState", SONG.song, script.ID, customPatern]);
		if (!justOneRun)
			scripts.push(script);
		return script;
	}
	public function scriptAdded(script:Script, ?path:String, ?name:String) {
		callScripts("scriptAdded", script, path, name);

	}
	public function callScripts(fun:String, ...args:Dynamic):Dynamic {
		if (args == null)
			args  = [];
		
		
		var values:Array<Dynamic> = [];
		for (e in scripts)
		{
			values.push({val: e.call(fun, args), name: e.name});
		}
		return values;
	}
	public function getPref(str:String):Dynamic
		return PreferencesMenu.getPref(str);
	public function getScript(IDOrName:Dynamic)
	{
		for (script in scripts) {


		if (IDOrName is String) {
			if (script.name == IDOrName)
				return script;
		} else if (IDOrName is Int){
			if (script.ID == IDOrName)
				return script;
		}
		}
		return null;
	}

	public function playVideo(name:String)
	{

		#if VIDEOS
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
	function updateDiscord():Void {
		
		#if discord_rpc
		if(scoreTxt != null)
		storyDifficultyText = scoreTxt.text + "|"+CoolUtil.difficultyString();
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, Conductor.songPosition -songLength);

		#end
	}
	function initDiscord():Void
	{
		#if discord_rpc
		iconRPC = SONG.player2;

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

		talking = false;
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
	}

	private function generateSong():Void
	{
		// FlxG.log.add(ChartParser.parse());
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(SONG.song));
		else
			vocals = new FlxSound();

		vocals.onComplete = function()
		{
			vocalsFinished = true;
		};
		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		generatedMusic = true;
		createSections(8, curSection);


	}
	override function sectionHit()
	{
		//Thread.create(()->{
		try {
			createSections(4, curSection); // four next sections
		} catch (e) {}
		//});
	}
	var sectionsCreated:Array<Int>=  [];
	function createSections(loops:Int, index:Int)
	{
		var songData = SONG;
		var noteData = songData.notes;
		
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

	private function generateStaticArrows(player:Int):Void
	{
		if (player != 1 && getPref("opponent")) return;
		for (i in 0...4)
		{
			// FlxG.log.add(i);
		
			var babyArrow:StrumArrow = new StrumArrow( strumLine.y, player, i, curStage);
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
		Conductor.songPosition = FlxG.sound.music.time + Conductor.offset;

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
		if (inCutscene) {
			simulateBeat += elapsed * 1000;
			var oldBeat = beat;
			beat = Math.floor((simulateBeat / Conductor.stepCrochet) / 4);
			FlxG.watch.addQuick("beats", beat);
			if (oldBeat != beat)
				beatHit();
		}
		for (key in beforeAdding.keys()) {

			insert(members.indexOf(key) + 1, beforeAdding.get(key));
			beforeAdding.remove(key);	
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
			Conductor.songPosition = FlxG.sound.music.time + Conductor.offset; // 20 is THE MILLISECONDS??

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
		scoreTxt.text = 'Accuracy: ${
			CoolUtil.calculateAccuracyFrom(hit_data, totalHits)
		} | Misses: $misses | Score: $songScore | Combo: ${combo} | Rating Combo: $ratingCombo | :v';
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

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;


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

		if (generatedMusic && SONG.notes[Std.int(curSection)] != null)
		{
			cameraRightSide = SONG.notes[Std.int(curSection)].mustHitSection;

		}
		cameraMovement();

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
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
				var swagNote  = daNote;
				var strumLine:StrumArrow = (daNote.mustPress ? playerStrums.members : player2Strums.members)[daNote.noteData];
				daNote.strumLine = strumLine;
				@:privateAccess daNote.repositionNote();
				daNote.visible = daNote.active = daNote.isOnScreen();
				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					goodEnemyNoteHit(daNote);
			
				}

				if (daNote.strumTime < Conductor.songPosition && daNote.mustPress) 
					{
						if (botplay)
							goodNoteHit(daNote);
					}
				if (daNote.isSustainNote && daNote.wasGoodHit)
				{
					if ((!PreferencesMenu.getPref('downscroll') && daNote.y < -daNote.height)
						|| (PreferencesMenu.getPref('downscroll') && daNote.y > FlxG.height))
					{
						daNote.kill();
						notes.remove(daNote,true);
						daNote.destroy();
					}
				}
				else if (daNote.tooLate || daNote.wasGoodHit)
				{
					if (daNote.tooLate)
						noteMiss(daNote.noteData, false);
					daNote.kill();
					notes.remove(daNote,true);
					daNote.destroy();
				}
			});
        }
		if (!inCutscene && !botplay && !kys) 
			keyShit();
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

	#if debug
	function changeSection(sec:Int):Void
	{
		FlxG.sound.music.pause();

		var daBPM:Float = SONG.bpm;
		var daPos:Float = 0;
		for (i in 0...(Std.int(curSection + sec)))
		{
			if (SONG.notes[i].changeBPM)
			{
				daBPM = SONG.notes[i].bpm;
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
				callScripts("loadingNextSong", storyPlaylist[0].toLowerCase(),function (disable){
					if (disable)
							diabl = false;
				}, function
					(disable:Bool, esotilin:Bool) {
						
						if (!esotilin)
							prevCamFollow = camFollow;

						SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase() + difficulty, storyPlaylist[0]);
						LoadingState.loadAndSwitchState(new PlayState());
					}
				);
			
				if (diabl)
				{
					prevCamFollow = camFollow;
					SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase() + difficulty, storyPlaylist[0]);
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
	private function popUpScore(strumtime:Float, dir:Int):Void
	{
		combo += 1;

		callScripts("popUpScore", strumtime, dir, combo);

		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;
	
	    var daRating = "sick";
		totalHits += 1;
		ratingCombo += 1;
		
		if (forceRating != "sick"){
		    if (forceRating == "shit"||noteDiff > Conductor.safeZoneOffset * 0.9)
		    {
			    daRating = 'shit';
			    score = 50;
			    misses += 1;
		    }
		    else if (forceRating == "bad" || noteDiff > Conductor.safeZoneOffset * 0.75 )
		    {
			    daRating = 'bad';
			    score = 100;
		    }
		    else if (noteDiff > Conductor.safeZoneOffset * 0.2 || forceRating == "good")
		    {
			    daRating = 'good';
			    score = 200;
		    }
		   }
		    if (lastRating != daRating)
		    {
			    ratingCombo = 0;
		    }
        

		if (ratingCombo % 10 == 0)
		{
			score += Math.floor(100 * ((ratingCombo / 2) / 10) 	);
		}

		lastRating = daRating;

		hit_data += score / 350;

		if (daRating == "sick")
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

	

		var ratingPath:String = daRating;

		if (curStage.startsWith('school'))
			ratingPath = "weeb/pixelUI/" + ratingPath + "-pixel";

		rating.loadGraphic(Paths.image(ratingPath));
		rating.x = FlxG.width * 0.55 - 40;
		// make sure rating is visible lol!
		if (rating.x < FlxG.camera.scroll.x)
			rating.x = FlxG.camera.scroll.x;
		else if (rating.x > FlxG.camera.scroll.x + FlxG.camera.width - rating.width)
			rating.x = FlxG.camera.scroll.x + FlxG.camera.width - rating.width;

		rating.y = FlxG.camera.scroll.y + FlxG.camera.height * 0.4 - 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		add(rating);

		if (curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
		}
		rating.updateHitbox();

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
		displayCombo();
	}

	function displayCombo():Void
	{
		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.y = FlxG.camera.scroll.y + FlxG.camera.height * 0.4 + 80;
		comboSpr.x = FlxG.width * 0.55;
		// make sure combo is visible lol!
		// 194 fits 4 combo digits
		if (comboSpr.x < FlxG.camera.scroll.x + 194)
			comboSpr.x = FlxG.camera.scroll.x + 194;
		else if (comboSpr.x > FlxG.camera.scroll.x + FlxG.camera.width - comboSpr.width)
			comboSpr.x = FlxG.camera.scroll.x + FlxG.camera.width - comboSpr.width;

		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.velocity.x += FlxG.random.int(1, 10);

		add(comboSpr);

		if (curStage.startsWith('school'))
		{
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}
		else
		{
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		comboSpr.updateHitbox();

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				comboSpr.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		var seperatedScore:Array<Int> = [];
		var tempCombo:Int = combo;

		while (tempCombo != 0)
		{
			seperatedScore.push(tempCombo % 10);
			tempCombo = Std.int(tempCombo / 10);
		}
		while (seperatedScore.length < 3)
			seperatedScore.push(0);

		// seperatedScore.reverse();

		var daLoop:Int = 1;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.y = comboSpr.y;

			if (curStage.startsWith('school'))
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			else
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			numScore.updateHitbox();

			numScore.x = comboSpr.x - (43 * daLoop); //- 90;
			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
	}

	var cameraRightSide:Bool = false;

	function cameraMovement()
	{
		if (!cameraRightSide)
		{
			camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

			switch (dad.curCharacter)
			{
				case 'mom':
					camFollow.y = dad.getMidpoint().y;
				case 'senpai' | 'senpai-angry':
					camFollow.y = dad.getMidpoint().y - 430;
					camFollow.x = dad.getMidpoint().x - 100;
			}

			if (dad.curCharacter == 'mom')
				vocals.volume = 1;

			if (SONG.song.toLowerCase() == 'tutorial')
				tweenCamIn();
		}else
		{
			camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

			switch (curStage)
			{
				case 'limo':
					camFollow.x = boyfriend.getMidpoint().x - 300;
				case 'mall':
					camFollow.y = boyfriend.getMidpoint().y - 200;
				case 'school' | 'schoolEvil':
					camFollow.x = boyfriend.getMidpoint().x - 200;
					camFollow.y = boyfriend.getMidpoint().y - 200;
			}

			if (SONG.song.toLowerCase() == 'tutorial')
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		}
	}

	private function keyShit():Void
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.NOTE_LEFT, controls.NOTE_DOWN, controls.NOTE_UP, controls.NOTE_RIGHT];
		var pressArray:Array<Bool> = [
			controls.NOTE_LEFT_P,
			controls.NOTE_DOWN_P,
			controls.NOTE_UP_P,
			controls.NOTE_RIGHT_P
		];
		var releaseArray:Array<Bool> = [
			controls.NOTE_LEFT_R,
			controls.NOTE_DOWN_R,
			controls.NOTE_UP_R,
			controls.NOTE_RIGHT_R
		];

		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
					goodNoteHit(daNote);
			});
		}

		// PRESSES, check for note hits
		if (pressArray.contains(true) && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = []; // notes that can be hit
			var directionList:Array<Int> = []; // directions that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (directionList.contains(daNote.noteData))
					{
						for (coolNote in possibleNotes)
						{
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
							{ // if it's the same note twice at < 10ms distance, just delete it
								// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
								dumbNotes.push(daNote);
								break;
							}
							else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
							{ // if daNote is earlier than existing note (coolNote), replace
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});

			for (note in dumbNotes)
			{
				FlxG.log.add("killing dumb ass note at " + note.strumTime);
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			if (perfectMode)
				goodNoteHit(possibleNotes[0]);
			else if (possibleNotes.length > 0)
			{
				for (shit in 0...pressArray.length)
				{ // if a direction is hit that shouldn't be
					if (pressArray[shit] && !directionList.contains(shit))
						noteMiss(shit);
				}
				for (coolNote in possibleNotes)
				{
					if (pressArray[coolNote.noteData])
						goodNoteHit(coolNote);
				}
			}
			else
			{
				for (shit in 0...pressArray.length)
					if (pressArray[shit])
						noteMiss(shit);
			}
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !holdArray.contains(true))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				if (!kys)
				boyfriend.playAnim('idle');
			}
		}	

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
				spr.animation.play('pressed');
			if (!holdArray[spr.ID])
				spr.animation.play('static');
		});
	}

	function noteMiss(direction:Int = 1, wasPressed:Bool = true):Void
	{
		if (forceRating != "")
			popUpScore(0, direction);
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
	function goodEnemyNoteHit(daNote:Note) {
		callScripts("noteHitted", daNote, daNote.mustPress);

		callScripts("goodEnemyNoteHit", daNote);
		if (SONG.song != 'Tutorial')
			camZooming = true;

		var altAnim:String = "";

		if (SONG.notes[Math.floor(curSection)] != null)
		{
			if (SONG.notes[Math.floor(curSection)].altAnim)
				altAnim = '-alt';
		}

		if (daNote.altNote)
			altAnim = '-alt';

		dad.playAnim('sing${directions[daNote.noteData].toUpperCase()}${altAnim}', true);
		//if (getPref("player-hit-icon-bump"))
			iconBump(1, 1.3);
		dad.holdTimer = 0;

		if (SONG.needsVoices)
			vocals.volume = 1;

		daNote.kill();
		notes.remove(daNote,true);
		daNote.destroy();
		player2Strums.forEach(function(spr:StrumArrow)
			{
				if (Math.abs(daNote.noteData) == spr.ID)
					spr.confirm(dad.cpu);
			});
	}
	function goodNoteHit(note:Note):Void
	{

		if (kys || note.wasGoodHit)
			return;
		callScripts("noteHitted", note, note.mustPress);

		callScripts("goodNoteHit", note);

		vocals.volume =  1;

		boyfriend.holdTimer = 0;

		if (!note.isSustainNote)
			popUpScore(note.strumTime, note.noteData);

		health += 0.02;
		//if (getPref("player-hit-icon-bump"))
			iconBump(0, 1.3);

		boyfriend.playAnim('sing${directions[note.noteData].toUpperCase()}', true);

		playerStrums.forEach(function(spr:StrumArrow)
		{
			if (Math.abs(note.noteData) == spr.ID)
				spr.confirm(boyfriend.cpu);
		});

		note.wasGoodHit = true;

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
		updateDiscord();
	}

	

	function createSection(section:SwagSection)
	{
		callScripts("createSection", section);

		for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(Math.abs(songNotes[1]) % 4);
				var gottaHitNote:Bool = section.mustHitSection;
				if (songNotes[1] > 3)
					gottaHitNote = !section.mustHitSection;
				var oldNote:Note = null;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

				
				setupNoteBy(daStrumTime, daNoteData,  songNotes[2],gottaHitNote, oldNote, songNotes, section.altAnim);
			}
	}
	function setupNoteBy(daStrumTime:Float, daNoteData:Int, susLength:Float, gottaHitNote:Bool, oldNote:Note, ?songNotes:Array<Dynamic>, ?altSec = false){
		susLength = songNotes[2];
		trace(susLength);
		if (!gottaHitNote) {
			if (getPref("opponent")) {
				pushEvent(daStrumTime, "volume", {v1: "1", v2:"1"});
				var altAnim = '';
				if ( songNotes[3] || altSec)
					altAnim = "-alt";
				pushEvent(daStrumTime, "play-anim", {v1: "dad", v2: "sing"+ directions[daNoteData].toUpperCase() + altAnim});
				susLength = susLength / Conductor.stepCrochet;
				for(susNote in 0...Math.floor(susLength)) {
					pushEvent(daStrumTime, "volume", {v1: "1", v2:"1"});

					 pushEvent(daStrumTime, "play-anim", {v1: "dad", v2: "sing"+ directions[daNoteData].toUpperCase()+ altAnim});
				}
			return;
			}
		}
		var swagNote:Note =  new Note();
		trace(daStrumTime);
		swagNote.ID = unspawnNotes.length;
		swagNote.prevNote = null;

		swagNote.setupNote(daStrumTime, daNoteData, oldNote);
		swagNote.sustainLength =susLength;
		swagNote.altNote = songNotes[3];
		swagNote.scrollFactor.set(0, 0);
		trace(susLength);
		var strumLine:StrumArrow = (swagNote.mustPress ? playerStrums.members : player2Strums.members)[swagNote.noteData];
		swagNote.strumLine = strumLine;
		var speed = SONG.speed * getPref("song-speed");

		susLength = susLength / Conductor.stepCrochet;
		unspawnNotes.push(swagNote);
		swagNote.mustPress = gottaHitNote;
		callScripts("newNote", swagNote,gottaHitNote, susLength, susLength > 0, false);
		if (susLength != 0)
			susLength += 1;
		for (susNote in 0...Math.floor(susLength))
		{
			oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

			var sustainNote:Note = new Note();
			sustainNote.setupNote(daStrumTime + ((Conductor.stepCrochet )* susNote) + (Conductor.stepCrochet) - (susNote == Math.floor(susLength) ? Conductor.stepCrochet  : 1), daNoteData, oldNote, true);
			sustainNote.scrollFactor.set();
			sustainNote.ID = unspawnNotes.length;
			sustainNote.strumLine = strumLine;
			
			
			unspawnNotes.push(sustainNote);
			callScripts("newNote", sustainNote, gottaHitNote, susLength, susLength > 0, true);

			sustainNote.mustPress = swagNote.mustPress ;
		}	
	}



    function pushEvent(time, type:String, data) {
        events.push({time:time,type: type,data:data});
    }
    function onEvent(type:String, value1:String, value2:String) {
			trace("New event " + type + "-" + value1 + "-" + value2 );
           switch(type){
				case "volume":
					vocals.volume = 1;
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
                       case "player2Strums", "enemyStrums":
                                var val = Std.parseInt(value2);
                                if (Math.isNaN(Math.abs(val)))
                                        return;
                            	player2Strums.forEach(function(spr:StrumArrow)
			                    {
				                    if (Math.abs(spr.ID) == Math.abs(val))
					                    spr.confirm(dad.cpu);
			                    });
                    }
            }
    }
	override function stepHit()
	{
		super.stepHit();
		callScripts("stepHit");

		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20))
		{
			resyncVocals();
		}

		
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

		if (SONG.notes[Math.floor(curSection)] != null && !inCutscene)
		{
			if (SONG.notes[Math.floor(curSection)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curSection)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
		}
	
		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0 && !inCutscene)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}	

        try {
		if (curBeat % gfSpeed == 0)
			gf.dance();
		if (!boyfriend.animation.curAnim.name.startsWith("sing") &&!kys&& curBeat % boyfriend.danceSpeed == 0)
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
