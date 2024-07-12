package utils;

class DragDropping {
    public var callBack:(p:String)->Void;
    public var filters:Array<String> = [];
    public function new (callBack:(p:String)->Void) {
        if (callBack == null)
            callBack = e-> {};
        filters = [".png", ".ogg", ".mp4", ".json", ".xml"];
        this.callBack = callBack;
    }

    public function onWindowDropFile(str:String) {
        trace('Drag file: "${str}"');
        
     
        try { 
            var state:MusicBeatState = cast FlxG.state;
            state.onFileDropped(str);
        } catch(e) {}
        if (callBack != null)
            callBack(str);
        if (str.endsWith(".wav") || str.endsWith(".ogg") ) {
            FlxG.sound.play(Paths.sound( ((str.startsWith("/") ?'' : './') + str )));
        }
    }
    public function register() {
        Lib.application.window.onDropFile.add(onWindowDropFile);
        
    }
    public function dispose() {
        Lib.application.window.onDropFile.remove(onWindowDropFile);
        
    }

}