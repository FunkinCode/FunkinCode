import haxe.macro.Expr;

class Main {
    static function main() {
        var script:String = "trace('Hola desde el script!');";
        var expr:Expr = haxe.macro.Compiler.execute(script);
        haxe.macro.Context.current().eval(expr);
    }
}

