package api;

import sys.Unzipper;
import sys.FileSystem;
import api.routes.Mod;
import api.routes.SwagID;
import api.routes.Test;
import api.routes.User;
import api.routes.UserModsSuscribed;

class Iteractor {
    private var cache:Map<String, String> = [];

    public var API_BASE_URL:String = "https://8328-179-6-170-170.ngrok-free.app/api/v1";

    private var users:SwagArray<User>;

    private var mods:Map<String, Mod> = [];

    public static var current:Iteractor;
    public var token(get, set):String;
    
    function get_token():String {
        return 'Nuh uh';
        
    }
    
    function set_token(token:String):String {
        return token;
    }
    public function getAPIURL(_key:String) {
        return API_BASE_URL + _key;
    }
    public function getLocalUser(onFetch:(user:User)->Void) {
        trace("TRyin");
        return getUser('482637805034668032', onFetch);
    }
    public function getUser(ID:String, onFetch:(user:Null<User>)->Void) {
        trace('trying to download user ' + ID);
        if (users.exists(ID)){
            onFetch(users.getFirst(ID));
            return;
        }
        
        getText('https://api.mdcdev.me/v1/users/${ID}',function (data){
            trace(data.code == 11001 );
            if (data.code == 11001 )
                {
                    data = null;
                    error('The user ${ID} doesn\'t exists on disord');
                
                    return;
                }
            var userData = { // cast data;
                ID: null,
                AvatarURL: data.avatarURL,
                DisplayUsername: data.globalName,
                Username: data.username,
                DiscordID: data.id,
                Flags: -1,
                CreatedAt: null,
                LastUpdated: null,
                Private: false,
            };

            if (!FileSystem.exists("_cache/"))
                FileSystem.createDirectory("_cache/");
            if (Paths.exists('./_cache/avatars/${data.id}.png', IMAGE))
            downloadArchive(data.avatarURL, '_cache/avatars/${data.id}.png', ()->{trace('Avatar from ${ID} was downloaded');});
            trace("downloaded");
            users.set(ID,userData);
            info( haxe.Json.stringify(users.toJSON()));
            sys.io.File.saveContent('_cache/_users.json', haxe.Json.stringify(users.toJSON()));
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
        users = new SwagArray<User>();
        current = this;
        cache = new Map();
        token = "test-token";
        try {
        users = Json.parse('_cache/_users.json');
        } catch(e) {error(e);}
    }
    public function getMod(mod:String, onData:(data:Mod)->Void) {
        getText(getAPIURL('/mod/$mod/'), function a(data) {
            var mod:Mod = cast data;
            onData(mod);
            
            trace(mod.author.AvatarURL);
            trace(mod.downloadLink);
            if (!FileSystem.exists("_cache/"))
                FileSystem.createDirectory("_cache/");
            downloadArchive(mod.author.AvatarURL, "_cache/avatar-2.png", ()->trace("Se descargó papu"));
            downloadArchive(mod.downloadLink, "_cache/mod.zip", ()->{
                trace("Se descargó papu");

                try {
                    Unzipper.unzip("_cache/mod.zip", "_cache/mod/");
                } catch(e ){
                    trace(e);
                }
            });
            

        });
    }
    public function getModsSuscribed(onData:(data:UserModsSuscribed)->Void) {
        /*getText(getAPIURL('/mod/1/'), function a(data) {
            var
            onData(cast data);
            downloadArchive()
        })*/
        //getUser('482637805034668032', (user:User)->{
          //  onData({ID: user.ID, user: user, mods: []});
        //});
        /*return  {
            ID: "482637805034668032",
            user: cast ,
            mods: []
        }*/
    }
}