package;
import utils.Server;
import lime.net.curl.CURL;
import haxe.MainLoop;
import haxe.Utf8.encode;
import cpp.objc.Protocol;


//haxe.net.URL.encode(url);
class LoginInfo {
    public static var client_id:String = DiscordClient._appID;
    private static var api_URL = "localhost://"; // APIStuff.LoginCALLBACK;
    private static var callBack = '/auth/discord/callback';
    private static var baseURLDiscord:String = 'https://discord.com/api/oauth2/authorize';

   // public var URL = "https://discord.com/api/oauth2/authorize?client_id=${client_id}&response_type=code&redirect_uri=&scope=identify+email"
    public static function getURLDiscord(?redirect) {
        
        if (redirect == null) redirect = StringTools.urlEncode(join(api_URL, callBack)); //(!redirect)
        /*if (utils.isInThread(this))
            return MainLoop.runInMainThread(()->{
                this.getURLDiscord.bind(redirect, "@redirect").then(e-> trace(e))
        })*/
        

     return 'http://localhost:${Server.port}/reLogin';
    }   
   // public static fun
    public static function formatURL(...definer:Array<String>) {
        var dat = [];
        for (data in definer.toArray())
            {
                dat.push('${dat.length > 0 ? "&":"?"}'+data.join("="));
            }
        return '${join(...dat)}';
    } 
}