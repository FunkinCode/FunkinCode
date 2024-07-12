package sys;

//package sys;
import sys.io.File;
import haxe.zip.Reader;

class Unzipper {
    /**
     * Unzip any zip on a route, yes i am gay
     * @param _path the path of the zip, duh
     * @param _dest destino
     * @param ignoreRootFolder 
     */
    public static function unzip( _path:String, _dest:String, ignoreRootFolder:String = "" ) {

        var _in_file = File.read( _path );
        var _entries = Reader.readZip( _in_file );

            _in_file.close();

        for(_entry in _entries) {
            
            var fileName = _entry.fileName;
            if (fileName.charAt (0) != "/" && fileName.charAt (0) != "\\" && fileName.split ("..").length <= 1) {
                var dirs = ~/[\/\\]/g.split(fileName);
                if ((ignoreRootFolder != "" && dirs.length > 1) || ignoreRootFolder == "") {
                    if (ignoreRootFolder != "") {
                        dirs.shift ();
                    }
                
                    var path = "";
                    var file = dirs.pop();
                    for( d in dirs ) {
                        path += d;
                        sys.FileSystem.createDirectory(_dest + "/" + path);
                        path += "/";
                    }
                
                    if( file == "" ) {
                        if( path != "" ) trace("created " + path);
                        continue; // was just a directory
                    }
                    path += file;
                    trace("unzip " + path);
                
                    var data = haxe.zip.Reader.unzip(_entry);
                    var f = File.write (_dest + "/" + path, true);
                    f.write(data);
                    f.close();
                }
            }
        } //_entry

        Sys.println('');
        Sys.println('unzipped successfully to ${_dest}');

    } //unzip
}