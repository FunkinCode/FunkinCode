package utils;
import haxe.Http;
import sys.net.Host;
import haxe.io.BytesData;
import haxe.io.Bytes;
import hx_webserver.HTTPServer;
import hx_webserver.HTTPRequest;
import hx_webserver.HTTPResponse;

import utils.routes.*;
import haxe.Json;
class Server {
    static var server:HTTPServer;
    static var routemap:RouteMap ;
    public static var routes:Map<String, Class<HTTPResponse>> = [
        "hello" => Hello,
        "login" => Login,
        "redirectLogin" => ReLogin,
        "reLogin" => ReLogin,
        "loginSuccessfully" => LoginSuccessfully,
        "test" => Test,
    ];
    public static function createNew() {

    }
    public static var port:Int = 0;
    public static var useServer:Bool = true;
    public static var user:User;
    public static function main() {
        port = 4928;
        server = new HTTPServer("0.0.0.0",port, true/*, false*/);
        routemap = new RouteMap();
        for (i in routes.keys()) {
            var classType:Class<HTTPResponse> = routes.get(i);
            
            routemap.add('/$i', function (request:HTTPRequest) {
                trace("new response type: /" + i);
                final path = request.methods[1].substr(1).split("?");
                final queries = QueryParser.parseQuery(path[1]);
                return Type.createInstance(classType, [request, path[0], queries]);
            });
            
            @:privateAccess routemap.routeRequest(new TestRequest("GET", "/" + i));

        }
     
        final type = OptionsDotIni.get("type", "account");
        final token = OptionsDotIni.get("token", "account");
    
        trace(token);
        final url = 'https://funkincodedev.deno.dev/api/v1/user/@me';

        var _http = new Http(url);
        _http.addHeader("Accept", "*/*");
        _http.addHeader("User-Agent",  'FunkinCode/1.0.0-alpha (windows)');
        _http.addHeader("Authorization",  'Bearer ${token}' );
        _http.onData = (data:String) -> {
             Server.user = cast Json.parse(data);
            trace('Hello ${Server.user.Username}!, welcome!');
        }
        _http.onError = (data:String)-> {
        error(data);
        };
        _http.request(false);
        routemap.attach(server);
      }
}

class TestRequest extends HTTPRequest {

    public function new(
        method: String,
        path: String,
        version: String = "HTTP/1.1"
    ) {
        super(null, null, null);
        this.methods = [method, path, version];
    }

    override function replyRaw(bytes: haxe.io.Bytes) {
    }

}