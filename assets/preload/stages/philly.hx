
var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
bg.scrollFactor.set(0.1, 0.1);
add(bg);

var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
city.scrollFactor.set(0.3, 0.3);
city.setGraphicSize(Std.int(city.width * 0.85));
city.updateHitbox();
add(city);

Padre.lightFadeShader = new BuildingShaders();
Padre.phillyCityLights = new FlxTypedGroup<FlxSprite>();

add(Padre.phillyCityLights);

for (i in 0...5)
{
    var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
    light.scrollFactor.set(0.3, 0.3);
    light.visible = false;
    light.setGraphicSize(Std.int(light.width * 0.85));
    light.updateHitbox();
    light.antialiasing = true;
    light.shader = lightFadeShader.shader;
    Padre.phillyCityLights.add(light);
}

var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
add(streetBehind);

Padre.phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
add(phillyTrain);

Padre.trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
FlxG.sound.list.add(trainSound);

var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
add(street);