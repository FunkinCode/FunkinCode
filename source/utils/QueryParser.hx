package utils;

class QueryParser {
    public static function parseQuery(queryString:String):Map<String, String> {
        var result:Map<String, String> = new Map<String, String>();
        
        var pairs:Array<String> = queryString.split("&");
        
        for (pair in pairs) {
            var keyValue:Array<String> = pair.split("=");
            if (keyValue.length == 2) {
                result.set(keyValue[0], keyValue[1]);
            }
        }
        
        return result;
    }


}