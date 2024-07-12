package utils.routes;

import hx_webserver.HTTPResponse;
import hx_webserver.HTTPRequest;

class Test extends HTTPResponse {
    public function new(request:HTTPRequest){
        super(Ok, 
            {
                message: "tested",
                date: Date.now().getTime()
            }
        );
    }
}