package utils;

class ScriptManager {
    public var scriptsIDS:Int =-1;
    public var scripts:Array<Script> = [];
    public function new() {
        /**
            load da global script first;
        **/
        addScript(Paths.getDataPath() + "global-script.hscript", false, "global");
    }
    public function addScript(path:String, ?justOneRun:Bool = false, name:String)
        {
            trace('founded '+  path);
            if (!sys.FileSystem.exists(path))
                return null;
            var data = sys.io.File.getContent(path).trim().rtrim().replace("\r", "");
            var script = new Script(data);
            script.ID = scriptsIDS+=1;
            script.setVar("addBefore", Reflect.makeVarArgs(function (args) {
                if (args[1] == null)
                    return FlxG.state.add(args[0]);
                FlxG.state.insert(FlxG.state.members.indexOf(args[1]) + 1, args[0]);
                return args[0] ;
            }));
            script.name = name;
            script.call("init", [Type.getClassName(Type.getClass(FlxG.state)), script.ID]);
            if (!justOneRun)
                scripts.push(script);
            return script;
        }
        public function scriptAdded(script:Script, ?path:String, ?name:String) {
            callScripts("scriptAdded", script, path, name);
    
        }
        public function callScripts(fun:String, ...args:Dynamic):Dynamic {
            if (args == null)
                args  = [];

            var values:Array<Dynamic> = [];
            for (e in scripts)
            {
                if (e.name != "stage")
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