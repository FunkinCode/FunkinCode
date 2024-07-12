package utils.routes;

import hx_webserver.HTTPResponse;
import hx_webserver.HTTPRequest;

class ReLogin extends HTTPResponse {
    public function new(request:HTTPRequest){
        var response = '
        <script>
        window.location.href = "https://funkincodedev.deno.dev/auth/discord/login?port=${utils.Server.port}";
        </script>
        ';
        super(Ok, response);
        this.addHeaderIfEmpty("Content-Type", "text/html");

    }
}