package states;


class VideoState extends MusicBeatState
{

	public static var seenVideo:Bool = false;
	#if VIDOES
	public var video:FlxVideo;

	override function create()
	{
		super.create();
		


		seenVideo = true;

		FlxG.save.data.seenVideo = true;
		FlxG.save.flush();
		#if linux
		FlxG.switchState(new TitleState());
		return;
		#end

		video = new FlxVideo();
		video.play(Paths.file('music/kickstarterTrailer.mp4'), false);

	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
			finishVid();

		super.update(elapsed);
	}

	function finishVid():Void
	{

		video.dispose();
		TitleState.initialized = false;
		FlxG.switchState(new TitleState());
	}
	#else
	override function create() {FlxG.switchState(new TitleState());}
	#end
}
