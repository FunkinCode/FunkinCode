package api.routes;

typedef UserModsSuscribed = 
{
    var ID:SwagID;
    var user:User;
    
    var mods:Array<Mod>;
}