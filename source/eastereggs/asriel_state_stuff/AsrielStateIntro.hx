package eastereggs.asriel_state_stuff;

class AsrielStateIntro extends FlxState {
    var text:FlxText;
    public override function create() {
        var heart = new Heart(0,0);
        add(heart);
        heart.screenCenter();        
        text = new FlxText();
        add(text);
    

        _text = textToShow.split("");
    }
    var textToShow:String = "Asriel Dreemurr";
    var _text:Array<String>;
    public var _textAlph:Float = 0.0;
    public var speed = 1;
    public function resetTextTo(textTo:String =  "Asriel Dreemurr") {
        text.text  = "";
        textToShow = textTo;
        _text = textToShow.split("");

    }
    public override function update(elapsed:Float) {
        super.update(elapsed);
        _textAlph += elapsed;
        if (_text.length > 0){
        if (_textAlph> 0.1 * speed) {
            text.text += _text.shift();
            _textAlph = 0;
            FlxG.camera.shake(0.035, 0.025);
            FlxG.sound.play("assets/secrets/sounds/appear_text.wav").pitch = 0.8;
        }
        } else {
            if (_textAlph > 1.5) {
                _textAlph = 0;
            FlxG.switchState(new AsrielState());
                
            }
        }
        text.screenCenter();
        text.size = 64;
    }

}