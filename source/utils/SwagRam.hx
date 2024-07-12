package utils;

class SwagRam {
    public var total:Float;

    public var mb:Float;
    public var gb:Float;
    public var kb:Float;

    public function new (ram:Float) {
        set(ram);
    }
    public function set(ram:Float) {
        this.total = this.kb = ram;
        this.mb = this.kb / 1024;
        this.gb = this.mb / 1024;
    }
}