package script;

typedef Script =  {
    var name:String;
    var editorInfo:EditorData;

    var functions:Array<Function>;

    var vars:Array<Line>;
}