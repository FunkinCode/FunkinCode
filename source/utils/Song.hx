package utils;

import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef OldSwagSong = {
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

typedef SwagSong =
{
	var version:String;
	var song:String;
	var sections:Array<Section>;
	var events:Array<Dynamic>;
	var bpm:Float;
	var speed:Float;

	var players:Array<String>;
	var validScore:Bool;
	var stage:String;
}

class Song
{
	public static function importOldFormat(song:OldSwagSong):SwagSong {
		var oldSong= {
			version: "1",
			song: song.song,
			sections: [],
			bpm: song.bpm,
			events: [],
			players: [song.player1,song.player2,song.player3],
		
			stage: song.stage,
			speed: song.speed,
			validScore: true
		};

		for (section in song.notes) {
			var sec:Section = {
				notes: [],
				bpm: section.bpm,
				mustHitSection: section.mustHitSection,
				changeBPM: section.changeBPM,
			}
			for (notes in section.sectionNotes) {
			var mustPress = section.mustHitSection;

				var type = "default";
				if (section.altAnim)
					type = "alt";
				if (notes[1] > 3)
					mustPress = !mustPress;
				var e = Math.abs(notes[1] % 4);
				if (!mustPress)
					e += 4;

				sec.notes.push([notes[0],e,notes[2],type]);
			}
			oldSong.sections.push(sec);
		}
		return oldSong;
	}
	public static var defaultSong:SwagSong = {
		version: "1",
		song: 'Test',
		sections: [],
		bpm: 150,
		events: [],
		players: ['bf',"dad","gf"],
	
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
				return loadFromJson("tutorial", "tutorial");

			return parseJSONshit(rawJson);
		}
		return defaultSong;
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		if (swagShit.version == null){
			swagShit = importOldFormat(cast swagShit);
		}
		swagShit.validScore = true;
		return swagShit;
	}
}
