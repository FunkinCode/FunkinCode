package;
import openfl.system.System;
import openfl.display.FPS as OpenFLFPS;
class FPS extends OpenFLFPS {
    var oldText:String = "";
    override function __enterFrame(deltaTime:Float):Void {
        oldText = text;
        super.__enterFrame(deltaTime);
        if (oldText != text){
        var memoryMegas:Float = 0;
			
        #if openfl
        memoryMegas = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));
        text += "\nMemory: " + memoryMegas + " MB";
        #end
        textColor = 0xFFFFFFFF;
        var fps = PreferencesMenu.getPref("fps");
        if (Math.isNaN(fps) )
            fps = 60;
        if (memoryMegas > 3000 || currentFPS <= fps / 2)
        {
            textColor = 0xFFFF0000;
        } 
        }
}
}