package api.routes;

typedef User = {
    var ID:SwagID;
    var avatarURL:String;
    var modsPublished:Array<Mods>;
    var name:String;
    var globalName:String;
    var username:String;
    var tag:String;
}