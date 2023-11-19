package substates;

class CharacterList extends MusicBeatSubstate {

    public var curSelected:Int = 0;
    public var curChar:String;
    public var variable_to_modify:String;
    public var characterList:Array<String>;
    public var variableFromMe:String = "_song";
    public var grpMenuShit:FlxTypedGroup<Alphabet>;
    public function new(curChar, variable_to_modify:String, characterList:Array<String>, ?variableFromMe:String = "_song") {
        super();
        this.curChar = curChar;
        this.variableFromMe = variableFromMe;
        this.characterList = characterList;
        this.variable_to_modify = variable_to_modify;
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
            @:privateAccess
           Reflect.setProperty(  Reflect.getProperty(ChartingState.instance, variableFromMe), variable_to_modify, chars[curSelected]);

           close();
           @:privateAccess
           ChartingState.instance.updateHeads();
        }  
        
	}
    var chars:Array<String> = [];
    function updateChars() {
        while (grpMenuShit.members.length > 0)
            {
                grpMenuShit.remove(grpMenuShit.members[0], true);
            }
        
		var characters:Array<String> = characterList;
        chars = characters;
        for (i in 0...characters.length)
            {
                var songText:Alphabet = new Alphabet(0, (70 * i) + 30, characters[i], true, false);
                songText.isMenuItem = true;
                songText.targetY = i;
                songText.scrollFactor.set();
                grpMenuShit.add(songText);
            }
        curSelected = characters.indexOf(curChar);
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