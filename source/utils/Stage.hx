package utils;

typedef SwagStage = {

    var levelID:String;
    var details:Bool;
    
    var positions:Array<SwagPosition>;
    var zoom:Float;
    var cameraSpeed:Float;
}
typedef SwagPosition = {
    var name:String;
    var x:Float;
    var y:Float;
    var camera_x:Float;
    var camera_y:Float;
}
class Stage {
    public static function defaultStage():SwagStage {
        return {
            levelID: "stage",// for discord presence
            details: false,
            positions: [
                {
                    name: "dad",
                    x: 0,
                    y: 0,
                    camera_x: 0,
                    camera_y: 0,
                },
                {
                    name: "boyfriend",
                    x: 0,
                    y: 0,
                    camera_x: 0,
                    camera_y: 0,
                },
                {
                    name: "gf",
                    x: 0,
                    y: 0,
                    camera_x: 0,
                    camera_y: 0,
                }
            ],
            zoom: 1.05,
            cameraSpeed: 1.0,
        };
    }   
    public static function loadFromJSON():SwagStage {
        var stage = defaultStage();
        var path = Paths.getDataPath() + 'stages/' + PlayState.curStage + ".json";
        if (Paths.exists(path, TEXT)) {
            var raw = Paths.text(path);
            stage = cast Json.parse(raw);
        }
        if (stage == null)
            stage= defaultStage();
        return stage;
    }
}