package utils;

typedef SwagSection =
{
	var sectionNotes:Array<Dynamic>;
	var lengthInSteps:Int;
	var typeOfSection:Int;
	var mustHitSection:Bool;
	var bpm:Float;
	var changeBPM:Bool;
	var altAnim:Bool;
}

typedef Section = {
	var notes:Array<Array<Dynamic>>;
	var bpm:Float;
	var mustHitSection:Bool;
	var changeBPM:Bool;
}