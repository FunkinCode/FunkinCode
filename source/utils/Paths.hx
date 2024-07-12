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
	public static var currentTrackedGraphics:Map<String, FlxGraphic> = [];
	public static var debug_file_getter:Array<String> = [];
	public static var grabbedFiles:Array<String> = [];
	/**
	 * THANKS TO PSYCH ENGINE DEVS FOR THIS BASE CODE
	 * 
	 * all credits for em,!!! they are cool people
	 * 
	 * no se hablar ingles
	 * **/
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
	/**
	 *  THIS SYSTEM IS TOTALLY BASED ON PSYCH ENGINE SYSTEM;
	 * MODIFIED TO UNLOAD MEMORY BY CHANGING STATE AN SPECIFICS STATES
	 * UHM, I MEAN
	 * HI :D
	 * **/
	 
	 public static var FORCE:Bool = false;
	 public static function removeGraphicCache(graphic:FlxGraphic, ?key:String, destroy:Bool = true) {
		if (graphic == null) return;
		@:privateAccess FlxG.bitmap._cache.remove(key);
		currentTrackedGraphics.remove(key);

		openfl.Assets.cache.removeBitmapData(key);
		grabbedFiles.remove(key);
	
		graphic.persist = false; 
		graphic.destroyOnNoUse = true;
		graphic.destroy();
	}
	public static function removeSoundCache(key:String) {
		Assets.cache.clear(key);
		grabbedFiles.remove(key);
		final snd = currentTrackedSounds.get(key);
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
	public static function clearUnusedMemory(f:Bool = false) {
		trace("deleting bad ram!!!");
		FORCE = f;
		grabbedFiles = [];
		for (key in currentTrackedGraphics.keys()) {
			var obj:FlxGraphic = currentTrackedGraphics.get(key);
			removeGraphicCache(obj, key);

		}
		for (key in currentTrackedSounds.keys()) {
				removeSoundCache(key);
		}
		
		openfl.system.System.gc();
		currentTrackedGraphics = [];
		currentTrackedSounds = [];
	}
	public static function cacheData(){
		Thread.create(()->{
        /*
		for (i in dontDeleteMePlease) {
			if (i.endsWith(".png")){
				cacheGraphic(i);
			} else{
				
				if (
					cacheMusic(route[1]);
				else
					cacheSound(route[1]);
			}
		}*/
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
				if (checkFormatsExisting(file, [".txt", ".hscript", ".json", ".data", ".raw", ".pkg", ".trans", ".file",".hx",".hs", ".hxs", ""]))
					return true;
				case SOUND:
					if (checkFormatsExisting(file, [".ogg", ".wav", ""]))
						return true;
				default:
					return FileSystem.exists(file);

			}
	
			
		return FileSystem.exists(file);
	}
	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		var path = file;
		if (path.startsWith("assets") || path.startsWith("mods") || path.startsWith("./") || path.startsWith("funkin"))
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
				path = 'assets/songs/' + file;

				if (exists('mods/${currentMod}/songs/' + file, SOUND))
					path = 'mods/${currentMod}/songs/' + file;
				if (exists('funkin/songs/' + file, SOUND))
					path = 'funkin/songs/' + file;
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
		if (exists('funkin/' + file, type)) path ='funkin/' + file + _format;
		if (exists('assets/' + file, type)) path = getPreloadPath(file + _format); // just to take da format xdxd
		if (exists('assets/${library}/$file', type)) path = 'assets/${library}/$file${_format}';
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
		return _sound(getPath(key.startsWith("./" ) || key.startsWith("/") ? key  : 'sounds/$key', SOUND, library), library);//getPath('sounds/$key.$SOUND_EXT', SOUND, library);
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
	inline static public function readDir(dir:String) {
		if (!dir.startsWith("./"))
			dir = './$dir';
		var path = FileSystem.absolutePath(dir);
		return FileSystem.readDirectory(path);
	}
	inline static public function hasVocals(song:String) {
		return _sound('${song.toLowerCase()}/Voices.$SOUND_EXT', "songs") != null;// true;

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
	if (!path.startsWith("./"))
		path = './'+path;
	var path = FileSystem.absolutePath(path);
	
		if ( currentTrackedGraphics.get(path) != null)
		{
			return currentTrackedGraphics.get(path);
		} else {
			try {
				bit = BitmapData.fromFile(path);
			} catch (e) {trace(e);}
		}
		if (bit != null){
			var grap:FlxGraphic = FlxGraphic.fromBitmapData(bit, false, path);
			grap.persist = true;
			grap.destroyOnNoUse = false;
			debug_file_getter.push(path);
			currentTrackedGraphics.set(path, grap);
			grabbedFiles.push(path);
			return grap;
		}
		trace('foundedn\'t $path');
		if (!path.endsWith(".png"))
			return _image(path + ".png");

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
		return currentMod == "" ? "assets/data/": currentMod == "funkin" ? "funkin/data/" : 'mods/$currentMod/data/';
	}
	static  function _sound(key:String, library) {
		var path:String = key.contains("assets/" + library) || key.contains("./")  || key.startsWith("/")? key : getPath('$key', SOUND, library);
		path = path.substring(path.indexOf(':') + 1, path.length);
		if (!path.startsWith("./") && !path.startsWith("/"))
			path = './$path';
		if(!currentTrackedSounds.exists(path))
			currentTrackedSounds.set(path, Sound.fromFile( path));
	
		debug_file_getter.push(path);
		grabbedFiles.push(path);
		return currentTrackedSounds.get(path);
	}
}