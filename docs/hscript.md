# hscript manual!!?!??!

Uhm hola, hoy explicaré en sencillas palabras (o más bien dicho qué contrae) los hscripts...

## Global Variables

| Name | Type | Description |  
| ------ | ------ | ------ | 
| state | Dynamic<FlxState> | Current state on this script |
| CurrentState / "statename" | Class<CurrentState> | Current class state on this script |
| Padre | Dynamic<FlxState> | Current class state on this script |
| run(code) | Void->Bool | this runs script code, like ujm, more script? |
| add(Object) | Void->FlxObject | This add the object u want |
| remove(Object) | Void->FlxObject | This removes the object |
| addBefore(ObjectBase,ObjectLayer) | Void->FlxObject | This adds ObjectBase before ObjectLayer |

### Overrides functions
| Name | Args | Description |  
| ------ | ------ | ------ | 
| update | elapsed | Every frame calls it!
| independementUpdate | elapsed | Every frame calls it + ignore the "persistUpdate"
| create | | This calls when the state is create (OJO: if you add the script after the create state, this code doesn't effect |
| postCreate || This calls when the states is in the last lines (OJO: the same thing of create)|
| destroy | removingMe | when the states is destroying or just deleting the script |
| init | CurrentState, ScriptID, ?curSong | this calls when the script is initing |

Go to [examples](#examples) for more examples
## PlayState variables / Gameplay

| Name | Type | Description |  
| ------ | ------ | ------ | 
| boyfriend | Boyfriend | Player1 mah boi |
| gf | Character | Girlfriend mah boi |
| dad | Character | Player2 mah boi |
| curSong | String | The "current Song" |

# examples
### uhm song script?
```haxe
function init() {
      killCounts = 0;
      stupids = new FlxGroup();

}
function repositionChars() {
  addBefore(stupids, gf);
}
function sectionHit() {
  for (i in 0...FlxG.random.int(5,20)) 
      var stupid = new FlxSprite(FlxG.random.int(1280, -1280));
      stupid.frames = Paths.getSparrowAtlas("stupid_assets");
      stupid.animation.addByPrefix("run", "run");
      stupid.animation.addByPrefix("kill", "kill");
      stupid.animation.play("run")
      stupids.add(stupid);
  }
}
function killSomeOne() {
  var stupid = stupids.members[FlxG.random.int(0, stupids.length -1)]
  if (stupid == null)
    return;
  stupid.animation.play("kill");
  FlxTween.tween(stupid, {alpha: 0}, 1.0, {onComplete: function(twn){
    stupid.kill();
    stupid.destroy();
    stupids.remove(stupid, true);
  }});
}
function beatHit() {
  if (curBeat > 200 && curBeat < 250){
    FlxG.camera.zoom += 0.015;
    camHUD.zoom += 0.015;
  }
}
function update(elapsed) {
  stupids.forEach(function s(stupid) {
    if (stupid.x < 1280 / 2)
      stupid.x += 10;
    else
        stupid.x -= 10;
  });
  if (FlxG.keys.justPressed.H && !controls.RESET) {
        killSomeOne();
  }
}
```
