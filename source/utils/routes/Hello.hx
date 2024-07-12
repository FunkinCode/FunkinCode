package utils.routes;

import hx_webserver.HTTPResponse;
import hx_webserver.HTTPRequest;

class Hello extends HTTPResponse {
    public function new(request:HTTPRequest){
        super(Ok, {
            message: "Hi nwn",
            code: 200,
        });
    }
}