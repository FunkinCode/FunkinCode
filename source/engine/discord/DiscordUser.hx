package engine.discord;

import haxe.Http;

class DiscordUser {
    public static var user:User;

    public static function login():User {
   
        return user;
    }
    
}


/*
class Main {
    static function main() {
        var server = new haxe.Http();
        server.listen(8080);
        server.addRoute("/", onRequest);
        trace("Servidor en funcionamiento en http://localhost:8080/");
    }

    static function onRequest(req: Dynamic, res:Dynamic) {
        res.setHeader("Content-Type", "text/plain");
        res.write("¡Hola, mundo!");
    }
}
*/