package translate;

import sys.FileSystem;
using StringTools;
import haxe.Json;
import sys.io.File;
typedef JSON_BASE = {} //THIS WON'T WORK!!

class File {

    public static var rawlangs:Array<String> = [];
    public static var langs:Array<Dynamic> = [];

    public static var LANG = ""; // ENG - default

    private static var defaultValue = "%data%" #if debug + " can't be founded"#end; 

    public static function resync() {
        rawlangs = [];
        var files = FileSystem.readDirectory("./assets/data/game/");

        for (file in files)
            {
                if ((file.startsWith("trans-") ||file.startsWith("translation-"))  || 
                    (file.startsWith("-trans") ||file.startsWith("-translation"))) // With "contains" is better?
                {
                    rawlangs.push(file);
                }

            }
        langs = [];
        var names = [];
        for (lang in rawlangs) {
            var po = Json.parse(sys.io.File.getContent('./assets/data/game/$lang'));
            if (
                po.code != null &&  // Debe de tener código tipo "pt-BR"
                po.name != null &&  // Un nombre visible como "Español (Latino)"
                po.creator != null && // Creador tipo: "Tilin"
                !names.contains(po.name.toLowerCase()) // Y que no se repita la traducción, no queremos repetidas xdxd
                )
                {
                    langs.push(po);
                    names.push(po.name.toLowerCase());
                }
            
        }
    }
}
