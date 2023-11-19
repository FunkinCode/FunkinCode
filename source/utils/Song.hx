package utils;

import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var player3:String;
	var validScore:Bool;
	var ?stage:String;
}

class Song
{
	public static var defaultSong:SwagSong = {
		song: 'Test',
		notes: [],
		bpm: 150,
		needsVoices: true,
		player1: 'bf',
		player2: 'dad',
		player3: "gf",
		stage: "stage",
		speed: 1,
		validScore: false
	};
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String = ""):SwagSong
	{
		var path = 	Paths.getDataPath() + "songs/" + Paths.formatToSong(folder, jsonInput) + ".json";
		trace(path);
		if (Paths.exists(path, TEXT))
		{
			var rawJson = Paths.text(path, "").trim();
			trace(path);
			if (rawJson == "")
				return loadFromJson("test", "test");

			return parseJSONshit(rawJson);
		}
		return defaultSong;
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
