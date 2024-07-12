package engine;
typedef Permission = {
    var id:Int;
    var name:String;
    var reqsONLINE:Bool;
    @:optional var description:String;
    @:optional var warn:Bool;
}

class PermissionResolve {}