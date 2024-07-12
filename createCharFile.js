var long = ``

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
