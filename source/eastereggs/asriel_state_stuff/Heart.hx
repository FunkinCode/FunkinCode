package eastereggs.asriel_state_stuff;
import flixel.effects.FlxFlicker;


class Heart extends FlxSprite {
    public var box:FlxSprite;
    public function new(x:Float, y:Float, ?box:FlxSprite) {
        super(x,y);
        this.box = box;
        loadGraphic("assets/secrets/images/heart.png");
        scale.set(0.035,0.035);
        updateHitbox();
        maxVelocity.set(100,100);
    
        color = FlxColor.RED;
    }
    public function flick(lengthShocks:Float, durationLength:Float = 0.1, duration:Float = 0.15, visibleEnd:Bool = true) {
        FlxFlicker.flicker(this, 4 * 0.1, 0.15, visibleEnd, true);

    }
    
    public function centerAsRatio(TYPE:flixel.util.FlxAxes, width:Float = 0, height:Float = 0) {
        if (width < 0) width = FlxG.width;
        if (height < 0) height = FlxG.height;
        if (TYPE.x) {
            x = width / 2;
        }
        if (TYPE.y) {
            x = width / 2;
        }
    }
    public var canMove:Bool = false;
    public var gamepad:FlxGamepad;
    public var tween:FlxTween;
    public function tweenHeartAlpha(to:Float, ?vel:Float = 1) {
        if (to < 0) to = 0; else if (to > 1) to = 1;
        if (tween != null)
            tween.cancel();

        tween = FlxTween.tween(this, {alpha: to}, vel);

    }
    public override function update(elapsed:Float) {
        super.update(elapsed);
        if (canMove) {
            var movingDown =FlxG.keys.pressed.DOWN;
            var movingUp =FlxG.keys.pressed.UP;
            var movingLeft =FlxG.keys.pressed.LEFT;
            var movingRight =FlxG.keys.pressed.RIGHT;
            if (gamepad != null) {
                    if (gamepad.pressed.ANY) {
                    movingDown =  (gamepad.pressed.DPAD_DOWN || gamepad.pressed.LEFT_STICK_DIGITAL_DOWN);
                    movingUp = (gamepad.pressed.DPAD_UP || gamepad.pressed.LEFT_STICK_DIGITAL_UP);
                   
                    movingLeft = (gamepad.pressed.DPAD_LEFT || gamepad.pressed.LEFT_STICK_DIGITAL_LEFT);
                    movingRight= (gamepad.pressed.DPAD_RIGHT || gamepad.pressed.LEFT_STICK_DIGITAL_RIGHT);
                    }
            } 
                if (movingDown)
                    velocity.y = maxVelocity.y;
                else if (movingUp)
                    velocity.y = -maxVelocity.y;
                else
                    velocity.y = 0;
                if (movingLeft)
                    velocity.x = -maxVelocity.x;
                else if (movingRight)
                    velocity.x = maxVelocity.x;
                else
                    velocity.x = 0;

         
            if (x < box.x)
                x = box.x;
            if (x > box.x + (box.width - width))
                x = box.x + (box.width - width);
            if (y < box.y)
                y = box.y;
            if (y > box.y + (box.height - height))
                y = box.y + (box.height - height);
        }
    }
}
