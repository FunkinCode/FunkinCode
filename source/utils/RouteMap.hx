package utils;

import haxe.rtti.CType.Path;
import hx_webserver.RouteMap as RouteMapHandler;
import hx_webserver.HTTPRequest;
import hx_webserver.HTTPResponse;

class RouteMap  extends RouteMapHandler {


    // post 

    private override function routeRequest(request: HTTPRequest) {
        var path = request.methods[1].split("?")[0];

        trace('New connection from local user, should be this route: ${path}');
        var handler = this.routes.get(path);

        var response: HTTPResponse;
        if (handler != null) {
            try {
                response = handler(request);
            } catch (exception) {
                trace(exception);
                response = new HTTPResponse(
                    InternalServerError,
                    "Internal Server Error",
                );
            }
        } else {
            response = new HTTPResponse(NotFound,{
                message: "This page doesn't exists",
                code: 404,
            });
        }
        if (response == null) {
            response = new HTTPResponse(NoContent, {
                message: "This page hasn't content",
                code: 204,
            });
        }
        request.replyRaw(response.prepare());
    }

}
