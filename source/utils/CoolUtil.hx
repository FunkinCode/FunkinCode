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
import sys.io.Process;
using StringTools;
typedef RatingData = {
	var daRating:String;
	var canFC:Bool;
	var score:Int;
	var missAdd:Int;

}
class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];
	public static var ram:SwagRam; 
	/**
	 * How dis work?
	 * - the ram result is a multiply of the 30*maxram, becuz, yea
	 * 
	 * - skips the first 4gb to better load
	 * **/
	public static function recomendFPS() {
		#if windows return 60.0; #end
		ram = getRam(); // rarasldkas
		var result:Float = 30.0;
		var i =  0;
		do {
			result *= 1.5;
			i ++;
		} while(i <= ((ram.gb - 4) / 2) ); // Using for is better, but i need floats
		info('Max rams result: ${result}');
		return result;
	}
	public static function getRam():SwagRam {
		if (ram != null) return ram;
		#if linux
		var result = runCommand("free").split("\n");
		var memLine = result[1].substring("mem:".length,result[1].length ).trim().split(" ").shift(); // 
		ram = new SwagRam(Std.parseFloat(memLine));
		#elseif windows 
		ram = new SwagRam(8 * 1024);
		#end
		return ram;
	}
	public static function runCommand(cmd, ...args) {
		var process = new Process(cmd, []);
		var r=process.stdout.readAll().toString();
		trace(r);
		process.exitCode();
		process.kill();
		return r;
		  /*var process = Process    
		  // Leer la salida del proceso
		  var output = process.input.readAll().toString();*/
	}
	public static var ratingsData:Map<String, RatingData> = [];
	public static function addRatingData(name:String, score:Int, mult:Float, ?missAdd:Int = 0, ?canFC:Bool = true) {
		ratingsData.set('$mult',{
			daRating: name,
			score: score,
			canFC: canFC,
			missAdd: missAdd,
			
		});
	}
	public static function checkRatings() {
		addRatingData("shit", 50, 0.9, 1,false);
		addRatingData("bad", 100, 0.75, 0,true);
		addRatingData("good", 150, 0.5, 0,true);
		addRatingData("good", 200, 0.2, 0,true);
	}
	public static function calculateRating(strumTime:Float) {
		var result:RatingData = {
			daRating: "sick",
			canFC: true,
			score: 350,
			missAdd: 0,
		}
		checkRatings();
		for(mult => data in ratingsData) {
			if (strumTime > Conductor.safeZoneOffset * Std.parseFloat(mult)) {
				result = data;
				break;
			}
		}
		return result;
	}
	public static function resolveKey(key:FlxKey) {
		try {
		var save = FlxG.save.data.controls.p1.keys; // Thank you ninja muffin
		var cotrnls:Array<Array<Int>> = [];

		for (control in [NOTE_LEFT, NOTE_DOWN, NOTE_UP, NOTE_RIGHT])
			{
				var inputs:Array<Int> = Reflect.field(save, control.getName());
				cotrnls.push(inputs);
			}	
		for (i in 0...cotrnls.length )
		{
			for (keySave in cotrnls[i]) 
				if (keySave == key)
					return i;
		}
		} catch(e){
			FlxG.log.error(e);
		}
		return -1;
	}
	public static function fixDir(base:String):String {
		var r = new EReg('[\\/:*¿?!¡"<>| ]', 'g');
		var result = r.replace(base.trim(), '-');	
		return result;
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