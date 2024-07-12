package sprites;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

using StringTools;

/**
 * Loosley based on FlxTypeText lolol
 */
class Alphabet extends FlxSpriteGroup
{
	public var delay:Float = 0.05;
	public var paused:Bool = false;

	// for menu shit
	public var targetY:Float = 0;
	public var isMenuItem:Bool = false;

	private var atlasText:AtlasText;
	public var text:String = "";

	var _finalText:String = "";

	public var widthOfWords:Float = FlxG.width;

	var yMulti:Float = 1;

	var xPosResetted:Bool = false;
	var lastWasSpace:Bool = false;

	var splitWords:Array<String> = [];

	public var typed:Bool;
	private var _curText:String;

	public function new(x:Float = 0.0, y:Float = 0.0, text:String = "", ?bold:Bool = false, typed:Bool = false)
	{
		super(x, y);
			atlasText = new AtlasText(0,0, text, bold ? Bold : Default);
		add(atlasText);
		_finalText = text;
		this.text = text;
		this.typed = typed;

		if (text != "")
		{
			if (typed)
				startTypedText();
			else
				_curText = text;

		}

	}
	override function updateHitbox() {
		super.updateHitbox();
		width = _curText.length * atlasText.maxWidth;
	}

	function doSplitWords():Void
	{
		splitWords = _finalText.split("");
	}

	public var personTalking:String = 'gf';

	public function startTypedText():Void
	{
		_finalText = text;
		_curText = "";
		doSplitWords();
		new FlxTimer().start(0.05, function(tmr:FlxTimer)
		{
			_curText +=splitWords.shift();
			var daSound:String = "GF_";
			FlxG.sound.play(Paths.soundRandom(daSound, 1, 4));

		}, splitWords.length);
	}
	private function changeText(text:String) {
		if (_curText == atlasText.text)
			return;
		atlasText.text = _curText;
		updateHitbox();

	}
	override function update(elapsed:Float)
	{
		if (!typed) {
			_curText = text;
		} else {
			if (_finalText != text) {
				startTypedText();
			}
		}
		
		changeText("");
		if (isMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

			y = CoolUtil.coolLerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
			x = CoolUtil.coolLerp(x, (targetY * 20) + 90, 0.16);
		}

		super.update(elapsed);
	}
}