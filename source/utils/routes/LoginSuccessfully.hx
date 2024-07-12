package utils.routes;

import haxe.Json;
import sys.Http;
import hx_webserver.HTTPResponse;
import hx_webserver.HTTPRequest;
import hx_webserver.StatusCode;

class LoginSuccessfully extends HTTPResponse {

    static function getIndex(body:String) return '
        <!DOCTYPE html>
        <html lang="es">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>FunkinCode | Login</title>
            <style> 
                body{background:url("https://github.com/FunkinCode/FunkinCode/blob/dev/assets/preload/images/menuBGBlue.png?raw=true") ; background-size: cover; background-color: rgb(0,0,0);text-align:center; color:#fff;font-family:Arial,Helvetica,sans-serif}
                .usercard{margin-top:120px;display:grid;grid-template-columns:1fr 2fr;width:500px;height:200px;border-radius:30px 10px 30px 10px;background-color:rgba(0,0,0,.534);position:relative}
                .avatar{width:100px;height:100px;border-radius:50%;margin:auto}
                .text{text-align:left;margin:auto 10px;display:flex;flex-direction:column}
                displayName{font-size:48px}
                username{font-size:24px;margin-bottom:16px;margin-left:16px}
                .id{color:rgba(255,255,255,.85);text-align:right;margin-left:10px}
                .title{font-size:175%}
                swagDiscordLogo{background:url("https://assets-global.website-files.com/6257adef93867e50d84d30e2/636e0a6ca814282eca7172c6_icon_clyde_white_RGB.svg"); width: 31.25px; height: 23.75px;position:absolute;bottom:0;left:0;margin:10px}
                .discordId{color:rgba(255,255,255,.85);position:absolute;bottom:10px;left:50px}
                .databaseId{color:rgba(255,255,255,.85);position:absolute;top:10px;right:10px}
                .button {display: inline-block;padding: 10px 20px;font-size: 18px;background-color: #7289da; color: #fff;text-decoration: none;border-radius: 5px;width: 241.25px;}
                .discordLogo {background: url("https://assets-global.website-files.com/6257adef93867e50d84d30e2/636e0a6ca814282eca7172c6_icon_clyde_white_RGB.svg");width: 30.25px;height: 23.75px;margin-left: -32px;}.button .discordLogo {position: absolute;}
            </style>
        </head>
        ${body}
        </html>

    ';
    static function noLoginBody() return '
        <body style="background-image: none;">
        <div style="padding:50px; ">
            <div style="padding:50px">
                <div class="title">
                    <h1>No se detectó usuario</h1>
                    <a href="https://funkincodedev.deno.dev/auth/discord/login?port=${utils.Server.port}" class="button"><span class="discordLogo"></span>Iniciar sesión con Discord</a>
                </div>
            </div>
        </div>
        </body>
    ';
    static function onLoginBody(title:String, description:String) return '
    <body>
    <div style="padding:50px">
        <div class="title">
            <h1>${title}</h1>
            <p>${description}</p>
        </div>
        <center>
            <div class="usercard">
                <swagDiscordLogo></swagDiscordLogo>
                <div class="discordId">(ID: ${Server.user.DiscordID})</div>
                <img class="avatar" src="${Server.user.AvatarURL}" alt="Avatar">
                <div class="text">
                    <displayName>${Server.user.DisplayUsername}</displayName>
                    <username>@${Server.user.Username}</username>
                </div>
                <div class="databaseId">(ID: ${Server.user.ID})</div>
            </div>
        </center>
    </div>
    ';
    static function newLoginTitle(refresh:Bool) return '${refresh ? 'Re' : ''}Login successfully';
    static function newLoginDescription()return'(You can close this and return to Funkin\' Code)';
    static function alreadyLoginTitle() return 'Already Logged';
    static function alreadyLoginDescription() return 'Logged has: ${Server.user.Username}';

    public function new(request:HTTPRequest, routePath:String, queries:Map<String, String>){
        final user:User = Server.user ;
        final isNew = queries.get("isnew") == "true";
        final refresh = queries.get("refresh") == "true";
        
        trace(user);
        
        final body = user == null ? noLoginBody() :isNew ?  onLoginBody(newLoginTitle(refresh), newLoginDescription()) : onLoginBody(alreadyLoginTitle(), alreadyLoginDescription());
        final response:Dynamic = getIndex(body);
        super(Ok, response);
        this.addHeaderIfEmpty("Content-Type", "text/html");
        
        try {
            OptionsMenu.instance.checkLoginStatus();
        } catch(e){
            trace(e);
        }

    }
}