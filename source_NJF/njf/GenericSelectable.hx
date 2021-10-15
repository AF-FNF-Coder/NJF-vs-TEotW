package njf;

import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

using StringTools;

class GenericSelectable extends FlxGroup {

    var insideImageText:String;
    public var insideImage:FlxSprite;
    public var topText:String;
    var imageText:Alphabet;
    public var isLocked:Bool;
    var background:FlxSprite;
    var xPos:Float;
    var yPos:Float;
    var textOffset:Int;
    var isExpanded:Bool = false;

    
    public function new(x:Float, y:Float, insideImageText:String = null, topText:String = "", isLocked:Bool = true, renderNormally:Bool = true)
        {
            super();

            //Assign variables
            xPos = x;
            yPos = y;
            this.insideImageText = insideImageText;
            this.topText = topText;
            this.isLocked = isLocked;

            //Create background
            background = new FlxSprite(x, y);

            var tex:FlxAtlasFrames = Paths.getSparrowAtlas('menu_NJF/Menu Assets');
			background.frames = tex;

            background.animation.addByPrefix('standard', 'Menu_Rectangle_Standard', 24, false);
            background.animation.addByPrefix('flashing', 'Menu_Rectangle_Flashing', 24, false);
            background.animation.addByPrefix('green', 'Menu_Rectangle_Green', 24, false);
			

            background.animation.play('standard');
            //background.setGraphicSize(308);
            background.updateHitbox();
            this.add(background);

            //Render inside image
            if(!isLocked) {
                if(insideImageText != null) {
                    if(renderNormally)
                        renderInsideImage();
                }
            } else {
                renderLock();
            }

            //Create Text
            imageText = new Alphabet(x-25, y - 35, topText, true, false, true, 0.5, 0.5);
            imageText.moveTextToMidpoint(new FlxPoint(x + 308/2, y - imageText.height/2));

            this.add(imageText);

            if(FlxG.save.data.antialiasing) {
                background.antialiasing = true;
                if(insideImage != null)
                    insideImage.antialiasing = true;
            }
        }

        public function startFlashing() {
            background.animation.play('flashing', true);
        }

        public function getBackground():FlxSprite {
            return background;
        }

        public function expand() {
            resizeSprite(background, 351);
            //trace('insideImageText: ' + insideImageText);
            if(insideImageText != null)
                resizeSprite(insideImage, 342);

            imageText.resizeText(0.6, 0.6);
            imageText.moveTextToMidpoint(new FlxPoint(background.x + 351/2, background.y - imageText.height/2));

            isExpanded = true;
        }

        public function retract() {
            resizeSprite(background, 308);

            if(insideImageText != null)
                resizeSprite(insideImage, 300);
            
            imageText.resizeText(0.5, 0.5);
            imageText.moveTextToMidpoint(new FlxPoint(background.x + 308/2, background.y - imageText.height/2));

            isExpanded = false;
        }

        private function resizeSprite(sprite:FlxSprite, width:Int, height:Int = 0, xStaysCentered:Bool = true, yStaysCentered:Bool = true) {
            //Same logic as resizeText of Alphabet.hx
            var oldWidth:Float = sprite.width;
		    var oldHeight:Float = sprite.height;

            sprite.setGraphicSize(width, height);
            sprite.updateHitbox();


            if(xStaysCentered) {
			    sprite.x = sprite.x + oldWidth/2 - sprite.width/2;
		    }
		    if(yStaysCentered) {
			    sprite.y = sprite.y + oldHeight/2 - sprite.height/2;
		    }

            sprite.updateHitbox();
        }

        // copy of the above but for floats
        private function resizeSpriteFloat(sprite:FlxSprite, size:Float, xStaysCentered:Bool = true, yStaysCentered:Bool = true) {
            var oldWidth:Float = sprite.width;
		    var oldHeight:Float = sprite.height;

            setGraphicSize(sprite, size);
            sprite.updateHitbox();


            if(xStaysCentered) {
			    sprite.x = sprite.x + oldWidth/2 - sprite.width/2;
		    }
		    if(yStaysCentered) {
			    sprite.y = sprite.y + oldHeight/2 - sprite.height/2;
		    }

            sprite.updateHitbox();
        }

        // Why doesnt setGraphicsSize accept floats ffs i have to make my own function this is so retarded and gay
        private static function setGraphicSize(sprite:FlxSprite, width:Float = 0, height:Float = 0):Void {
            if (width <= 0 && height <= 0)
                return;
        
            var newScaleX:Float = width / sprite.frameWidth;
            var newScaleY:Float = height / sprite.frameHeight;
            sprite.scale.set(newScaleX, newScaleY);
        
            if (width <= 0)
                sprite.scale.x = newScaleY;
            else if (height <= 0)
                sprite.scale.y = newScaleX;

            sprite.updateHitbox();
        }

        public function unlock() {
            isLocked = false;
            if(insideImage != null) {
                    insideImage.kill();
                    //insideImage.draw();
                    trace('Unlocking: ' + topText);
                    insideImage = new FlxSprite(background.x, background.y).loadGraphic(Paths.image('menu_NJF/' + insideImageText));
                    insideImage.revive();
                    if(!isExpanded) {
                        setGraphicSize(insideImage, 300);
                        insideImage.x += 4; 
                        insideImage.y += 4;
                    } else {
                        expand();
                    }
                    insideImage.updateHitbox();
                    add(this.insideImage);
            }
            updateHitboxes();
        }

        public function updateHitboxes() {
            if(insideImage != null)
                this.insideImage.updateHitbox();
            this.background.updateHitbox();
        }

        private function renderLock() {
            trace('Locking: ' + topText);
            insideImage = new FlxSprite(background.width + 10 + background.x);

            insideImage.x = xPos + 120;
            insideImage.y = yPos + 30;

            var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
            insideImage.frames = ui_tex;
            insideImage.animation.addByPrefix('lock', 'lock');
            insideImage.animation.play('lock');

            if(FlxG.save.data.antialiasing)
                this.insideImage.antialiasing = true;

            this.add(insideImage);
        }

        private function renderInsideImage() {
            insideImage = new FlxSprite(xPos, yPos).loadGraphic(Paths.image('menu_NJF/' + insideImageText));
                    
            setGraphicSize(insideImage, 300);
            insideImage.x += 4;
            insideImage.y += 4;
            insideImage.updateHitbox();

            if(FlxG.save.data.antialiasing)
                this.insideImage.antialiasing = true;

            add(this.insideImage);
        }

        public static function resizeSpriteWithMidpoint(sprite:FlxSprite, width:Int, height:Int = 0, midPoint:FlxPoint) {
            sprite.setGraphicSize(width, height);
            sprite.updateHitbox();
            /*
            Example:
            Image is 200x100
            i have a midpoint of (500, 10)
            x = 500 - 200/2 = 400
            y = 10 - 100/2 = -40
            */
            sprite.setPosition(midPoint.x - sprite.width / 2, midPoint.y - sprite.height / 2);

            sprite.updateHitbox();
        }
}