package sprites;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import shaderslmfao.ColorSwap;
import ui.PreferencesMenu;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var strumLine:StrumArrow;
	public var prevNote:Note;

	private var willMiss:Bool = false;

	public var altNote:Bool = false;
	public var invisNote:Bool = false;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var colorSwap:ColorSwap;
	public var playing:Bool = false;
	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public var isEndNote:Bool = false;
	var isPixel = false;
	public static var arrowColors:Array<Float> = [1, 1, 1, 1];

	public function new()
		{
		super();
		


		}
	public function setupNote(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		x = 0; // reset pos
		y = 0; // reset pos

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		var daStage:String = PlayState.curStage;

		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				isPixel = true;

				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			default:
				frames = Paths.getSparrowAtlas('NOTE_assets');

				animation.addByPrefix('greenScroll', 'green instance');
				animation.addByPrefix('redScroll', 'red instance');
				animation.addByPrefix('blueScroll', 'blue instance');
				animation.addByPrefix('purpleScroll', 'purple instance');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;

				// colorSwap.colorToReplace = 0xFFF9393F;
				// colorSwap.newColor = 0xFF00FF00;

				// color = FlxG.random.color();
				// color.saturation *= 4;
				// replaceColor(0xFFC1C1C1, FlxColor.RED);
		}


		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		anim();


	}
	public function anim() {
		angle = 0;
		scale.set(.7,.7);

		if (isPixel)
			scale.set(6,6);

		updateColors();
		var dirs =["purple", "blue", "green", "red"];

		if (!isSustainNote)
			animation.play('${dirs[noteData]}Scroll');

		if (isSustainNote && prevNote != null)
		{
			noteScore *= 0.2;
			alpha = 0.6;

			animation.play('${dirs[noteData]}holdend');
			updateHitbox();
			if (prevNote.isSustainNote)
			{
				prevNote.animation.play('${dirs[noteData]}hold');
				var speed = PlayState.SONG.speed * PreferencesMenu.getPref("song-speed");
				prevNote.scale.y *= (Conductor.stepCrochet ) / 100 * 1.5 * speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}
	public override function toString() {
		return '(time: $strumTime | x: $x y $y | data: $noteData | ID: $ID)';
	}
	public function updateColors():Void
	{
		colorSwap.update(arrowColors[noteData]);
	}
	function repositionNote() {
		if (strumLine == null)
			return;
		var strumLineMid = strumLine.y + Note.swagWidth / 2;
		x = strumLine.x;
	
		angle = 0;
		alpha = strumLine.alpha;
		if (isSustainNote)
			{
			if (PreferencesMenu.getPref('downscroll'))
				angle = 180;
			x +=Note.swagWidth / 2;
			x -= width / 2;
			alpha *= .75;

			}
		angle += strumLine.angle;

		if (PreferencesMenu.getPref('downscroll'))
		{
			y = (strumLine.y + (Conductor.songPosition - strumTime) * (0.45 * FlxMath.roundDecimal((PlayState.SONG.speed * PreferencesMenu.getPref("song-speed")), 2)));

			if (isSustainNote)
			{
				if (animation.curAnim.name.endsWith("end") && prevNote != null)
					y += prevNote.height * 1.25;
				else
					y += height / 2;

				if ((!mustPress || (wasGoodHit || (prevNote.wasGoodHit )))
					&& y - offset.y * scale.y + height >= strumLineMid)
				{
					var swagRect:FlxRect = new FlxRect(0, 0, frameWidth, frameHeight);

					swagRect.height = (strumLineMid - y) / scale.y;
					swagRect.y = frameHeight - swagRect.height;
					clipRect = swagRect;
				}
			}
		}
		else
		{
			y = (strumLine.y - (Conductor.songPosition - strumTime) * (0.45 * FlxMath.roundDecimal((PlayState.SONG.speed * PreferencesMenu.getPref("song-speed")), 2)));

			if (isSustainNote
				&& (!mustPress || (wasGoodHit || (prevNote.wasGoodHit )))
				&& y + offset.y * scale.y <= strumLineMid)
			{
				var swagRect:FlxRect = new FlxRect(0, 0, width / scale.x, height / scale.y);

				swagRect.y = (strumLineMid - y) / scale.y;
				swagRect.height -= swagRect.y;
				clipRect = swagRect;
			}
		}

	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		repositionNote();
		if (mustPress)
		{
			// miss on the NEXT frame so lag doesnt make u miss notes
			if (willMiss && !wasGoodHit)
			{
				tooLate = true;
				canBeHit = false;
			}
			else
			{
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset)
				{ // The * 0.5 is so that it's easier to hit them too late, instead of too early
					if (strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
						canBeHit = true;
				}
				else
				{
					canBeHit = true;
					willMiss = true;
				}
			}
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
