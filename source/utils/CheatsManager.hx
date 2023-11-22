package utils;

class CheatsManager {
    private var _holdTime:Float = 0;
    public var usingCheats:Bool = false;
    private var curText:String = "";
    
    var cheatCodeBlack:FlxSprite;
	var cheatCodeText:FlxText;
    public function new(camera:FlxCamera, group:FlxGroup)
    {
		cheatCodeText = new FlxText(0,0,0, "Cheat Actived", 16);

        cheatCodeBlack = new FlxSprite(25,25);
		cheatCodeBlack.makeGraphic(Math.floor(cheatCodeText.width +50),Math.floor(cheatCodeText.height + 10),FlxColor.BLACK);
		cheatCodeBlack.alpha = .7;

		cheatCodeText.x = cheatCodeBlack.x + 5;
		cheatCodeText.y = cheatCodeBlack.y + 5;

		group.add(cheatCodeBlack);
		group.add(cheatCodeText);


		cheatCodeBlack.visible = cheatCodeText.visible = false;

		cheatCodeText.cameras = [camera];
		cheatCodeBlack.cameras = [camera];
    }
    public function onTextCheck() {
        var state =  PlayState.instance;
        var usedCheat:Bool = true;
    @:privateAccess

        switch(curText)
        {
            case "BOTPLAY":
               PlayState.botplay = !PlayState.botplay;
            case "KYS":
                state.kys = true;
                FlxG.sound.play(Paths.sound('fnf_loss_sfx'));
                state.boyfriend.playAnim("firstDeath");
            case "LIFE":
                state.health = 1;

            case "PROPLAYER":
                state.hit_data  = state.totalHits;
                state.combo = state.totalHits - state.misses;
                state.ratingCombo = state.combo;
                state.misses = 0;

            case "ALLSICK":
                state.forceRating = "sick";
            case "ALLGOOD":
                state.forceRating = "good";
            case "ALLDEFAULT":
                state.forceRating = "";
            case "ENDTHIS":
                state.endSong();
            case "HEAL":
                state.health += .5;

            default:
                usedCheat = false;
                // da notin
        }
        if (usedCheat)
            baseCheatActivate();
    }
    public function baseCheatActivate() { 
        usingCheats = true;
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.65);

    }
    public function update(elapsed:Float) {
        _holdTime += elapsed;
			cheatCodeBlack.visible = cheatCodeText.visible = usingCheats;

        if (_holdTime >= 1.5)
            {
                _holdTime = 0;
                curText = "";
            }
        FlxG.watch.addQuick("CheatCode.data", curText);
        if (FlxG.keys.justPressed.ANY){
            var key = FlxG.keys.getIsDown()[0];
            
            _holdTime = 0;
            curText += key.ID.toString();
            onTextCheck();
        }
        if (curText.length > 16)
            curText = "";
    }
}