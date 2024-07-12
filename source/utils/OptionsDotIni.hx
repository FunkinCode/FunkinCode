package utils;


class OptionsDotIni {
    static var data:Map<String, Map<String, Dynamic> >  =[]    ;
    public static function init(?input:String = "options.ini") {
        var file =read(input);
        data = [];
        var line = 0;
        var curSection = "default";
        for (i in file.split("\n")) {
            line += 1;
            if (i.startsWith(";")) {

            } else if (i.startsWith("[")) {
                if (!i.endsWith("]"))
                    throw "Missing ] in line " + line + " in char " +  i .length;
                var sec = i.substring(1, i.length -1);
                if (sec.length < 1)
                    throw "Invalid name section in line " + line;
                curSection = sec;
            } else {
                var map =  data.get(curSection);
                if (map == null) map = new Map();

                if (i.contains("=")) {
                    final e = i.split("=");
                    final varName = e.shift();
                    var varValue = e.join("=").split(";").shift();
                    trace(varValue);
                    trace(varName);
                    if (varValue == "undefined" || varValue == "null")
                        varValue = "";
                   
                    if (varValue.startsWith("\"")) { // string
                        if (!varValue.endsWith("\""))
                            throw "Missing end string in line " + line + " at char " + i.length;
              
                        map.set(varName, varValue.substring(1, varValue.length -1));
                    } else if (!Math.isNaN(Std.parseFloat(varValue))) {
                        map.set(varName, Std.parseFloat(varValue));
                    } else {
                        map.set(varName,null);

                    }
                } else {
                    throw "Invalid data parse, expected [SECTION] or var=value in line " + line;
                }

                data.set(curSection, map);

            }
            
        }

    }
    public static function set(varName:String, varValue:Dynamic, inSection="default") {
        var sec= data.get(inSection);
        if (sec == null)
            sec = new Map();
        sec.set(varName,varValue);

        data.set(inSection, sec);
        save();

    }
    public static function get(varName:Dynamic, ?inSection:String ="default") {
        return try {data.get(inSection).get(varName);} catch(err){ null;};
    }
    public static function save(?path:String = "options.ini" ) {
        var curLine = 0;
        var fileEndPoint = "; File format version: 1.0b\n";
        for (key in data.keys()) {
            curLine += 1;
            fileEndPoint += '[${key}]\n';
            for (i in data.get(key).keys()) {
                var preval = '${data.get(key).get(i) != null ? data.get(key).get(i) : "undefined"}';
                if (data.get(key).get(i) is String)
                    preval = '\"${preval}\"';
                fileEndPoint += '${i}=${preval}; Value type: ${Type.getClass(data.get(key).get(i))}\n';
            }

        }
        fileEndPoint += "; created with OptionsDotIni.hx by galleniz";
        sys.io.File.saveContent(path, fileEndPoint);
    }
    static function read(fileName:String) {
        try {
           return sys.io.File.getContent(fileName);
        } catch(e) {
            error(e);
            return '[account]\ntoken="undefined"';
        }
    }
    public static function has(section:String, option:String) {

    }
}