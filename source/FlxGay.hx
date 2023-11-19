package;

import flixel.FlxGame;

class FlxGay extends FlxGame {
	override function switchState():Void
        {
            // Basic reset stuff
            FlxG.cameras.reset();
            FlxG.inputs.onStateSwitch();
            #if FLX_SOUND_SYSTEM
            FlxG.sound.destroy();
            #end
            Paths.grabbedFiles = [];

            FlxG.signals.preStateSwitch.dispatch();
    
            #if FLX_RECORD
            FlxRandom.updateStateSeed();
            #end
    
            // Destroy the old state (if there is an old state)
            if (_state != null)
                _state.destroy();
      
           // BAD MANNAGER BAF MANANGER
           Paths.destroyFlixelCache();
        /*
            Paths.clearMemory();
            FlxG.bitmap.clearCache();
        */
         

            // Finally assign and create the new state
            _state = _requestedState;
    
            if (_gameJustStarted)
                FlxG.signals.preGameStart.dispatch();
    
            FlxG.signals.preStateCreate.dispatch(_state);
            try {
                Paths.clearUnusedMemory();
            } catch(error) {
                FlxG.log.error(error);
            }
            _state.create();
        
            if (_gameJustStarted)
                gameStart();
    
            #if FLX_DEBUG
            debugger.console.registerObject("state", _state);
            #end
    
            FlxG.signals.postStateSwitch.dispatch();
         
        }
}