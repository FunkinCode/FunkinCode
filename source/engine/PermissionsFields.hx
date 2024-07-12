package engine;

class PermissionsFields {
    public static var MODS_PERMS:Map<String, Array<Permission>> = [];
    /**
     * 
     * Default perms
     */
    public static var DEFAULT_PERMS = [READ_LOCAL_STORAGE, WRITE_LOCAL_STORAGE];

    public static var WRITE_LOCAL_STORAGE:Permission ={name:"Write Local Storage", id: -2, description: "Gives permissions to write/remove files in the application storage (like remove assets/images/image.png or  something like that)", reqsONLINE: false};

    public static var READ_LOCAL_STORAGE:Permission = {
        name:"Read Local Storage", 
        id: -1,
        description: "Gives access to reads the application storage (like assets/, mods/)", 
        reqsONLINE: false
    };
    
    public static var READ_EXTERNAL_STORAGE:Permission ={name:"Read External Storage", id: 0, description: 'Gives access to reads the application storage (like ${#if !linux 'c:/programFiles, d:/LizFIles, c:/Users/MDCDEV/mdc secrets.txt' #else '/usr/share/, /media/mrniz/SD-Card/LizFiles /home/MDC/mdc secrets.txt' #end}' ,reqsONLINE: false};

    public static var WRITE_EXTERNAL_STORAGE:Permission ={name:"Write External Storage", id: 1,description: "Gives permissions to write/remove files from your local disk system.", warn: true, reqsONLINE: false};

    public static var INTERNET:Permission ={name:"Internet Access", id: 2, description: 'Gives permission to access internet!!', warn: true, reqsONLINE: true};

    public static var MODIFY_ENGINE_DATA:Permission = {name: "Modify engine data", id: 3,description: 'Change a lot of the engine, like the base Main class or the the base engine.', warn: true, reqsONLINE: false}; 
    
    public static var NEEDS_DISCORD_DATA:Permission = {name: "Discord", id: 4, description: 'Access to your PUBLIC Discord data (NOTE OF NIZ: This will not make personal data of your account public.)' ,reqsONLINE: false};
    public static var DEFAULT_DISCORD_USER:Class<engine.discord.DefaultUser> =  engine.discord.DefaultUser;

    public static var NEEDS_API_USER:Permission = {name: "App user data", id: 5, description: 'Access to your PUBLIC App data (Like your name). ', reqsONLINE: false};
    public static function getAll() {
    // todo
    }
    public static function init() {
        MODS_PERMS = FlxG.save.data.MODS_PERMS;
        if (MODS_PERMS == null)
            MODS_PERMS = new Map();
    }
    public static function give(perm:Permission, modID:String) {
        var mod = DEFAULT_PERMS.copy();
        if (MODS_PERMS.exists(modID)) mod = MODS_PERMS.get(modID);
        if (!mod.contains(perm)) mod.push(perm);
        MODS_PERMS.set(modID, mod);
        return perm;
    }
    public static function revoke(perm:Permission, modID:String)
    {
        var mod = DEFAULT_PERMS.copy();
        if (MODS_PERMS.exists(modID)) mod = MODS_PERMS.get(modID);

        if (mod.contains(perm) && !DEFAULT_PERMS.contains(perm)) mod.remove(perm);
        MODS_PERMS.set(modID, mod);
        return perm;
    }

    public static function has(perm:Permission, modID:String) {
        //if (perm.reqsONLINE) TODO: Hacerlo
        var mod = DEFAULT_PERMS.copy();
        if (MODS_PERMS.exists(modID))
            mod = MODS_PERMS.get(modID);
        return mod.contains(perm);
    }
}