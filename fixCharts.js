const fs = require("fs");
const {readdirSync} = fs;

/**DOnt move it */
class PathsClass {
    constructor() {
        
    }
    dataFrom(key) {
        return  swagPath + "data/" + key
    }
    getChart(key, onread) {
        var path = this.dataFrom('songs/' + key);
        var json = JSON.parse("[\"\"]")

        fs.readFile(path, (err, data) => {
            if (err) throw err;
            
        json = JSON.parse(data.toLocaleString());
        onread(json);
        });
        return json;
    } 
    getCharts(key) {
        /**
         * @type {array}
         */
        var e = readdirSync(this.dataFrom('songs/'+key));
        var songs = [];
        for(let a of e) {
            if (a.endsWith(".json") && a.includes(key))
            songs.push(key+'/'+a);
        }
        return songs;
    }
}

const Paths = new PathsClass();

var swagPath = "./assets/preload/"
var songs = /*[*/readdirSync(Paths.dataFrom("songs/"))//.pop()]
for (let song of songs) {
    var charts =Paths.getCharts(song)// [Paths.getCharts(song).pop()];
    
    for (const chart of charts) {
        Paths.getChart(chart, (data)=> {
        var json = data.song;
     
        if (!json.player2 )
            json.player2 = "dad";
        if (!json.player1)
            json.player1 = "bf";
        
        var curSong = chart.split("/")[0];
        if (!json.stage)
        json.stage = "stage";
        console.log();

        console.log(curSong);
        switch (curSong)
		{
            case 'spookeez' , 'monster' , 'south':
				json.stage = "spooky";
			break;
            case 'pico' , 'blammed' , 'philly':
				json.stage = 'philly';
			break;
            case "milf" , 'satin-panties' , 'high':
				json.stage = 'limo';
			break;
            case "cocoa" , 'eggnog':
				json.stage = 'mall';
			break;
            case 'winter-horrorland':
				json.stage = 'mallEvil';
			break;
            case 'senpai' , 'roses':
				json.stage = 'school';
			break;
            case 'thorns':
			json.stage = 'schoolEvil';
			break;
            case 'guns' , 'stress' , 'ugh':
				json.stage = 'tank';
            break;
			default:
				json.stage = "stage";
            break;
            
		}

        if (!json.player3)
            json.player3 = "gf";
        switch (json.stage)
        {
            case 'limo':
                json.player3 = 'gf-car';     
            break;
            case 'mall' , 'mallEvil':
                json.player3 = 'gf-christmas';
                
            break;
            case 'school' , 'schoolEvil':
                json.player3 = 'gf-pixel';
                
            break;
            case 'tank':
                json.player3 = 'gf-tankmen';
            break;

        }
    
    
        if (curSong == 'stress')
            json.player3 = 'pico-speaker';
        if (curSong == "tutorial")
            json.player3 = "gf";

        if (!json.events )
            json.events = [];
        fs.writeFile(Paths.dataFrom('songs/' + chart), JSON.stringify(data, null, " ").toLocaleString(), (e)=>{
            if (e) console.log(e);
        })

        });

    }

}

