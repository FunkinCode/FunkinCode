var long = `
case "gf-christmas":

tex = Paths.getSparrowAtlas("characters/gfChristmas");
frames = tex;

quickAnimAdd("cheer", "GF Cheer");
quickAnimAdd("singLEFT", "GF left note");
quickAnimAdd("singRIGHT", "GF Right Note");
quickAnimAdd("singUP", "GF Up Note");
quickAnimAdd("singDOWN", "GF Down Note");
animation.addByIndices("sad", "gf sad", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
animation.addByIndices("danceLeft", "GF Dancing Beat", [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
animation.addByIndices("danceRight", "GF Dancing Beat", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
animation.addByIndices("hairBlow", "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
animation.addByIndices("hairFall", "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
animation.addByPrefix("scared", "GF FEAR", 24, true);

loadOffsetFile(curCharacter);

playAnim("danceRight");
end
case "gf-tankmen":
frames = Paths.getSparrowAtlas("characters/gfTankmen");
animation.addByIndices("sad", "GF Crying at Gunpoint", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, true);
animation.addByIndices("danceLeft", "GF Dancing at Gunpoint", [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
animation.addByIndices("danceRight", "GF Dancing at Gunpoint", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

loadOffsetFile("gf");
playAnim("danceRight");

end
case "bf-holding-gf":
frames = Paths.getSparrowAtlas("characters/bfAndGF");
quickAnimAdd("idle", "BF idle dance");
quickAnimAdd("singDOWN", "BF NOTE DOWN0");
quickAnimAdd("singLEFT", "BF NOTE LEFT0");
quickAnimAdd("singRIGHT", "BF NOTE RIGHT0");
quickAnimAdd("singUP", "BF NOTE UP0");

quickAnimAdd("singDOWNmiss", "BF NOTE DOWN MISS");
quickAnimAdd("singLEFTmiss", "BF NOTE LEFT MISS");
quickAnimAdd("singRIGHTmiss", "BF NOTE RIGHT MISS");
quickAnimAdd("singUPmiss", "BF NOTE UP MISS");
quickAnimAdd("bfCatch", "BF catches GF");

loadOffsetFile(curCharacter);

playAnim("idle");

flipX = true;

end
case "gf-car":
tex = Paths.getSparrowAtlas("characters/gfCar");
frames = tex;
animation.addByIndices("singUP", "GF Dancing Beat Hair blowing CAR", [0], "", 24, false);
animation.addByIndices("danceLeft", "GF Dancing Beat Hair blowing CAR", [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
animation.addByIndices("danceRight", "GF Dancing Beat Hair blowing CAR", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
false);
animation.addByIndices("idleHair", "GF Dancing Beat Hair blowing CAR", [10, 11, 12, 25, 26, 27], "", 24, true);

loadOffsetFile(curCharacter);

playAnim("danceRight");

end
case "gf-pixel":
tex = Paths.getSparrowAtlas("characters/gfPixel");
frames = tex;
animation.addByIndices("singUP", "GF IDLE", [2], "", 24, false);
animation.addByIndices("danceLeft", "GF IDLE", [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
animation.addByIndices("danceRight", "GF IDLE", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

loadOffsetFile(curCharacter);

playAnim("danceRight");

setGraphicSize(Std.int(width * PlayState.daPixelZoom));
updateHitbox();
antialiasing = false;

end
case "dad":
// DAD ANIMATION LOADING CODE
tex = Paths.getSparrowAtlas("characters/DADDY_DEAREST");
frames = tex;
quickAnimAdd("idle", "Dad idle dance");
quickAnimAdd("singUP", "Dad Sing Note UP");
quickAnimAdd("singRIGHT", "Dad Sing Note RIGHT");
quickAnimAdd("singDOWN", "Dad Sing Note DOWN");
quickAnimAdd("singLEFT", "Dad Sing Note LEFT");

loadOffsetFile(curCharacter);

playAnim("idle");
end
case "spooky":
tex = Paths.getSparrowAtlas("characters/spooky_kids_assets");
frames = tex;
danceSpeed = 1;
quickAnimAdd("singUP", "spooky UP NOTE");
quickAnimAdd("singDOWN", "spooky DOWN note");
quickAnimAdd("singLEFT", "note sing left");
quickAnimAdd("singRIGHT", "spooky sing right");
animation.addByIndices("danceLeft", "spooky dance idle", [0, 2, 6], "", 12, false);
animation.addByIndices("danceRight", "spooky dance idle", [8, 10, 12, 14], "", 12, false);

loadOffsetFile(curCharacter);

playAnim("danceRight");
end
case "mom":
tex = Paths.getSparrowAtlas("characters/Mom_Assets");
frames = tex;

quickAnimAdd("idle", "Mom Idle");
quickAnimAdd("singUP", "Mom Up Pose");
quickAnimAdd("singDOWN", "MOM DOWN POSE");
quickAnimAdd("singLEFT", "Mom Left Pose");
// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
// CUZ DAVE IS DUMB!
quickAnimAdd("singRIGHT", "Mom Pose Left");

loadOffsetFile(curCharacter);

playAnim("idle");

end
case "mom-car":
tex = Paths.getSparrowAtlas("characters/momCar");
frames = tex;

quickAnimAdd("idle", "Mom Idle");
quickAnimAdd("singUP", "Mom Up Pose");
quickAnimAdd("singDOWN", "MOM DOWN POSE");
quickAnimAdd("singLEFT", "Mom Left Pose");
// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
// CUZ DAVE IS DUMB!
quickAnimAdd("singRIGHT", "Mom Pose Left");
animation.addByIndices("idleHair", "Mom Idle", [10, 11, 12, 13], "", 24, true);

loadOffsetFile(curCharacter);

playAnim("idle");
end
case "monster":
tex = Paths.getSparrowAtlas("characters/Monster_Assets");
frames = tex;
quickAnimAdd("idle", "monster idle");
quickAnimAdd("singUP", "monster up note");
quickAnimAdd("singDOWN", "monster down");
quickAnimAdd("singLEFT", "Monster left note");
quickAnimAdd("singRIGHT", "Monster Right note");

loadOffsetFile(curCharacter);

playAnim("idle");
end
case "monster-christmas":
tex = Paths.getSparrowAtlas("characters/monsterChristmas");
frames = tex;
quickAnimAdd("idle", "monster idle");
quickAnimAdd("singUP", "monster up note");
quickAnimAdd("singDOWN", "monster down");
quickAnimAdd("singLEFT", "Monster left note");
quickAnimAdd("singRIGHT", "Monster Right note");

loadOffsetFile(curCharacter);

playAnim("idle");
end
case "pico":
tex = Paths.getSparrowAtlas("characters/Pico_FNF_assetss");
frames = tex;
quickAnimAdd("idle", "Pico Idle Dance");
quickAnimAdd("singUP", "pico Up note0");
quickAnimAdd("singDOWN", "Pico Down Note0");
if (isPlayer)
{
quickAnimAdd("singLEFT", "Pico NOTE LEFT0");
quickAnimAdd("singRIGHT", "Pico Note Right0");
quickAnimAdd("singRIGHTmiss", "Pico Note Right Miss");
quickAnimAdd("singLEFTmiss", "Pico NOTE LEFT miss");
}
else
{
// Need to be flipped! REDO THIS LATER!
quickAnimAdd("singLEFT", "Pico Note Right0");
quickAnimAdd("singRIGHT", "Pico NOTE LEFT0");
quickAnimAdd("singRIGHTmiss", "Pico NOTE LEFT miss");
quickAnimAdd("singLEFTmiss", "Pico Note Right Miss");
}

quickAnimAdd("singUPmiss", "pico Up note miss");
quickAnimAdd("singDOWNmiss", "Pico Down Note MISS");

loadOffsetFile(curCharacter);

playAnim("idle");

flipX = true;

end
case "pico-speaker":
frames = Paths.getSparrowAtlas("characters/picoSpeaker");

quickAnimAdd("shoot1", "Pico shoot 1");
quickAnimAdd("shoot2", "Pico shoot 2");
quickAnimAdd("shoot3", "Pico shoot 3");
quickAnimAdd("shoot4", "Pico shoot 4");

// here for now, will be replaced later for less copypaste
loadOffsetFile(curCharacter);
playAnim("shoot1");

loadMappedAnims();

end
case "bf":
var tex = Paths.getSparrowAtlas("characters/BOYFRIEND");
frames = tex;
quickAnimAdd("idle", "BF idle dance");
quickAnimAdd("singUP", "BF NOTE UP0");
quickAnimAdd("singLEFT", "BF NOTE LEFT0");
quickAnimAdd("singRIGHT", "BF NOTE RIGHT0");
quickAnimAdd("singDOWN", "BF NOTE DOWN0");
quickAnimAdd("singUPmiss", "BF NOTE UP MISS");
quickAnimAdd("singLEFTmiss", "BF NOTE LEFT MISS");
quickAnimAdd("singRIGHTmiss", "BF NOTE RIGHT MISS");
quickAnimAdd("singDOWNmiss", "BF NOTE DOWN MISS");
quickAnimAdd("hey", "BF HEY");

quickAnimAdd("firstDeath", "BF dies");
animation.addByPrefix("deathLoop", "BF Dead Loop", 24, true);
quickAnimAdd("deathConfirm", "BF Dead confirm");

animation.addByPrefix("scared", "BF idle shaking", 24, true);

loadOffsetFile(curCharacter);

playAnim("idle");

flipX = true;

loadOffsetFile(curCharacter);

end
case "bf-christmas":
var tex = Paths.getSparrowAtlas("characters/bfChristmas");
frames = tex;
quickAnimAdd("idle", "BF idle dance");
quickAnimAdd("singUP", "BF NOTE UP0");
quickAnimAdd("singLEFT", "BF NOTE LEFT0");
quickAnimAdd("singRIGHT", "BF NOTE RIGHT0");
quickAnimAdd("singDOWN", "BF NOTE DOWN0");
quickAnimAdd("singUPmiss", "BF NOTE UP MISS");
quickAnimAdd("singLEFTmiss", "BF NOTE LEFT MISS");
quickAnimAdd("singRIGHTmiss", "BF NOTE RIGHT MISS");
quickAnimAdd("singDOWNmiss", "BF NOTE DOWN MISS");
quickAnimAdd("hey", "BF HEY");

loadOffsetFile(curCharacter);

playAnim("idle");

flipX = true;
end
case "bf-car":
var tex = Paths.getSparrowAtlas("characters/bfCar");
frames = tex;
quickAnimAdd("idle", "BF idle dance");
quickAnimAdd("singUP", "BF NOTE UP0");
quickAnimAdd("singLEFT", "BF NOTE LEFT0");
quickAnimAdd("singRIGHT", "BF NOTE RIGHT0");
quickAnimAdd("singDOWN", "BF NOTE DOWN0");
quickAnimAdd("singUPmiss", "BF NOTE UP MISS");
quickAnimAdd("singLEFTmiss", "BF NOTE LEFT MISS");
quickAnimAdd("singRIGHTmiss", "BF NOTE RIGHT MISS");
quickAnimAdd("singDOWNmiss", "BF NOTE DOWN MISS");
animation.addByIndices("idleHair", "BF idle dance", [10, 11, 12, 13], "", 24, true);

loadOffsetFile(curCharacter);

playAnim("idle");

flipX = true;
end
case "bf-pixel":
frames = Paths.getSparrowAtlas("characters/bfPixel");
quickAnimAdd("idle", "BF IDLE");
quickAnimAdd("singUP", "BF UP NOTE");
quickAnimAdd("singLEFT", "BF LEFT NOTE");
quickAnimAdd("singRIGHT", "BF RIGHT NOTE");
quickAnimAdd("singDOWN", "BF DOWN NOTE");
quickAnimAdd("singUPmiss", "BF UP MISS");
quickAnimAdd("singLEFTmiss", "BF LEFT MISS");
quickAnimAdd("singRIGHTmiss", "BF RIGHT MISS");
quickAnimAdd("singDOWNmiss", "BF DOWN MISS");

loadOffsetFile(curCharacter);

scale = 6
updateHitbox();

playAnim("idle");

width -= 100;
height -= 100;

antialiasing = false;

flipX = true;
end
case "bf-pixel-dead":
frames = Paths.getSparrowAtlas("characters/bfPixelsDEAD");
quickAnimAdd("singUP", "BF Dies pixel");
quickAnimAdd("firstDeath", "BF Dies pixel");
animation.addByPrefix("deathLoop", "Retry Loop", 24, true);
quickAnimAdd("deathConfirm", "RETRY CONFIRM");
animation.play("firstDeath");

loadOffsetFile(curCharacter);

playAnim("firstDeath");
// pixel bullshit
scale = 6
updateHitbox();
antialiasing = false;
flipX = true;

end
case "bf-holding-gf-dead":
frames = Paths.getSparrowAtlas("characters/bfHoldingGF-DEAD");
quickAnimAdd("singUP", "BF Dead with GF Loop");
quickAnimAdd("firstDeath", "BF Dies with GF");
animation.addByPrefix("deathLoop", "BF Dead with GF Loop", 24, true);
quickAnimAdd("deathConfirm", "RETRY confirm holding gf");

loadOffsetFile(curCharacter);

playAnim("firstDeath");

flipX = true;

end
case "senpai":
frames = Paths.getSparrowAtlas("characters/senpai");
quickAnimAdd("idle", "Senpai Idle");
// at framerate 16.8 animation plays over 2 beats at 144bpm,
// but if the game lags or the bpm is > 144 (mods etc.)
// he may miss his next dance
// animation.getByName("idle").frameRate = 16.8;

quickAnimAdd("singUP", "SENPAI UP NOTE");
quickAnimAdd("singLEFT", "SENPAI LEFT NOTE");
quickAnimAdd("singRIGHT", "SENPAI RIGHT NOTE");
quickAnimAdd("singDOWN", "SENPAI DOWN NOTE");

loadOffsetFile(curCharacter);

playAnim("idle");

scale = 6
updateHitbox();

antialiasing = false;
end
case "senpai-angry":
frames = Paths.getSparrowAtlas("characters/senpai");
quickAnimAdd("idle", "Angry Senpai Idle");
quickAnimAdd("singUP", "Angry Senpai UP NOTE");
quickAnimAdd("singLEFT", "Angry Senpai LEFT NOTE");
quickAnimAdd("singRIGHT", "Angry Senpai RIGHT NOTE");
quickAnimAdd("singDOWN", "Angry Senpai DOWN NOTE");

loadOffsetFile(curCharacter);

playAnim("idle");

scale = 6
updateHitbox();

antialiasing = false;

end
case "spirit":
frames = Paths.getPackerAtlas("characters/spirit");
quickAnimAdd("idle", "idle spirit_");
quickAnimAdd("singUP", "up_");
quickAnimAdd("singRIGHT", "right_");
quickAnimAdd("singLEFT", "left_");
quickAnimAdd("singDOWN", "spirit down_");

loadOffsetFile(curCharacter);

scale = 6
updateHitbox();

playAnim("idle");

antialiasing = false;

end
case "parents-christmas":
frames = Paths.getSparrowAtlas("characters/mom_dad_christmas_assets");
quickAnimAdd("idle", "Parent Christmas Idle");
quickAnimAdd("singUP", "Parent Up Note Dad");
quickAnimAdd("singDOWN", "Parent Down Note Dad");
quickAnimAdd("singLEFT", "Parent Left Note Dad");
quickAnimAdd("singRIGHT", "Parent Right Note Dad");

quickAnimAdd("singUP-alt", "Parent Up Note Mom");

quickAnimAdd("singDOWN-alt", "Parent Down Note Mom");
quickAnimAdd("singLEFT-alt", "Parent Left Note Mom");
quickAnimAdd("singRIGHT-alt", "Parent Right Note Mom");

loadOffsetFile(curCharacter);

playAnim("idle");
end
case "tankman":
frames = Paths.getSparrowAtlas("characters/tankmanCaptain");

quickAnimAdd("idle", "Tankman Idle Dance");

if (isPlayer)
{
quickAnimAdd("singLEFT", "Tankman Note Left ");
quickAnimAdd("singRIGHT", "Tankman Right Note ");
quickAnimAdd("singLEFTmiss", "Tankman Note Left MISS");
quickAnimAdd("singRIGHTmiss", "Tankman Right Note MISS");
}
else
{
// Need to be flipped! REDO THIS LATER
quickAnimAdd("singLEFT", "Tankman Right Note ");
quickAnimAdd("singRIGHT", "Tankman Note Left ");
quickAnimAdd("singLEFTmiss", "Tankman Right Note MISS");
quickAnimAdd("singRIGHTmiss", "Tankman Note Left MISS");
}

quickAnimAdd("singUP", "Tankman UP note ");
quickAnimAdd("singDOWN", "Tankman DOWN note ");
quickAnimAdd("singUPmiss", "Tankman UP note MISS");
quickAnimAdd("singDOWNmiss", "Tankman DOWN note MISS");

// PRETTY GOOD tankman
// TANKMAN UGH instanc

quickAnimAdd("singDOWN-alt", "PRETTY GOOD");
quickAnimAdd("singUP-alt", "TANKMAN UGH");

loadOffsetFile(curCharacter);

playAnim("idle");

flipX = true;
end

}
`

var l = long.split("\n");
var curChar = {
    "image": "characters/Dummy",
    "icon": "face",
    "animations": [],
    "scale": [],
    "color" : [],
    "danceSpeed": 2,
    "healthColor": [0,0,0],

    "flipX": false,
    "antialiasing": true,
    "flipY": false

}
const fs = require("fs");
var cases = 0;
var hasAAnim = false;
l.forEach(line=> {
    if (line.startsWith("end")) {
        fs.writeFile("./assets/preload/data/characters/" + curChar.icon + ".json", JSON.stringify(curChar, null, " "), (err)=>{
            if (err) throw err;
        })
    }
    if (line.startsWith("case")){
        line = line.split("case")[1].trim().split(":")[0].replaceAll("\"", "");

        if (hasAAnim) {
        
            
        } 
        hasAAnim = true;

        curChar = {
            "image": "characters/Dummy",
            "icon": "face",
            "animations": [],
            "scale": [],
            "color" : [],
            "danceSpeed": 2,
            "healthColor": [0,0,0],
        
            "flipX": false,
            "antialiasing": true,
            "flipY": false
        
        }
        curChar.icon = line;
        cases += 1;
    }
    line = line.trim();
    // image;
    if (line.includes("scale") ) {
        var scale = Number(line.split('=')[1].trim());
        curChar.scale =[scale,scale]
    }
    if (line.includes("flipX") ) {
        var scale = line.split('=')[1].trim() === "true;";
        curChar.flipX =scale;
    }
    
    if ((line.startsWith("txt") || line.startsWith('frames') || line.includes("Paths.get")) && line.endsWith(");"))
        {
            line = line.split('=')[1].trim();
            cases -=1;
            

            if (line.startsWith("Paths")) {
                line = line.replace("Paths.","");

                if (line.startsWith("getSparrow")) {

                    line = line.split("getSparrowAtlas(\"")[1].trim();
                    line = line.split("\");")[0].trim();
                    curChar.image = line;


                } else {
                    line = line.split("getPackerAtlas(\"")[1].trim();
                    line = line.split("\");")[0].trim();
                    curChar.image = line;

                }
            }
        
        }
    //  anims
    if (line.startsWith('quickAnimAdd')) {
        line = line.split("quickAnimAdd(")[1];
        line = line.split(");")[0];
        var anin = [];
        for (let e of line.split(",")) {
            e = e.trim();
            var o = e.split("");
            o.shift();
            o.pop();
            o = o.join("");
            anin.push(o);
         
        }
         curChar.animations.push(   {
                name: anin[0],
                prefix: anin[1],
                FPS: 24.0,
                nextAnimation: "",
                indices: [],
                loop: false,
                offsets: [],
                animationLength: 4,
        });

    }
    if (line.startsWith("animation")) {
        line = line.split("animation.")[1];
        if (line.startsWith("addBy"))
        {
            line = line.replaceAll("addByPrefix","").replaceAll("addByIndices","").replaceAll("(","").replaceAll(");","");
            var args = [];
            var indices = [];
            var inIndices = false;
            for (let e of line.split(",")) {
                e = e.trim();

                if (e.startsWith("\"")){
                    let o = e.split("");
                
                    o.shift();
                    o.pop();
                    o = o.join("");
                    if (o.length> 0)
                    args.push(o);
                }

                if (e.startsWith("[")) {
                    inIndices = true;
                    indices.push(Number(e.split("[")[1]))

                } else

                if (e.endsWith("]")) {
                    indices.push(Number(e.split("]")[0]))
                    args.push(indices)
                    inIndices = false;

                } else 
                if (Number(e) ){
                    (inIndices === false ? args : indices).push(Number(e))
                } else if (e.startsWith("true") || e.startsWith("false")) {
                        args.push(e==="true");

                }
             
            }
            if (args.length < 5) {
                curChar.animations.push(   {
                    name: args[0],
                    prefix: args[1],
                    FPS: args[3],
                    nextAnimation: "",
                    indices: [],
                    loop: args[4],
                    offsets: [],
                    animationLength: 4,
            });
            } else {
                console.log(args)
                curChar.animations.push(   {
                    name: args[0],
                    prefix: args[1],
                    FPS: args[3],
                    nextAnimation: "",
                    indices: args[2],
                    loop: args[4],
                    offsets: [],
                    animationLength: 4,
            });
            }

        }
    }
})
console.log(cases);
