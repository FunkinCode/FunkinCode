package script;
import script.Script;
class SwagScript {
    public static var sprs:Map<String,FlxSprite> =[];
    public static var snds:Map<String,FlxSound> =[];
    private var data:Script;
    public var name:String;
    public var variables:Map<String, Dynamic>;
    public var functionsCallbacks:Map<String, Dynamic>;
    public function new(readPath:String) {
        variables = new Map();
        functionsCallbacks = new Map();

    }
    public function resolve() {
        name = data.name;

        for (fun in data.functions ) {
            functionsCallbacks.set( fun.name, resolveFunction(fun, data));
        }

        call("init");
    }
    public function call(fun:String) {
        var f = functionsCallbacks.get(fun);
        if (f != null) {
            f();
        }
    }
    public function resolveFunction (data:Function, patern:Script) {
        return ()->{
            var lastCondition:Bool = true;
            for (todo in data.lines.list) {
                var type:String = cast todo.type;
                if (lastCondition){
                    switch(type) {
                        case "CREATE": 
                            create(todo.property, todo.value);
                        case "SET":
                            var val = resolveProperty(todo.value);
                            var target = FlxG.state;
                            if (variables.exists(todo.property)) {
                                target = variables.get(todo.property);
                            } 
                            Reflect.setProperty(target, todo.property, val);
                        case "IF":
                            lastCondition  = resolveCondition(todo.value);
                        case "ELSE": // the same shit LOL
                            lastCondition = !lastCondition;
                        case "END":
                            lastCondition = true;
                        case "CALL":
                        var fi = patern.functions.filter((f)-> f.name == todo.property);
                            if (fi.length > 0 && fi[0].editorInfo != data.editorInfo) {
                                call(todo.property);
                            } else {
                                var args = [];
                                for (i in todo.value) {
                                    args.push(i.value.data);
                                }
                               Reflect.callMethod(FlxG.state, Reflect.getProperty(FlxG.state, todo.property), args );
                            }
                    }
                }
            }
        }
    }
    function create(name:String, args:Array<Argument>) {
        var finalVal:Dynamic;
        switch(args[0].value.data) {
            case "sprite":
                finalVal = createSprite(args[1].value.data, name, args[2].value.data, args[3].value.data, args[4].value.data, args[5].value.data);
            default:
                finalVal = args[1].value.data;
        }
        variables.set(name, finalVal);
    }
    function createSprite(type:String, name:String, graphic:String, width:Int = 0, height:Int = 0, color:Int = 0xFFFFFF) {
         var spr:FlxSprite = new FlxSprite();
         if (type == "graphic")
            {
                spr.loadGraphic(Paths.image(graphic));
                spr.setGraphicSize(width, height);
                spr.color = color;
            } 
            else {
                spr.makeGraphic(width, height, color);
            }
            sprs.set(name, spr);
        return spr;

        
    }
    public function resolveCondition(props:Array<Argument>):Bool {
        var result:Bool = true;
        var e:Array<Dynamic> = [];

        for (prop in props) { // Well well well, this code is really BAD

                if (e.length > 2) {
                    switch(e[1]) {
                        case "==":
                            if (e[0] != e[1])
                                result = false;
                        case ">=":
                            if (e[0] < e[1])
                                result = false;
                        case "<=":
                            if (e[0] > e[1])
                                result = false;
                        case "<":
                            if (e[0] >= e[1])
                                result = false;
                        case ">":
                            if (e[0] <= e[1])
                                result = false;
                        case "!=":
                            if (e[0] != e[1])
                                result = false;
                    }
                    e = [];
                    break;
                } 
            e.push(prop.value.data);

            
        }
        return result;
    }
    public function resolveProperty(prop:Array<Argument>):Dynamic {
        var e:Dynamic;
        switch (prop[0].value.valType) {
            case "int": e = 0;
            case "string": e = "";
            case "bool": e = false;
            case "null": e = null;
        }
        for (pr in prop) {
            switch(pr.value.type) {
                case "SUM":
                    e += pr.value.data;
                case "SUB":
                    e -= pr.value.data;
                case "TOGLE":
                    e = !e;
                case "FROM":
                    e =  pr.value.data;
            }
        }
        return e;
    }
}