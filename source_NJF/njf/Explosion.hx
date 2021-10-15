package njf;

import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFramesCollection;

class Explosion extends FlxSprite {

    public function new(x:Float = 0, y:Float = 0) {
        super(x, y);
        frames = Paths.getSparrowAtlas('NJF/Explosions');
        animation.addByPrefix('explode_death', 'Explosion_Death', 24, false);
		animation.addByPrefix('explode', 'Explosion 2', 24, false);
		setGraphicSize(600);
		updateHitbox();
        visible = false;
        scrollFactor.set(1, 1);
        animation.play('explode_death', true);
    }

    public function explode(gameOver:Bool = false) {
        var offset:FlxPoint = new FlxPoint(-1050 + 625 + 190, -396 + 10 + 190);

		this.x = x + offset.x;
		this.y = y + offset.y;

        visible = true;
        
        if(gameOver) {
            animation.play('explode_death', true);
        } else {
            animation.play('explode', true);
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if(animation != null && animation.curAnim != null && animation.curAnim.name == 'explode' && animation.curAnim.finished) {
            visible = false;
        }
    }
}