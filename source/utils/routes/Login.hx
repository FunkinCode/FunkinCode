package utils.routes;

import haxe.Json;
import sys.Http;
import hx_webserver.HTTPResponse;
import hx_webserver.HTTPRequest;
import hx_webserver.StatusCode;

class Login extends HTTPResponse {
    public function new(request:HTTPRequest, routePath:String, queries:Map<String, String>){
        var response:Dynamic = {
            code: StatusCode.BadRequest,
            message: "Bad request: invalid token"
        }
        if (queries.exists("token") )
            {
                response = {
                    code: StatusCode.NotFound,
                    message: "This token is invalid"
                };
                final type = queries.get("type");
                final token = queries.get("token");
            

                final url = 'https://funkincodedev.deno.dev/api/v1/user/@me';

                var _http = new Http(url);
                _http.addHeader("Accept", "*/*");
                _http.addHeader("User-Agent",  'FunkinCode/1.0.0-alpha (windows)');
                _http.addHeader("Authorization",  'Bearer ${token}' );
                var oldServerUser = Server.user;
                OptionsDotIni.set("token", token, "account");
                OptionsDotIni.set("type", type, "account");
                _http.onData = (data:String) -> {
                     Server.user = cast Json.parse(data);
                    response = '
                    <script>
                    window.location.href = window.location.origin + window.location.pathname.replaceAll(".html","") + "Successfully?isnew=true&refresh=${oldServerUser != null}";
                    </script>
                    ';
                    
                    trace('Hello ${Server.user.Username}!, welcome!');
                }
                _http.onError = (data:String)-> {
                    response = {
                        code: StatusCode.InternalServerError,
                        message: data
                    };
                };
                _http.request(false);

            }
        final code = response.code != null ? response.code : StatusCode.Ok;
        super(code, response);
        if (code == Ok)
        this.addHeaderIfEmpty("Content-Type", "text/html");

    }
}