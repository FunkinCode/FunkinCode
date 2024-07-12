package sprites;

import sys.FileSystem;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxSort;
import haxe.io.Path;

using StringTools;

typedef CharFile = {

	var image:String;
	var icon:String;
	var animations:Array<Animation>;
	var scale:Array<Float>;
	var color:Array<Int>;
	var danceSpeed:Int;
	var cameraOffsets:Array<Float>;
	var healthColor:Array<Int>;

	var position:Array<Float>;
	var flipX:Bool;
	var antialiasing:Bool;
	var flipY:Bool;

}
typedef Animation = {
	var name:String;
	var prefix:String;
	var FPS:Float;
	var nextAnimation:String;
	var indices:Array<Int>;
	var loop:Bool;
	var offsets:Array<Float>;
	var animationLength:Float; // For sing animations
}

class Character extends SpriteBase
{
	public var debugMode:Bool = false;
	public var cpu:Bool = false;
	public var cameraOffsets:Array<Float> = [0,0];
	public var danceSpeed:Int = 2;
	public var startedDeath:Bool = false;
	public var icon:String;
	public var healthColor:Array<Int> =[];
	public var useDance:Bool = false;
	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var holdTimer:Float = 0;
	public var position:Array<Float> =[0,0];
	public var animationNotes:Array<Dynamic> = [];
	public var charFile:CharFile;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);
		

		curCharacter = character;
		this.isPlayer = isPlayer;
		this.cpu = !isPlayer;
		healthColor = [255,255,255];

		var tex:FlxAtlasFrames;
		antialiasing = true;
		icon = curCharacter;
		var charfile = Paths.text(Paths.getDataPath() + 'characters/$character.json', "");
		tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
		frames = tex;
		quickAnimAdd('idle', 'Dad idle dance');
		quickAnimAdd('singUP', 'Dad Sing Note UP');
		quickAnimAdd('singRIGHT', 'Dad Sing Note RIGHT');
		quickAnimAdd('singDOWN', 'Dad Sing Note DOWN');
		quickAnimAdd('singLEFT', 'Dad Sing Note LEFT');

		if (charfile.length> 0){

			charFile = cast Json.parse(charfile);
			var isXML = true;
			if (charFile.cameraOffsets != null)
				this.cameraOffsets= charFile.cameraOffsets;
			if (FileSystem.exists(Paths.file('images/${charFile.image}.txt')))
				isXML = false;
			if (charFile.scale == null)
				charFile.scale = [1,1];
			if (charFile.position == null || charFile.position.length < 1)
				charFile.position = [0,0];
			trace(charFile.image);
			@:privateAccess trace("./"+Paths.getPath("images/" + charFile.image , IMAGE, "") + ".");
			frames = isXML ? Paths.getSparrowAtlas(charFile.image) : Paths.getPackerAtlas(charFile.image);
			for (i in 0...2)
				if (Math.isNaN(charFile.scale[i]) || charFile.scale[i] <= 0)
					charFile.scale[i] = 1;
			for (anim in charFile.animations) {
				try {
				if (anim.indices.length > 0)
					{
						animation.addByIndices(
							anim.name,
							anim.prefix,
							anim.indices,
							'',
							anim.FPS,
							anim.loop
						);
					} else {
						animation.addByPrefix(
							anim.name,
							anim.prefix,
							anim.FPS,
							anim.loop
						);
					}
				} catch (e) {
					trace('I have a trouble with ' + anim.name + ' and i am ' + curCharacter );
					animation.addByPrefix(
						anim.name,
						anim.prefix,
						anim.FPS,
						anim.loop
					);
				}
				position = charFile.position;
				for (i in 0...2) {
					if (Math.isNaN(anim.offsets[i]))
						anim.offsets[i] = 0;
				}
				setOffset(anim.name, anim.offsets[0],anim.offsets[1]);
				
			}
			icon = charFile.icon;
			healthColor = charFile.healthColor;
			trace(charFile.scale);
			scale.set(charFile.scale[0],charFile.scale[1]);
			if (scale.x <= 0)
				scale.x = 1;
			if (scale.y <= 0)
				scale.y = 1;
			flipX = charFile.flipX;
			flipY = charFile.flipY;
			danceSpeed = charFile.danceSpeed;
			antialiasing = charFile.antialiasing;
			useDance = animation.exists("danceLeft") || animation.exists("danceRight");

			dance();

			animation.finish();
		}
		loadOffsetFile(curCharacter);

	
		if (isPlayer)
			flipX = !flipX; // When eres niz:
		updateHitbox();
		dance();
		animation.finish();
	}

	function sortAnims(val1:Array<Dynamic>, val2:Array<Dynamic>):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, val1[0], val2[0]);
	}

	function quickAnimAdd(name:String, prefix:String)
	{
		animation.addByPrefix(name, prefix, 24, false);
	}

	private function loadOffsetFile(offsetCharacter:String)
	{
		try {
		var daFile:Array<String> = CoolUtil.splitCoolText(Paths.text("images/characters/" + offsetCharacter + "Offsets.txt","shared"));

		for (i in daFile)
		{
			var splitWords:Array<String> = i.split(" ");
			setOffset(splitWords[0], Std.parseInt(splitWords[1]), Std.parseInt(splitWords[2]));
		}}catch(e) {}
	}
	function checkNextAnimation() {
		if (debugMode)
			return;
		if (animation.curAnim.name.startsWith('sing'))
			holdTimer += FlxG.elapsed;
		else
			holdTimer = 0;
	
			var dadVar:Float = 4;
			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished && startedDeath)
			playAnim('deathLoop');
		
		if (animationNotes.length > 0)
			{
				if (Conductor.songPosition > animationNotes[0][0])
				{

					var shootAnim:Int = FlxG.random.int(1, 2);

					if (animationNotes[0][1] >= 2)
						shootAnim = 3;

					playAnim('shoot' + shootAnim, true);
					animationNotes.shift();
				}
			}
	}
	override function update(elapsed:Float)
	{
		try {
			checkNextAnimation();
		}catch(e){};
		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance():Void
	{
		danced = !danced;
		if (debugMode) 
			return;


		try {

		switch (curCharacter)
		{
			
			case 'pico-speaker':
			case 'tankman':
				if (!animation.curAnim.name.endsWith('DOWN-alt'))
					playAnim('idle');
			default:
				if (useDance)
					{
					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
					} 
					else {
						playAnim('idle');
					}
		}} catch(e) {} 
	}

}
