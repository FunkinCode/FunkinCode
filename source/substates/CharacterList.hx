package substates;

class CharacterList extends MusicBeatSubstate {

    public var list:Array<String>;
    public var oldOnTheList:String;
    public var finishCallBack:(data:String)->Void;

    public var curSelected:Int = 0;
    public var grpMenuShit:FlxTypedGroup<Alphabet>;
    public function new(list:Array<String>, finishCallBack:(data:String)->Void, ?oldOntheList:String = "nothing") {
        super();
        this.list = list;
        this.finishCallBack = finishCallBack;
        this.oldOnTheList = oldOntheList;
    }
    public override function create() {
        var fg:FlxSprite = new FlxSprite();
        fg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        fg.screenCenter();
        fg.alpha = .75;
        fg.scrollFactor.set();
        add(fg);
        
        grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);
        updateChars();
    }
    	override function update(elapsed:Float)
	{

		super.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
            try {
                finishCallBack(list[curSelected]);
            } catch(e) {}
           close();
        
        }  
        
	}
    var chars:Array<String> = [];
    function updateChars() {
        while (grpMenuShit.members.length > 0)
            {
                grpMenuShit.remove(grpMenuShit.members[0], true);
            }
        
		var characters:Array<String> = list;
        chars = characters;
        for (i in 0...characters.length)
            {
                var songText:Alphabet = new Alphabet(0, (70 * i) + 30, characters[i], true, false);
                songText.isMenuItem = true;
                songText.targetY = i;
                songText.scrollFactor.set();
                grpMenuShit.add(songText);
            }
        curSelected = characters.indexOf(oldOnTheList);
        if (curSelected < 0)
            curSelected = 0;
        changeSelection();
    }
    function changeSelection(change:Int = 0):Void
        {
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
    
            curSelected += change;
    
            if (curSelected < 0)
                curSelected = grpMenuShit.members.length - 1;
            if (curSelected >= grpMenuShit.members.length)
                curSelected = 0;
    
            var bullShit:Int = 0;
    
            for (item in grpMenuShit.members)
            {
                item.targetY = bullShit - curSelected;
                bullShit++;
    
                item.alpha = 0.6;
                // item.setGraphicSize(Std.int(item.width * 0.8));
    
                if (item.targetY == 0)
                {
                    item.alpha = 1;
                    // item.setGraphicSize(Std.int(item.width));
                }
            }
        }
    

}