package utils;

import sprites.SpriteBase;
import hscript.Interp;
import hscript.Expr;
import hscript.Parser;
class Script {
    var parser:Parser;
    var expr:Expr;
    public var name:String;

    public var ID:Int = 0;
        var interp:Interp;
    public function new(data:String, ?manager:ScriptManager)
    {
        if (data == null)
            data = 'trace("no data");';
        parser = new Parser();
        expr = parser.parseString(/*'
        var hi = "testing";

        function create(){
        
            trace(state);
            trace(ngSpr);
            add(ngSpr);
            ngSpr.visible = true;
            FlxG.sound.play(Paths.sound("confirmMenu"), 0.7);
            trace("test");

        }
        '*/ data    , "Script");
        interp = new Interp();
        /*try {
        @:privateAccess
        var testF = interp.resolve("test");

        Reflect.callMethod(this, testF, []);
        } catch(e) {

            trace(e);
        }*/
        init();
            run();
    }
    public static function _ON_STATE_CREATE() {
        trace("poto");
    }
    public function init() {
        var curState = FlxG.state;
        var stateClass = Type.getClass(FlxG.state);
        var className = Type.getClassName(stateClass);
        var fields = Reflect.fields(curState);
        for (field in fields)
            {
                setVar(field, Reflect.getProperty(curState,field));
            }
        setVar("state", curState);
        setVar("Padre", curState);
        setVar("Patern", stateClass);
        setVar("State", stateClass);
        setVar(className, stateClass);
        setVar("className", className);
        setVar("PlayState", PlayState);
        setVar("Freeplay", FreeplayState);
        setVar("StateClass", stateClass);
        importAll();
        setVar("Reflect", Reflect);
        setVar("Type", Type);
        setVar("Std", Std);


        setVar("add", Reflect.makeVarArgs(function (object) {
            try {
                trace(object[0]);
                curState.add(cast object[0]);
            }catch(e){
                trace(e);
            }
        }));
        setVar("remove", Reflect.makeVarArgs(function (object) {
            try {
                curState.remove(cast object[0]);
            }catch(e){
                trace(e);
            }
        }));
  
    }

    function importAll() {
    setVar("Math", Math);
    setVar('FlxColor',SimulateFlxColor);
    setVar('FlxAnimate',FlxAnimate);
    setVar('FlxSymbol',FlxSymbol);


    setVar('BGSprite',BGSprite);
    setVar('MusicBeatState',MusicBeatState);
    setVar('MusicBeatSubstate',MusicBeatSubstate);

    setVar('BlendModeEffect',BlendModeEffect);
    setVar('BuildingShaders',BuildingShaders);
    setVar('ColorSwap',ColorSwap);
    setVar('OverlayShader',OverlayShader);
    setVar('WiggleEffect',WiggleEffect);

    setVar('Alphabet',Alphabet);
    setVar('BackgroundDancer',BackgroundDancer);
    setVar('BackgroundGirls',BackgroundGirls);
    setVar('Boyfriend',Boyfriend);
    setVar('Character',Character);
    setVar('CutsceneCharacter',CutsceneCharacter);
    setVar('DialogueBox',DialogueBox);
    setVar('HealthIcon',HealthIcon);
    setVar('MenuCharacter',MenuCharacter);
    setVar('MainMenuItem',MainMenuItem);
    setVar('Note',Note);
    setVar('NoteSplash',NoteSplash);
    setVar('SwagCamera',SwagCamera);
    setVar('TankCutscene',TankCutscene);
    setVar('TankmenBG',TankmenBG);

    setVar('AnimationDebug',AnimationDebug);
    setVar('ChartingState',ChartingState);
    setVar('CutsceneAnimTestState',CutsceneAnimTestState);
    setVar('DebugBoundingState',DebugBoundingState);
    setVar('FreeplayState',FreeplayState);
    setVar('GameOverState',GameOverState);
    setVar('GitarooPause',GitarooPause);
    setVar('LatencyState',LatencyState);
    setVar('LoadingState',LoadingState);
    setVar('MainMenuState',MainMenuState);
    setVar('OutdatedSubState',OutdatedSubState);
    setVar('PlayState',PlayState);
    setVar('StoryMenuState',StoryMenuState);
    #if VIDEOS
    setVar('VideoState',VideoState);
    setVar('FlxVideo',FlxVideo);

    #end
    setVar('GameOverSubstate',GameOverSubstate);
    setVar('PauseSubState',PauseSubState);

    #if switch
    setVar('Snd',Snd);
    setVar('SndTV',SndTV);
    #end
    setVar('File',File);

    setVar('APIStuff',APIStuff);
    setVar('Conductor',Conductor);
    setVar('Controls',Controls);
    setVar('Control',Control);
    setVar('CoolUtil',CoolUtil);
    #if discord_rpc
    setVar('DiscordClient',DiscordClient);

    #end
    setVar('Highscore',Highscore);
    setVar('InputFormatter',InputFormatter);
    setVar('Mods',Mods);
    setVar('NGio',NGio);
    setVar('Paths',Paths);
    setVar('Song',Song);
    setVar('PlayerSettings',PlayerSettings);
    setVar('Section',Section);
    setVar('FlxBasic',FlxBasic);
    setVar('FlxCamera',FlxCamera);
    setVar('FlxG',FlxG);
    setVar('FlxGame',FlxGame);
    setVar('FlxObject',FlxObject);
    setVar('FlxSprite',FlxSprite);
    setVar('FlxState',FlxState);
    setVar('FlxSubState',FlxSubState);
    setVar('FlxGridOverlay',FlxGridOverlay);
    setVar('FlxTrail',FlxTrail);
    setVar('FlxTrailArea',FlxTrailArea);
    setVar('FlxEffectSprite',FlxEffectSprite);
    setVar('FlxWaveEffect',FlxWaveEffect);
    setVar('FlxTransitionableState',FlxTransitionableState);
    setVar('FlxAtlas',FlxAtlas);
    setVar('FlxAtlasFrames',FlxAtlasFrames);
    setVar('FlxTypedGroup',FlxTypedGroup);
    setVar('FlxGroup',FlxGroup);
    setVar('FlxAngle',FlxAngle);
    setVar('FlxMath',FlxMath);
    // setVar('FlxPoint',FlxPoint);
    setVar('FlxRect',FlxRect);
    setVar('FlxSound',FlxSound);
    setVar('FlxText',FlxText);
    setVar('FlxEase',FlxEase);
    setVar('FlxTween',FlxTween);
    setVar('FlxBar',FlxBar);
    setVar('FlxCollision',FlxCollision);
    //setVar('FlxColor',FlxColor);
    setVar('FlxSort',FlxSort);
    setVar('FlxStringUtil',FlxStringUtil);
    setVar('FlxTimer',FlxTimer);
    setVar('Json',Json);
    setVar('Assets',Assets);
    setVar('Lib',Lib);
    setVar('BitmapData',BitmapData);
    //setVar('BlendMode',BlendMode);
    //setVar('StageQuality',StageQuality);
    setVar('ShaderFilter',ShaderFilter);


    setVar('FlxG',FlxG);
    setVar('FlxSprite',FlxSprite);
    setVar('FlxGridOverlay',FlxGridOverlay);
    setVar('FlxInputText',FlxInputText);
    setVar('FlxTypedGroup',FlxTypedGroup);
    setVar('FlxGroup',FlxGroup);
    setVar('FlxMath',FlxMath);
    //setVar('FlxPoint',FlxPoint);
    setVar('FlxSound',FlxSound);
    setVar('FlxText',FlxText);
    setVar('FlxButton',FlxButton);
    setVar('FlxSpriteButton',FlxSpriteButton);
    //setVar('FlxColor',FlxColor);
    setVar('Json',Json);
    setVar('Assets',Assets);
    setVar('Event',Event);
    setVar('IOErrorEvent',IOErrorEvent);
    setVar('Sound',Sound);
    setVar('FileReference',FileReference);
    //setVar('ByteArray',ByteArray);

    setVar('StringTools',StringTools);

    setVar('FlxG',FlxG);
    setVar('FlxInput',FlxInput);
    setVar('FlxAction',FlxAction);
    setVar('FlxActionInput',FlxActionInput);
    setVar('FlxActionInputDigital',FlxActionInputDigital);
    setVar('FlxActionManager',FlxActionManager);
    setVar('FlxActionSet',FlxActionSet);
    setVar('FlxGamepadButton',FlxGamepadButton);
    //setVar('FlxGamepadInputID',FlxGamepadInputID);
    //setVar('FlxKey',FlxKey);

    setVar('GraphicTransTileDiamond',GraphicTransTileDiamond);
    setVar('FlxTransitionableState',FlxTransitionableState);
    setVar('TransitionData',TransitionData);
    setVar('FlxGraphic',FlxGraphic);
    setVar('FlxGroup',FlxGroup);
    setVar('FlxGamepad',FlxGamepad);
    }
    public function setVar(name:String, variable:Dynamic) {
        @:privateAccess
        interp.variables.set(name, variable);
    }
    public function run() {
        init();
        interp.execute(expr);
        init();


    }
    public function call(F:String, args:Array<Dynamic>):Dynamic {
       // run(); // idk
       init();
        try {
        
        @:privateAccess
        var functionCall = interp.resolve(F);
        return Reflect.callMethod(FlxG.state, functionCall, args);
        } catch(e) {}
        var mapWithStateVars:Map<String, Dynamic>=[];
        for (variable in Reflect.fields(FlxG.state)) {
            mapWithStateVars.set(variable, Reflect.getProperty(FlxG.state,variable));
        }
       @:privateAccess 
       var vars = interp.variables;
        for (variable in  /*vars uups*/mapWithStateVars.keys()) {
            if (vars.get(variable) != mapWithStateVars.get(variable)){
                Reflect.setProperty(FlxG.state, variable,vars.get(variable));
            }
        }
        return null;
    }
}
class SimulateFlxColor {
    public static var BLACK:FlxColor = FlxColor.BLACK;
    public static var BLUE:FlxColor = FlxColor.BLUE;
    public static var BROWN:FlxColor = FlxColor.BROWN;
    public static var WHITE:FlxColor = FlxColor.WHITE;
    public static var RED:FlxColor = FlxColor.RED;
    public static function fromString(str){
        return FlxColor.fromString(str);
    }
    public static function fromRGB(rgb:Array<Int>) {
        return FlxColor.fromRGB(rgb[0], rgb[1], rgb[2], rgb[3]);
    }
}
