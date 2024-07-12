//import LoginInfo;
package;

import openfl.utils.Promise;
import openfl.net.URLRequest;
import hscript.Expr.Const;
import haxe.Http;


interface UserScheme {
    var ID:String;
    var Username:String;
    var DisplayUsername:String;
    var _private:Bool;
    var flags:Int; // en realidad debe de ser un big int o algo, LEER DESPUEés 
}

interface ResultLogin {
    var response: String;
    var token:String;
}

class LoginState extends MusicBeatState {
    // URL
    var popUP:Dynamic;
    function e():Promise<String> {
        return new Promise<String>().complete("ayya ya vi");
    }
    override function create() {
        super.create();
        
      /*var e =  new  Http(LoginInfo.getURLDiscord());
      e.onBytes = cast info;
      e.onData =cast info;
      e.onError = cast error;
      popUP = e;
      e.request(false);*/
      //openfl.Lib.navigateToURL(new URLRequest(LoginInfo.getURLDiscord()), "_self");
      warn("This state is of test!!");

      FlxG.openURL(LoginInfo.getURLDiscord(), "_parent");
    }
}
