package api;

import sys.FileSystem;
import api.routes.Mod;
import api.routes.SwagID;
import api.routes.Test;
import api.routes.User;
import api.routes.UserModsSuscribed;

class Iteractor {
    private var cache:Map<String, String> = [];

    private var users:Map<String, User> = [];
    private var mods:Map<String, Mod> = [];

    public static var current:Iteractor;
    public var token(get, set):String;
    
    function get_token():String {
        return 'Nuh uh';
        
    }
    
    function set_token(token:String):String {
        return token;
    }

    public function getUser(ID:String, onFetch:(user:User)->Void) {
        if (users.exists(ID)){
            onFetch(users.get(ID));
            return;
        }
        
        getText('https://api.mdcdev.me/v1/users/482637805034668032',function (data){
            var userData = { // cast data;
                ID: data.id,
                avatarURL: data.avatarURL,
                modsPublished: [],
                name: data.globalName,
                globalName: data.globalName,
                username: data.username,
                tag: data.tag,
            };
            if (!FileSystem.exists("_cache/"))
                FileSystem.createDirectory("_cache/");

            downloadArchive(data.avatarURL, '_cache/local-avatar.png', function(){trace("descargado");});
           /* downloadArchive('https://cdn.discordapp.com/attachments/969730941956280352/1175867699495182366/TestMod.zip?ex=656ccb22&is=655a5622&hm=4ea8c805e804c2f002208e037cb145d23dc56523df9640b872f81dacc1ba119b&',
            "mod.zip",
            function (){trace("moddescargado");}
            );*/
            users.set(ID,userData);
            users.set("local",userData);
            getUser(ID, onFetch); // reCall
        });

        return;
    }
    public function downloadArchive(url:String, path:String, onDownloaded:()->Void) {
        trace("Trying download from " + url);

        var request = new haxe.Http(url);
        request.onError = function(err){
            trace('Download failed:');
            trace(err);
        }
        request.onBytes= function (data) {
            trace("Saving");
            sys.io.File.saveBytes(path, data);
            onDownloaded();
        };
        request.request();
    }
    public function getText(url:String, onData:(data:Dynamic)->Void) {
        /*if (cache.exists(url)) {
            trace("Founded cache");
            onData(Json.parse(cache.get(url)));
        }*/
        var request = new haxe.Http(url);
        request.onData = function (data:String) {
            cache.set(url, data);
            onData(Json.parse(data));
        }
        // ADDHEADERS
        /**
            request.headers.set("token", token)
        **/
        request.request();
    }
    public function new(options:IteractorOptions) {
        current = this;
        cache = new Map();
        token = "test-token";
    }
    public function getModsSuscribed(onData:(data:UserModsSuscribed)->Void) {
        getUser('482637805034668032', (user:User)->{
            onData({ID: user.ID, user: user, mods: []});
        });
        /*return  {
            ID: "482637805034668032",
            user: cast ,
            mods: []
        }*/
    }
}