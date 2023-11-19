package sprites;

class SpriteBase extends FlxSprite {

    public var animationOffsets:Map<String, Array<Float>>;
    public var defaultAnimation:String;
    public var animatedSprite:Bool;
    public var usedefaultanim:Bool;
    public function new(X, Y) {
        super(X, Y);
        animatedSprite = false;
        usedefaultanim = false;
        animationOffsets = new Map();
    }

    public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
    {
        var oldAnim = {w: width, h: height};

        animation.play(AnimName, Force, Reversed, Frame);
        forceOffsetOf(AnimName);
    }    
    public function curAnim()
    {
        return animation.curAnim != null ? animation.curAnim.name : "";
    }
    public function forceOffsetOf(Anim:String)
    {
        var Offsets = animationOffsets.get(Anim);
        offset.set(0, 0);
        if (animationOffsets.exists(Anim))
            offset.set(Offsets[0], Offsets[1]);
        else
            FlxG.log.warn('"$Anim" animation has no offsets.');
    }
    public function deleteOffset(Anim:String)
    {
        return animationOffsets.remove(Anim);
    }
    public function resetOffset(Anim:String)
    {
        return setOffset(Anim, 0, 0);
    }
    public function setOffset(Anim:String,X:Float, Y:Float) {
        return animationOffsets.set(Anim, [X, Y]);
    }
}