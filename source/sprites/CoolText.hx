package sprites;


class CoolText extends FlxText {
    public var variablesPaterns:Map<String, Dynamic> = [];
    public var variablesNames:Map<String, String> = [];
    public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true)
    {    
        super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
        variablesPaterns = [];
        baseText = text;
        variablesNames = [];
    }
    public var baseText:String = "";
    public var format:String = '%a%: %b%';
    public var separator:String = ",";
    override public  function update(elapsed:Float) {
        super.update(elapsed);
        text = baseText;
        for (name => patern in variablesPaterns) {
            text += format.replace('%a%', variablesNames.get(name)).replace("%b%",Reflect.field(patern, name)) + separator;
        }
        if (text.endsWith(separator))
            {
                var tempText = text.split(separator);
                tempText.pop();
                text = tempText.join(separator);
            }
    }
     // DUMB code
    public function addVariableToListen(From:Dynamic, name:String, ?displayName:String) {
        if (displayName == null)
            displayName =name;
        variablesPaterns.set(name, From);
        variablesNames.set(name, displayName);
    }
}