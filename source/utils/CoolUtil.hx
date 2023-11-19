package utils;


import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import haxe.Json;
import lime.math.Rectangle;
import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];
	public static function recomendFPS() {
		for(key in Sys.environment().keys()){
			trace(key);
		}
	}
	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}
	public static function calculateAccuracyFrom(min:Float, max:Float, ?decimals:Bool = true) {
		var acc = FlxMath.roundDecimal(
			(min / max) * 100
		,2);
		if (acc < 0)
			acc = 0;
		if (decimals ){
			var a = Std.string(acc).split(".");
			if (a[1] == null)
				a[1] = ""; // no decimals?
			for (i in 0...((2 - a[1].length) )) {
				a[1 ] += "0";
			}
			return a.join(".") + "%";

		} else {
			acc = Math.floor(acc);
			return Std.string(acc) + "%";
		}
			
		return "??.??%";
	}
	public static function splitCoolText(text:String):Array<String>
	{
		var daList:Array<String> = text.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}
		return daList;

	}
	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	/**
		Lerps camera, but accountsfor framerate shit?
		Right now it's simply for use to change the followLerp variable of a camera during update
		TODO LATER MAYBE:
			Actually make and modify the scroll and lerp shit in it's own function
			instead of solely relying on changing the lerp on the fly
	 */
	public static function camLerpShit(lerp:Float):Float
	{
		return lerp * (FlxG.elapsed / (1 / 60));
	}

	/*
	* just lerp that does camLerpShit for u so u dont have to do it every time
	*/
	public static function coolLerp(a:Float, b:Float, ratio:Float):Float
	{
		return FlxMath.lerp(a, b, camLerpShit(ratio));
	}
}