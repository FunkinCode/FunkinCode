package utils;

class Version {
	public static var funkinVersion:Array<String> =[
			"0",
			"2",
			"8"
	];
	public static var engineVersion:Array<String> = [
		"0",
		"1",
		"b"
	];
	public static function compare(VersionA:Array<String>,VersionB:Array<String>) {
		var yes:Bool = true;
		for (i in 0...VersionB.length) {
			var curA = VersionA[i];
			var curB = VersionB[i];
			if (Math.isNaN(Std.parseInt(curA))) {
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
	public static function toString(versionArray:Array<Stirng>) {
		var text:String = "";
		for (ver in versionArray) {
			if (Math.isNaN(Std.parseInt(ver)))
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