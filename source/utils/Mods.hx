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
    var author:String;
    var needsRestartWhenLoading:Bool;
    var useASGlobal:Bool;
    var canCheat:Bool;
}

class Mods {
    public static var mods:Array<String> = [];
    public static var directory = {type: "dir", content: null};
    public static var file = {type: "file", content: ""};
    

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
            mods = [];
            if (!FileSystem.exists("mods"))
                FileSystem.createDirectory("mods");

            var mdos  = FileSystem.readDirectory("mods");
            trace(mdos);
            for (mod in mdos ) {
                var mod_path = 'mods/$mod';
                trace(mod_path);
                if (FileSystem.exists(mod_path) && FileSystem.isDirectory(mod_path)) {
                    if (FileSystem.exists('$mod_path/pack.json'))
                        {
                            trace('Tracked mod in $mod_path!');
                            mods.push(mod);
                        }
                }
            }
        }
    
    public static function getWeeks()
    {
        return Week.getWeeks();
    }
    public static function createMod(name = "test") {
        var mod_path = 'mods/$name';
        readMods();
        if (FileSystem.exists(mod_path))
            {
                if (FileSystem.isDirectory(mod_path))
                    FileSystem.deleteDirectory(mod_path);
                else 
                    FileSystem.deleteFile(mod_path);

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