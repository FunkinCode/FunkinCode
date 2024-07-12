package utils;

class ScriptManager {
    public var length:Int =-1;
    public var scripts:Array<Script> = [];
    public var variables:Map<String, Dynamic> = [];
    public function new() {
        
    }
    public function updateVars() {
        for (script in scripts) {
            var fields = Reflect.fields(FlxG.state);
            for(i in fields)
                script.setVar(i, Reflect.field(FlxG.state,i));

            hearMe(script);
            script.call('updateScript', [script.name]);
        }
    }
    public function addVariable(name:String, ?from:Dynamic) {
        if (from == null)
            from = FlxG.state;
        variables.set(name, from);
    }
    public function addFunc(name:String, onCall:(args:Array<Dynamic>)->Void) {
        for (script in scripts)
        script.setVar(name,  Reflect.makeVarArgs(onCall));
    }
    public function hearMe(script:Script) {
        for (variable => patern in variables) {
            script.setVar(variable, Reflect.getProperty(patern, variable));
        }
    }
    public function addScript(path:String, ?justOneRun:Bool = false, name:String, ?customPatern:Dynamic)
    {
        
        if (!sys.FileSystem.exists(path))
            return null;
        var script = getScript(name);
        if (script != null)
            scripts.remove(script);
        trace('founded '+  path);
        var data = sys.io.File.getContent(path).trim().rtrim().replace("\r", "");
        var script = new Script(data,this);
        script.ID = length+=1;
        script.setVar("addBefore", Reflect.makeVarArgs(function (args) {
            if (args[1] == null)
                return FlxG.state.add(args[0]);
          FlxG.state.insert( FlxG.state.members.indexOf(args[1]) - 2, args[0]);
            return args[0] ;
        }));
        script.setVar("addAfter", Reflect.makeVarArgs(function (args) {
            if (args[1] == null)
                return FlxG.state.add(args[0]);
          FlxG.state.insert( FlxG.state.members.indexOf(args[1]) - 1, args[0]);
            return args[0] ;
        }));
        script.name = name;
        try {
        script.call("init", [name, PlayState.SONG.song, script.ID, customPatern]);

        } catch(e) {
             try {
        script.call("init", [name, null, script.ID, customPatern]);

        } catch(c) {
        script.call("init", [name]);

        }}

        if (!justOneRun)
            scripts.push(script);
        return script;
    } 
      
    public function callScripts(fun:String, ...args:Dynamic):Dynamic {
            if (args == null)
                args  = [];

            var values:Array<Dynamic> = [];
            for (e in scripts)
            {
                values.push({val: e.call(fun, args), name: e.name});
            }
            return values;
    }
    public function getScript(IDOrName:Dynamic)
    {
            for (script in scripts) {
            if (IDOrName is String) {
                if (script.name == IDOrName)
                    return script;
            } else if (IDOrName is Int){
                if (script.ID == IDOrName)
                    return script;
            }
            }
            return null;
    }
    
}