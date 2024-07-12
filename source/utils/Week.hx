package utils;

import sys.FileSystem;
import sys.io.File;


typedef WeekFile = {
    var songs:Array<Dynamic>;
    var hide:Array<Bool>;
    var directory:String;
    var art:String;
    var weekName:String;
}


class Week {
    public static var weeks:Array<WeekFile> = [];
    public static function getWeeks()
    {
        utils.Mods.readMods();
        weeks = [];
        /**
            LOCAL
        **/
        _GetFrom('assets/data', "");
        /**
            FUNKIn
         */
        _GetFrom('funkin/data', "funkin");
        /**
            MODS
        **/
        for (mod in utils.Mods.mods) 
            _GetFrom('mods/$mod/data', mod);
        
       
        return weeks;
    }

    static function _GetFrom(dataPath:String, ?mod:String = "") {
        last_added = [];
        if (FileSystem.exists('${dataPath}/weekList.txt' ))
                _From(dataPath, File.getContent('${dataPath}/weekList.txt').trim().rtrim().replace("\r","").split("\n"), mod);
        if (FileSystem.exists('${dataPath}/weeks') && FileSystem.isDirectory('$dataPath/weeks'))
                _From(dataPath,Paths.readDir('${dataPath}/weeks'), mod);
        
    }
    static var last_added:Array<String> = [];
    static function _From(dataPath:String, weekList:Array<String>, ?mod:String) {
       
        for (week in weekList) {
            weekList[weekList.indexOf(week)] = week.replace(".json", "");

            if (last_added.contains(week))
                weekList.remove(week);

        
        }
        last_added = weekList;

        _ListBy(dataPath, weekList, mod);
    }
    static function _ListBy(dataPath:String, weekList:Array<String>, ?mod:String) {
        for (weekName in weekList) {
    try {
            var week:WeekFile = cast Json.parse(File.getContent('$dataPath/weeks/$weekName.json').trim().rtrim());
            week.directory = mod;
           
            if (!_Has(week)){
                weeks.push(week);
            }
    } catch(e) {}
        }
    }
    static function _Has(week:WeekFile) {
        for (i in weeks)
        {
            if (i.weekName + i.directory == week.weekName +  week.directory)
                return true;
        }
        return false;
    }
}
