package utils;

import utils.Week.WeekFile;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;
typedef ModsPack = {
    var name:String;
    var description:String;
    var ver:String;
    var repo:String;
    var priority:Int;
    var ?dir:String;
    var author:String;
    var needsRestartWhenLoading:Bool;
    var useASGlobal:Bool;
    var canCheat:Bool;
    var overrideMod:Bool;
}

class Mods {
    public static var mods:Array<String> = [];
    public static var directory = {type: "dir", content: null};
    public static var file = {type: "file", content: ""};
    public static var enabledMods:Map<String, Bool> = [];
    public static var overrideMods:Array<String> = [];
    private static var _BaseMod:Map<String, {type:String, content:String}> = [
        /**
            Dirs
        **/
        "music" => directory,
        "sounds" => directory,
        "songs" => directory,
        "data"=> directory,
        "data/weeks"=> directory,
        "data/source"=> directory,
        "data/characters"=> directory,
        "data/songs"=> directory,
        "data/stages"=> directory,
        "data/arrows"=> directory,
        "images"=> directory,
        "images/characters"=> directory,
        "images/icons"=> directory,
        "images/arrows"=> directory,
        "images/stages"=> directory,
        "fonts"=> directory,
        /**
            FILES
        **/
        "data/weekList.txt" => file,
        "data/characterList.txt" => file,
        "data/stageList.txt" => file,
        "data/global-script.hscript" => {type: "file",
        content:
            'function create(){
                trace("hai hai");
            }'
        },

        "data/data_goes_here.txt" => file,
        "music/music_goes_here.txt" => file,
        "sounds/sounds_goes_here.txt" => file,
        "images/images_goes_here.txt" => file,
        "fonts/fonts_goes_here.txt" => file
    ];

    public static function readMods()
        {
            mods = getModsByFile();
            overrideMods = [];
            if (!FileSystem.exists('debugMod'))
                createMod("debugMod", '');
            if (!FileSystem.exists('funkin'))
                createMod("funkin", '');
            if (!FileSystem.exists('assets')) // wEIRD. 
                createMod("assets", '');
            if (!FileSystem.exists("mods"))
                FileSystem.createDirectory("mods");

            var mdos  = Paths.readDir("mods");
            trace(mdos);
            for (mod in mdos ) {
                var mod_path = 'mods/$mod';
                if (FileSystem.exists(mod_path) && FileSystem.isDirectory(mod_path)) {
                    if (FileSystem.exists('$mod_path/pack.json') && !mods.contains(mod))
                        {
                            trace('Tracked mod in $mod_path!');
                            mods.push(mod);
                            var modData = Json.parse(File.getContent('$mod_path/pack.json'));
                            modData.dir = mod;
                            if (modData.overrideMod || modData.useASGlobal)
                                overrideMods.push(mod);
                        }
                }
            }
            for (i in mods)
            {
                if (!FileSystem.exists('mods/$i') || i.length < 1)
                    mods.remove(i);
            }
            importEnabled();

            saveFile();

        }
    public static function moveMod(from:Int, to:Int){
        var oldMod1 = mods[from];
        var oldMod0 = mods[to];

        mods[from] = oldMod0;
        mods[to] = oldMod1;
        saveFile();
    }
    public static function getModsByFile() {
        if (!FileSystem.exists("mods/modList.txt")) 
            return [];
        var files = File.getContent('mods/modList.txt').split("\n");
        var data = [];
        for ( file in files) {
            data.push(file.split("|")[0]);
        }
        return data;
    }
     public static function importEnabled() {
        if (!FileSystem.exists("mods/modList.txt")) 
            return [];
        var files = File.getContent('mods/modList.txt').split("\n");
        var data = [];
        for ( file in files) {
            var xd = file.split("|");
        enabledMods.set(xd[0], (xd[1] == "null" ? true : (xd[1] == "true" || xd[1] == "1" ||xd[1] == "si")));

        }
        return data;
    }
    public static function getWeeks()
    {
        return Week.getWeeks();
    }
    public static function toggleMod(modPath:String) {
        enabledMods.set(modPath,!isEnabled(modPath));
    }
    public static function getCurMods() {
        var a = [getMetaData('funkin', 'funkin')];
        return a;
    }
    public static function getMetaData(path:String, mod:String):ModsPack {
        var modData:ModsPack = cast Json.parse(File.getContent(path));
        modData.dir = mod;
        return modData;
    }
    public static function isEnabled(modPath:String ) {
        if (!enabledMods.exists(modPath))
            enabledMods.set(modPath, true);
        return enabledMods[modPath];

    }
    public static function saveFile(?save = true) {
        if (!FileSystem.exists("mods/modList.txt")) 
            File.saveContent("mods/modList.txt", "loading...");
        var content = [];
        for (i in mods) {
            content.push(i + "|" + isEnabled(i));
        }
        File.saveContent('mods/modList.txt', content.join("\n"));
    }
    static var sessionModsCreated:Array<String> = [];
    public static function createMod(name = "test", ?customPath:String = "mods/") {
        var mod_path = '$customPath$name';
        trace(mod_path);
        sessionModsCreated.push(mod_path);
        if (FileSystem.exists(mod_path))
            {
                FlxG.log.add("Hey, the mod " + mod_path + " already exists!!!, redo this later!.");
             return;

            }
        FileSystem.createDirectory(mod_path);
        var pack:ModsPack = {
            name: name,
            description: '$name\'s description',
            ver: "1.0",
            repo: "",
            priority: 0,
            author: "No name",
            needsRestartWhenLoading: false,
            useASGlobal: false,
            canCheat: true,
            "overrideMod": false // this isn't the same of "useASGlobal" <- this one is a pref

        };
        _BaseMod.set("pack.json", {type: "file", content: Json.stringify(pack, null, " ")});
        // no preguten, no le muevan.
        _BaseMod.set("raw.data", {type: "file", content: 'createdwith:fridaycodefunkinreworkedbetasys0.1b=>${name}\'sfilehas${Date.now().toString()}foreachfilehasID;idcv012;fnfcode'});


 
        for (key in  _BaseMod.keys() ){
            var data = _BaseMod.get(key);
            switch(data.type)
            {
       
                case "folder", "dir", "directory":
                    trace('Crating key ' + '${mod_path}/${key}');
                    FileSystem.createDirectory('${mod_path}/${key}');
            }
        }

        for (key in  _BaseMod.keys() ){
            var data = _BaseMod.get(key);
            switch(data.type)
            {
                case "file" | "archivo":
                    trace('Crating key ' + '${mod_path}/${key}');
                    trace(data.content);
                    File.saveContent('${mod_path}/${key}', data.content);
     
            }
        }
        readMods();

    }

}