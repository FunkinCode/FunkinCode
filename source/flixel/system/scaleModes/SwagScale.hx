package flixel.system.scaleModes;

import flixel.system.scaleModes.BaseScaleMode;


class SwagScale extends BaseScaleMode {
    public static var instance:BaseScaleMode;
    public function new() {
        super();
        instance = this;
    }
    public override function onMeasure(Width:Int, Height:Int) {
	
    }
}