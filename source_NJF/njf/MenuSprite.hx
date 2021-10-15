package njf;

import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;


class MenuSprite extends GenericSelectable {

    var isAnimated:Bool;

    // Connections
    public var leftConnection:String;
    public var rightConnection:String;
    public var upConnection:String;
    public var downConnection:String;
    
    
    public function new(
        x:Float, y:Float, insideImageText:String = null, topText:String = "", isLocked:Bool = true,
        leftConnection:String = null, rightConnection:String = null, upConnection:String = null, downConnection:String = null, isAnimated:Bool = false)
        {
            super(x, y, insideImageText, topText, isLocked, false);

            this.leftConnection = leftConnection;
            this.rightConnection = rightConnection;
            this.upConnection = upConnection;
            this.downConnection = downConnection;

            this.isAnimated = isAnimated;

            if(!isLocked) {
                if(insideImageText != null) {
                    renderInsideImage();
                }
            }
        }

        private override function renderInsideImage() {
            if(!isAnimated) {
                insideImage = new FlxSprite(xPos, yPos).loadGraphic(Paths.image('menu_NJF/' + insideImageText));
            } else {
                insideImage = new Character(xPos, yPos, 'groyper-menu');
            }
            GenericSelectable.setGraphicSize(insideImage, 300);
            insideImage.x += 4;
            insideImage.y += 4;
            insideImage.updateHitbox();

            if(FlxG.save.data.antialiasing)
                this.insideImage.antialiasing = true;

            add(this.insideImage);
        }
}