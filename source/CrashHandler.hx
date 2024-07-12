package;

import sys.FileSystem;

class CrashHandler extends FlxState {
    public var err:haxe.Exception;
    public var message:String;
    public var title:String;
    public function new(title:String, message:String, err:haxe.Exception) {
        super();
        this.title = title;
        this.message = message;
        this.err = err;
    }
    public var texts:Array<FlxText> = [];
    public var xd:FlxText;
    public override function create() {
        FlxG.sound.playMusic("empty.ogg");
        FlxG.sound.music.volume = 0.5;
    
        var dir = './crashs/';
        var date = Date.now();
        var filePath = '${dir}crash-${date.getUTCDay() + 1}-${date.getUTCMonth() +1}-${date.getUTCFullYear()}-${date.getUTCHours() }\'${date.getUTCMinutes()}\'${date.getUTCSeconds()}';
        if (!FileSystem.exists(dir))
            FileSystem.createDirectory(dir);
        sys.io.File.saveContent(filePath, 'Target: Linux\nMessage: ${message}\nError: ${err}\nCallstack: ${err.stack}\n\nFunkinCode:v0\nCrashHandler v1.0 by MrNiz');
        @:privateAccess TitleState.initialized=false;
        FlxG.switchState(new TitleState());
        warn(title);
        error('${message}\nError: ${err}\nCallstack: ${err.stack}\n\nSaved on ${filePath}\nCrash handler writen by MrNiz for FunkinCode\nReport any issue on https://github.com/FunkinCode/FunkinCode/');
        Main.mainData.stage.window.alert('${message}\nError: ${err}\nCallstack: ${err.stack}\n\nSaved on ${filePath}\nCrash handler writen by MrNiz for FunkinCode\nReport any issue on https://github.com/FunkinCode/FunkinCode/',title);
//Main.mainData.stage.window.
    }
    /**public var curEvent:Int = 0;
    public function ev() {
        return;
        if (changing)
            return;
        switch(curEvent) {
            case 0:
                error(err);
                error(err.stack);
                Main.mainData.stage.window.alert('${message}\nError: ${err}\nCallstack: ${err.stack}',title);
            default:
                changing = true;
                @:privateAccess TitleState.initialized=false;
                FlxG.switchState(new TitleState());
        }
        curEvent += 1;
    }*/
    public var changing:Bool = false;

    public override function update(elapsed:Float) {
        super.update(elapsed);
        //ev();

     
    }
    
}