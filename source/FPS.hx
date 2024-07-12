package;
import openfl.system.System;
import openfl.display.FPS as OpenFLFPS;
class FPS extends OpenFLFPS {
    var oldText:String = "";
    public static var anotherSumText:String = "";
    public static var maxMemPeaked:Float = 0;
    public static var memoryUsed:Float;
    override function __enterFrame(deltaTime:Float):Void {
        oldText = text;
      var fps = PreferencesMenu.getPref("fps");
		eval('FlxG.elapsed = ${1 / 24};');
        super.__enterFrame(deltaTime);
        if (currentFPS >=   fps ) {
            text = 'FPS: ${fps}' ;
        }
        if (oldText != text){
        width = 350;
        var memoryMegas:Float = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));

        memoryUsed = memoryMegas;

        text += "\nMemory: " + memoryMegas + ' MB\nMaxMem Peak: ${maxMemPeaked} mb';
        if (maxMemPeaked < memoryMegas )
            maxMemPeaked = memoryMegas;     
    

        textColor = 0xFFFFFFFF;
  
        if (Math.isNaN(fps) )
            fps = 60;
        if (memoryMegas > 3000 || currentFPS <= fps / 2)
            {
                textColor = 0xFFFF0000;
            } 
        }
}
}
