package utils;

import sys.thread.Thread;
import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;
	public static var currentMod = '';
	public static var currentLevel:String;

	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var debug_file_getter:Array<String> = [];
	public static var grabbedFiles:Array<String> = [];
	public static var dontDeleteMePlease:Array<String> = [
		"assets/images/alphabet.png",
		"assets/images/fonts/bold.png",
		"assets/images/fonts/default.png",
		'assets/shared/music/breakfast.$SOUND_EXT',
		'assets/music/shared/gameOver.$SOUND_EXT',
		'assets/music/freakyMenu.$SOUND_EXT',
		'assets/sounds/scrollMenu.$SOUND_EXT',
		'assets/sounds/confirmMenu.$SOUND_EXT'
	];
	public static function removeGraphicCache(graphic:FlxGraphic, ?key:String, destroy:Bool = true) {
		if (graphic == null 
			|| graphic == TitleState.diamond
			|| dontDeleteMePlease.contains(key) 
			|| !grabbedFiles.contains(key)  
			|| !currentTrackedAssets.exists(key) 
			)
			return;
		trace(key);
		trace(graphic != null);
	
		@:privateAccess FlxG.bitmap._cache.remove(key);
		currentTrackedAssets.remove(key);

		openfl.Assets.cache.removeBitmapData(key);
		grabbedFiles.remove(key);
		if (!destroy)
			return;
		graphic.persist = false; 
		graphic.destroyOnNoUse = true;
		graphic.destroy();
	}
	public static function removeSoundCache(key:String) {
		if (key == null 
			|| dontDeleteMePlease.contains(key) 
			|| !grabbedFiles.contains(key))
			return;
		Assets.cache.clear(key);
		grabbedFiles.remove(key);
		currentTrackedSounds.remove(key);
	}
	public static function destroyFlixelCache() {
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			removeGraphicCache(obj, key, false);
		}
	}
	public static function clearUnusedMemory() {
		for (key in currentTrackedAssets.keys()) {
			var obj:FlxGraphic = currentTrackedAssets.get(key);
			removeGraphicCache(obj, key);

		}
		for (key in currentTrackedSounds.keys()) {
				removeSoundCache(key);
		}
		
		openfl.system.System.gc();
	}
	public static function cacheData(){
		Thread.create(()->{
		for (i in dontDeleteMePlease) {
			if (i.endsWith(".png")){
				cacheGraphic(i);
			} else{
				var route = i.split("/");
				if (route[0] == "music")
					cacheMusic(route[1]);
				else
					cacheSound(route[1]);
			}
		}
		});
	}
	public static function cacheSound(key:String, ?library:String = "") {
		sound(key, library);
	}
	public static function cacheMusic(key:String, ?library:String = "") {
		music(key, library);
	}
	public static function cacheGraphic(key:String, ?library:String = "") {
		image(key, library);
	}
	public static function clearMemory() {
		grabbedFiles=[];

		clearUnusedMemory(); // Clear "unused" memory
		destroyFlixelCache(); // Clear Flixel Cache
		cacheData(); // recache old cache data
	}
	
	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}
	public static var _format:String;

	static function checkFormatsExisting(base:String, formats:Array<String>) {

		for (i in formats)
		{
			if (FileSystem.exists('$base$i')){
				_format =  i;
				return true;
			}
		}
		return false;
	}
	public static function exists(file:String, type:AssetType) {
		_format = "";

		switch(type)
			{
				case IMAGE:
				if (checkFormatsExisting(file, [".png", ".jpg", ".jpeg", ".gif", ""]))
					return true;
				case TEXT:
				if (checkFormatsExisting(file, [".txt", ".hscript", ".json", ".data", ".raw", ".pkg", ".trans", ".file", ""]))
					return true;
				default:
					return FileSystem.exists(file);

			}
	
			
		return FileSystem.exists(file);
	}
	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		var path = file;
		if (path.startsWith("assets") || path.startsWith("mods") || path.startsWith("./"))
			return path;
		if (library != null)
			path = getLibraryPath(file + _format, library);
		if (exists('assets/shared/${file}', type))
			path = 'assets/shared/${file}$_format';

		if (currentLevel != null)
			{
				if (exists('assets/${currentLevel}/${file}', type))
					path = 'assets/${currentLevel}/${file}$_format';		
			}
		if (library == "songs")
			{
				path = 'songs:assets/songs/' + file;

				if (exists('mods/${currentMod}/songs/' + file, SOUND))
					path = 'mods/${currentMod}/songs/' + file;
			}
		if(currentMod != "") {
			if (exists('mods/${currentMod}/${file}', type))
				return path = 'mods/${currentMod}/${file}' + _format;

		}
		/*
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}*/
		if (exists('assets/' + file, type)) path = getPreloadPath(file + _format); // just to take da format xdxd
		return path;
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return _sound('sounds/$key.$SOUND_EXT', library);//getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return _sound('music/$key.$SOUND_EXT', library);//getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}


	inline static public function getSongPath(song:String) {
		return 'assets/data/songs/${song}';
	}
	inline static public function voices(song:String)
	{
		return _sound('${song.toLowerCase()}/Voices.$SOUND_EXT', "songs");//'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		return  _sound('${song.toLowerCase()}/Inst.$SOUND_EXT', "songs");//'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		return _image('images/$key', library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), text('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), text('images/$key.txt', library));
	}
	inline static public function text(key:String, ?library:String = "") {
		return _txt(key, library);
	}
	/**
		yes, it's the same in Psych engine
		I just based the OG code porque this is the better way to load 
		sprites/sounds and cached it

		TODO: disable all warnings
	**/
	var j:String  = "";
	static function _txt(key:String, ?library:String = "") {
		var path:String = getPath('$key',TEXT, library);
		path = path.substring(path.indexOf(':') + 1, path.length);
		if (exists(path, TEXT))
			{
				return File.getContent('./'+path);
			}
		return "";
	}

	static  function _image(key:String, ?library = "") {
		var bit:BitmapData = null;

		var path:String = getPath('$key',IMAGE, library);
		path = path.substring(path.indexOf(':') + 1, path.length);
		trace(path);

		if (currentTrackedAssets.exists(path))
		{
			return currentTrackedAssets.get(path);
		} else {
			try {
				bit = BitmapData.fromFile(path);
			} catch (e) {}
		}
		if (bit != null){
			var grap:FlxGraphic = FlxGraphic.fromBitmapData(bit, false, path);
			grap.persist = true;
			grap.destroyOnNoUse = false;
			debug_file_getter.push(path);
			currentTrackedAssets.set(path, grap);
			grabbedFiles.push(path);
			return grap;
		}

		return null;
	}
	public static function formatSong(song:String)
	{	song = song.replace(' ', "-");
		//song = song.replace(~/[^a-zA-Z-]/g, '');
		return  song;
	}
	public static function formatToSong(folder:String, song:String) {
		return '$folder/$song';
	}
	public static function getDataPath()
	{
		return currentMod == "" ? "assets/data/": 'mods/$currentMod/data/';
	}
	static  function _sound(key:String, library) {
		var path:String = getPath('$key', SOUND, library);
		path = path.substring(path.indexOf(':') + 1, path.length);
		trace(path);

		if(!currentTrackedSounds.exists(path))
			currentTrackedSounds.set(path, Sound.fromFile('./' + path));
	
		debug_file_getter.push(path);
		grabbedFiles.push(path);
		return currentTrackedSounds.get(path);
	}
}
