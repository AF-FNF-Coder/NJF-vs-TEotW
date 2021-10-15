package njf;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class IconSprite extends FlxSprite
{
	public function new(x:Float, y:Float, iconName:String)
	{
		super(x, y);
        if(FlxG.save.data.antialiasing)
            this.antialiasing = true;

        loadGraphic(Paths.image('menu_NJF/' + iconName));

        //if(iconName != 'Funny_Icon')
            setGraphicSize(50, 50);


        updateHitbox();

        setPosition(x, y);
	}
}
