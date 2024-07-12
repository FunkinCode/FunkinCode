package utils;

class Version {
	/**
	 * 
	 * 	todo: local versions
	 */
	public static var funkinVersion:Array<String> =[
			"0",
			"2",
			"8"
	];
	/**
	 *	What if this works? 
	 *
	 */
	public static function display() {
		return 'FunkinCode v' + getEngineVer() 
		+ '\n' +'Funkin v' + getGameVer() 
		+ '\n' + getCurModGlobalLoadedVer();
	}
	public static function getCurModGlobalLoadedVer(){
		return 'Nothing v0.0.1';
	}
	public static var engineVersion:Array<String> = [
		"0",
		"1",
		"b"
	];
	static var numbers:String ="123456789";
	public static function getEngineVer() {
		return toString(engineVersion) + (compare(engineVersion, /**onlineVer.engine**/ engineVersion) ? "(STABLE)" : "(OUTDATED)");
	}
	public static function getGameVer() {
		return toString(funkinVersion) + (compare(funkinVersion, /**onlineVer.funkin**/ funkinVersion) ? "(STABLE)" : "(OUTDATED)");
	}

	public static function compare(VersionA:Array<String>,VersionB:Array<String>) {
		var yes:Bool = true;
		for (i in 0...VersionB.length) {
			var curA = VersionA[i];
			var curB = VersionB[i];
			if (!numbers.contains(curA)) {
				if (curA == "a" && curB == "b")
					yes = false;
				if (curA == "r" && curA == "b")
					yes = false;
			} else {
				if (Std.parseInt(curA)< Std.parseInt(curB))
					yes = false;
			}

		}
		return yes;
	}
	/*
		Yeah uhm
	*/
	public static function toString(versionArray:Array<String>) {
		var text:String = "";
		for (ver in versionArray) {
			if (!numbers.contains(ver))
				text += ver;
			else
				text += '.$ver'; // weirdo stuff
		}
		if (text.startsWith("."))
		{
		 	var dotShit = text.split("" /*"."*/);
		 	dotShit.shift();
		 	text = dotShit.join("");
		}
		return text;
	}
}