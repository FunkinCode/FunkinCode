package ui;

import sprites.StrumArrow;

class LatencyShit extends FlxGroup {
	var noteGrp:FlxTypedGroup<Note>;
	var strumLine:StrumArrow;

    public function new() {
        super();
		Conductor.changeBPM(120);
        trace("ehm");

		noteGrp = new FlxTypedGroup<Note>();

		for (i in 0...34)
		{
			var note:Note = new Note();
			note.setupNote(Conductor.crochet * i, 1);
            note.scrollFactor.set(0,0);
			noteGrp.add(note);
		}
        
        strumLine = new  StrumArrow(100, 1, 1, 'stage');
        strumLine.scrollFactor.set(0,0);

		add(strumLine);
		add(noteGrp);
    }
    var hasMusic:Bool = false;
    public function onCall() {
        trace("Hey!");
        if (hasMusic)
            return;
        prom =[];
        unNotes = [];

        hasMusic = true;
        FlxG.sound.playMusic(Paths.sound('soundTest'));
        FlxG.sound.music.onComplete =function () {
            unNotes = [];
        }
		Conductor.changeBPM(120);

    }
    public function ondiscall() {
        if (!hasMusic)
            return;
        hasMusic = false;
        FlxG.sound.playMusic(Paths.music('freakyMenu'));

    }
    var prom:Array<Float> = [];
    override function update(elapsed:Float)
        {
    
            Conductor.songPosition = FlxG.sound.music.time ;
      
            if (FlxG.keys.justPressed.R)
                {
                    unNotes = [];
                    prom = [];
                    FlxG.sound.music.time = 0;
                }
            noteGrp.forEach(function(daNote:Note)
            {
                daNote.y = (strumLine.y - ((Conductor.songPosition - Conductor.offset )- daNote.strumTime) * 0.45);
                daNote.x = strumLine.x;
                if (FlxG.keys.justPressed.SPACE)
                    {
                        if (daNote.canBeHit) {
                        Conductor.offset = (FlxG.sound.music.time - daNote.strumTime);
                        prom.push(Conductor.offset);
                        Conductor.offset = 0;
                        for (e in prom)
                            Conductor.offset += e;
                        Conductor.offset /= prom.length;
                        
                        PreferencesMenu.setPref("offset",   Math.floor(Conductor.offset));
                        @:privateAccess PreferencesMenu.instance.prefNumber('offset',0,-1000, 1000);
                        }
                    }
                daNote.setGraphicSize(strumLine.width, strumLine.height);
                daNote.alpha = 1;
             @:privateAccess   daNote.tooLate = daNote.willMiss = false;
    
                if (daNote.y < strumLine.y)
                    {
                        daNote.alpha =.2;
                        onNote(daNote);
                    }
            });
    
            super.update(elapsed);
        }
        public var unNotes:Array<Note> = [];
        function onNote(daNote) {
            if (unNotes.contains(daNote))
                return;
            unNotes.push(daNote);
            strumLine.confirm(true);
        }
}