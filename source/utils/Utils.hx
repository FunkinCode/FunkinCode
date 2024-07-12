package utils;

import haxe.PosInfos;
import haxe.Log;

class Utils {
    public static function setup() {
        haxe.Log.trace = info;
        
    }
    public static function joinURL() {
        // TODO:
        
    }
    public static function eval(code:String) {
        try {
        var e = new Script(code);
        e.init();

        e = null;
    } catch(e) {
        trace(e);
    }
    }
    public static function setTimeout(job:()->Void, secs:Float):haxe.Timer {
        if (job == null) return null;

        if (Math.isNaN(secs)) secs = 0.0;

        if (secs <= 0) job();
        return haxe.Timer.delay(job, Math.floor(secs));
    }
    public static function join(...data:String)
    {
        return  data.toArray().join("");
    }
    public static function betterTracer(level:String = "info", v:Dynamic, infos:PosInfos) 
    {
        var r = _betterTracer(level, v, infos);
        Sys.print(r + "\n");
        return r;
    }
    public static function _betterTracer(level:String = "info", v:Dynamic, infos:PosInfos) {
        var str = Std.string(v);
		if (infos == null)
		    return '${setDate(Date.now())}- ${level} - [?.hx:??]: $str';
            
		var pstr = infos.fileName + ":" + infos.lineNumber;
		if (infos != null && infos.customParams != null)
			for (v in infos.customParams)
				str += ", " + Std.string(v);
       // [d/m/y h:m:s - info - [test.hx]: data]
		return '${setDate(Date.now())} - ${level} - [$pstr]: $str';
    }
    public static function info(v:Dynamic, ?infos:PosInfos) {
        formatOutput(v, infos);
    }
    public static function warn(v:Dynamic, ?infos:PosInfos) {
        betterTracer("warn", v, infos);
    }
    public static function error(v:Dynamic, ?infos:PosInfos) {
        betterTracer("error", v, infos);
    }

	public static function formatOutput(v:Dynamic, infos:PosInfos):String {
		return betterTracer("info",v, infos);
	}
    public static function setDate(date:Date):String {
        
        return (date.getDay() +1)  
        + "/" + (date.getMonth() +1)
        + "/" + (date.getFullYear())
        + " " + (Math.floor((date.getHours() + 1) % 12))
        + ":" + (Math.floor((date.getMinutes() + 1) % 60))
        + ":" + (Math.floor((date.getSeconds() + 1) % 60));
    }
}