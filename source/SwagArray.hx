package;

/**
 * 
 */
class SwagArray<T:Dynamic> {

    public var _array:Array<{
        ID: String,
        data:T,
    }>;
    public function exists(ID:String):Bool {
        for (e in _array)
        {
            if (e.ID == ID)
                return true;
        }
        return false;
    }
    public function fromJson(json:Dynamic):Array<{
        ID: String,
        data:T,
    }> {
        if (json is String)
            _array = cast Json.parse(json);
        else
            _array = cast json;
        return _array;
    }
     public function toJSON():Array<{
        ID: String,
        data:T,
    }> {
        trace(_array);
        return _array.copy(); //[].concat(_array); // ehm 
    }
    public function set(ID:String, x:T):Array<{
        ID: String,
        data:T,
    }> {
        _array.push({ID: ID, data: x});
        return _array;
    }
    public function getLast(ID:String):T {
        var e = get(ID);
        return e[e.length - 1];
    }
    public function getFirst(ID:String):T {
        return get(ID)[0];
    }
    public function get(ID:String):Array<T> {
        var returnedData:Array<T> = [];
        for (i in _array) {
            if (i.ID == ID)
                returnedData.push(i.data);
        }
        return returnedData;
    }
    public function remove(ID:String):Bool {
        return removeAll(ID);
    }
    public function removeLast(ID:String):Bool {
        var resultedSucessfuly:Bool = false;
        var data:Array<Dynamic> = [];
        for (i in _array) {
            if (i.ID == ID){
                data.push(i);
                break; // pos
            }
        }
        if (data[data.length - 1] != null)
            _array.remove(data[data.length - 1]);
        return resultedSucessfuly;
    }
    public function pop():T {
       return _array.pop().data;
    }
    public function shift():T {
        return _array.shift().data;
     }
    public function removeFirst(ID:String):Bool {
        var resultedSucessfuly:Bool = false;
        for (i in _array) {
            if (i.ID == ID){
                _array.remove(i);
                resultedSucessfuly = true;
                break; // pos
            }
        }
        return resultedSucessfuly;
    }
    public function removeAll(ID:String):Bool {
        var resultedSucessfuly:Bool = false;
        for (i in _array) {
            if (i.ID == ID){
                _array.remove(i);
                resultedSucessfuly = true;
            }
        }
        return resultedSucessfuly;
    }
    public function new () {
        _array = new Array<{
            ID: String,
            data:T,
        }>();
    }
    public function push(ID:String, x:T){
        set(ID, x);
    }
}