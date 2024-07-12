package;

import flixel.FlxGame;

class FlxGay extends FlxGame {
    public static var waitDeleteRam:Bool = false;
	override function switchState():Void
        {
            // Basic reset 
            if (Type.getClass(_state) != PlayState) {
                Paths.grabbedFiles = [];
                Paths.cacheData();

                try {
                    if (!waitDeleteRam) // for better old cache  /// Yeah yeah, im, dumb?
                        Paths.clearUnusedMemory();
                } catch(error) {
                    FlxG.log.error(error);
                }
            }
            try {
            super.switchState();
            } catch(e) {
                onCrash('Game is crashed', 'The crash was called from "create" / "switchState"', e);
            }
        }
    override function draw() {
          //  try {
                super.draw();
            /*} catch(e) {
                //FlxG.resetState();
                onCrash('Game is crashed', 'The crash was called from "draw"', e);
            }*/
        }
        override function update() {
            try {
                super.update();
            } catch(e) {
                onCrash('Game is crashed', 'The crash was called from "update"', e);
            }
        }
        public static function onCrash(title:String, message:String, err:haxe.Exception) {

            FlxG.switchState(new CrashHandler(title, message, err));

            //Main.mainData.stage.window.alert('${message}\nError: ${err}\nCallstack: ${err.stack}',title);

        }
}
