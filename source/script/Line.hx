package script;

typedef Line = {
    var editorInfo:EditorData;

    var property:String;
    var value:Array<Argument>;

    var type:String;
    var paternLines:Lines;
    var paternFunction:Function;
}