package states.editors;

class ModCreator extends MusicBeatState {
    public var curPaso:Int = 0; // uupsi
    public var text:String;
    public var description:String;
    public function checkCurStep() {
        switch (curPaso) {
            case 0:
                text = "Choose a name for ya mod ! -> Select description -> Version -> Drop an logo (if you don't have it, to skip, dont put anything)";
            case 1:
                text = "Drop Songs (Cada 2 archivos se creara como una canción, puedes elegir el nombre y también escucharla para saber si es la correcta) - If you have chart, drop it! ";

            case 2:
                text = "Drop chars (xml and png) - If you have .json (Used on PsychEngine or this engine, just drop it)";
                if (FlxG.keys.justPressed.SEVEN) trace("hey");
           
            case 3:
                text = "Drop stage sprites. (To enter the menu, press 7)";
                if (FlxG.keys.justPressed.SEVEN) trace("hey");
            case 4:
                text = "Create your weeks or freeplay menu songs!";
            case 6:
            #if API
                if (unlogged){
                text = "Select your ORG / Account";
                Main.api.openLoginMethod("cur-logged", "ifnot", "login-discord");
                }
                if (logged)
            #end
                    curPaso += 1;
            case 7:
                text = "You want to zip it?";
                if (FlxG.keys.justPressed.Y)
                    {
                        #if debug #end
                        curPaso += 1;
                    }
            case 8:
                text = "Publishing ya mod, please wait (unlisted)...";
                #if API
                if (logged)
                    {
                        Main.api.publishModAsUnlisted(curMod, 
                            ()-> curPaso += 1, 
                            ()-> text= "An error was ocurred, press F3 to see logs, and press ENTER to continue");
                    }
                #end
            default:
                //finish();
            case 100: // GENERIC ERROR
                text = "HEY an error has ocurred with code 100: Generalmente esto sucede "+ 
                "Cuando tu engine está desactualizado, cuando tu cuenta a sido suspendida temporalmente de nuestro servicio" + 
                " o inclusive porque tu internet no aceptó nuestra conexión: BAD SERVER RESPONSE";
            case 101:
                text = "Hey this error happends when you are offline!";
            case 102:
                text = "Your account is banned";
            case 103:
                text = "Uh, you needs to captcha before all, just relogin for complet the captcha";
            case 104: // traducir todo esto:
                text  = "Tu IP está baneada";
            case 105:
                text = "Tu IP ha sido temp baneada";
            case 106: 
                text = "Este mod ya existe.";
            case 107:
                text = "Bad client used.";
            case 108:
                text = "bad request client used.";
            case 109:
                text = "This mod can't be published: Falta" + #if API paramenters.get("PUBLISH") + #end "";
            case 110:
                text = "Necesitas tener como minimo un usuario de login: BAD LOGIN";
            case 111:
                text = "Necesitas ser una organización verificada: BAD ORGANIZATION MAKED";

        }
    }
}