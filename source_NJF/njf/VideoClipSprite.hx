package njf;


import flixel.util.FlxColor;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;


class VideoClipSprite extends GenericSelectable {

    public var isTwitchCensored:Bool;
    public var isVideo:Bool;
    var fileTypeIcon:IconSprite;
    var twitchCensoredIcon:IconSprite;
    var pfrArray:Array<IconSprite>;
    var timeSprite:TimeSprite;
    var viewed:Bool = false;

    // Variables for image selection
    public var imagePNG:FlxSprite;
    public var blackRectangle1:FlxSprite;
    public var blackRectangle2:FlxSprite;
    public var clipsMenu:String;

    // Variables for video selection
    public var videoWEBMLink:String;


    // Connections
    public var leftConnection:String;
    public var rightConnection:String;
    public var upConnection:String;
    public var downConnection:String;

    
    
    public function new(x:Float, y:Float, insideImageText:String = null, topText:String = "", isTwitchCensored:Bool = false, isVideo:Bool = true,
        isPolitical:Bool = false, isFunny:Bool = false, isReaction:Bool = false,
        leftConnection:String = null, rightConnection:String = null, upConnection:String = null, downConnection:String = null, clipsMenu:String = 'A')
    {
        super(x, y, insideImageText, topText, false, false);

        this.leftConnection = leftConnection;
        this.rightConnection = rightConnection;
        this.upConnection = upConnection;
        this.downConnection = downConnection;

        this.clipsMenu = clipsMenu;

        this.isTwitchCensored = isTwitchCensored;
        this.isVideo = isVideo;
        pfrArray = new Array();

        if(!isLocked) {
            //Icon creation: Different icons for photos and clips, and for if its safe for twitch or not. Also a timestamp
            renderInsideImage();

            var iconLocationX:Int = Math.floor(x) + 304 - 50;
            if(isVideo) {
                timeSprite = new TimeSprite(insideImage.x, insideImage.y + insideImage.height, VideoState.getVidTime('assets/images/clips/' + clipsMenu + '/' + insideImageText + '/' + insideImageText + '.mp4'));
                timeSprite.setPositionRelative(5, -timeSprite.height - 5);
                add(timeSprite);
                fileTypeIcon = new IconSprite(insideImage.x + 300 - 50, insideImage.y, 'Mov_Icon');
            } else {
                fileTypeIcon = new IconSprite(insideImage.x + 300 - 50, insideImage.y, 'Photo_Icon');
            }
            if(isTwitchCensored) {
                twitchCensoredIcon = new IconSprite(insideImage.x, insideImage.y, 'Twitch_Dead');
            } else {
                twitchCensoredIcon = new IconSprite(insideImage.x, insideImage.y, 'Twitch_Icon_Faded');
            }
            add(fileTypeIcon);
            add(twitchCensoredIcon);

            if(isReaction) {
                pfrArray.push(new IconSprite(iconLocationX, y + 154 - 50, 'Reaction_Icon'));
                add(pfrArray[pfrArray.length-1]);
                iconLocationX -= 50;
            }
            if(isFunny) {
                pfrArray.push(new IconSprite(iconLocationX, y + 154 - 50, 'Funny_Icon'));
                add(pfrArray[pfrArray.length-1]);
                iconLocationX -= 50;
            }
            if(isPolitical) {
                pfrArray.push(new IconSprite(iconLocationX, y + 154 - 50, 'Political_Icon'));
                add(pfrArray[pfrArray.length-1]);
                iconLocationX -= 50;
            }


            insideImage.updateHitbox();
            if(FlxG.save.data.antialiasing) {
                insideImage.antialiasing = true;
                for(icon in pfrArray) {
                    icon.antialiasing = true;
                }
            }
        }    
    }

    private override function renderInsideImage() {
        insideImage = new FlxSprite(xPos, yPos).loadGraphic(Paths.image('clips/' + clipsMenu + '/' + insideImageText + '/' + insideImageText));
                
        insideImage.setGraphicSize(300, 150);
        insideImage.x += 4;
        insideImage.y += 4;
        insideImage.updateHitbox();

        if(FlxG.save.data.antialiasing)
            this.insideImage.antialiasing = true;

        add(insideImage);
    }

    public override function expand() {
        resizeSprite(background, 351);

        if(insideImage != null) {
            resizeSprite(insideImage, 342, 171);

            fileTypeIcon.setPosition(insideImage.x + 342 - 50, insideImage.y);
            twitchCensoredIcon.setPosition(insideImage.x, insideImage.y);
            if(isVideo) {
                timeSprite.setPosition(insideImage.x, insideImage.y + insideImage.height);
                timeSprite.setPositionRelative(5, -timeSprite.height - 5);
            }

            var iconLocationX:Int = Math.floor(insideImage.x) + 342 - 50;
            for(icon in pfrArray) {
                icon.setPosition(iconLocationX, insideImage.y + 171 - 50);
                iconLocationX -= 50;
            }
        }

        imageText.resizeText(0.6, 0.6);
        imageText.moveTextToMidpoint(new FlxPoint(background.x + 351/2, background.y - imageText.height/2));
    }

    public override function retract() {
        resizeSprite(background, 308);

        if(insideImage != null) {
            resizeSprite(insideImage, 300, 150);

            fileTypeIcon.setPosition(insideImage.x + 300 - 50, insideImage.y);
            twitchCensoredIcon.setPosition(insideImage.x, insideImage.y);

            if(isVideo) {
                timeSprite.setPosition(insideImage.x, insideImage.y + insideImage.height);
                timeSprite.setPositionRelative(5, -timeSprite.height - 5);
            }

            var iconLocationX:Int = Math.floor(insideImage.x) + 300 - 50;
            for(icon in pfrArray) {
                icon.setPosition(iconLocationX, insideImage.y + 150 - 50);
                iconLocationX -= 50;
            }
        }


        
        imageText.resizeText(0.5, 0.5);
        imageText.moveTextToMidpoint(new FlxPoint(background.x + 308/2, background.y - imageText.height/2));
    }

    public function select() {
        if(!FlxG.save.data.twitchSafety || !this.isTwitchCensored) {
            if(!isVideo) {
                imageSelection('clips/' + clipsMenu + '/' + insideImageText + '/' + insideImageText);
            } else {
                var clipsState:ClipsGalleryState = new ClipsGalleryState();
                clipsState.currentSelected = topText;
                clipsState.clipsMenu = clipsMenu;

                var video:MP4Handler = new MP4Handler();
                video.playMP4('assets/images/clips/' + clipsMenu + '/' + insideImageText + '/' + insideImageText + '.mp4', clipsState, null, false, false);
            }
        } else {
            imageSelection('menu_NJF/tos');
        }
    }

    public function unselect() {
        if(!isVideo) {
            imagePNG.kill();
            imagePNG.updateHitbox();

            blackRectangle1.kill();
            blackRectangle1.updateHitbox();

            blackRectangle2.kill();
            blackRectangle2.updateHitbox();
        }
    }

    private function imageSelection(imageName:String) {
        var defaultRatio:Float = 1280/720; // 1280/720 = 1.(7)

        imagePNG = new FlxSprite(0, 0).loadGraphic(Paths.image(imageName));

        if(defaultRatio >= imagePNG.width/imagePNG.height) {
            /*
            if the default ratio is greater than the image ratio, that means that this is an image that will appear with a bigger height than width,
                like someone filming with their phone vertically
            Meaning, there needs to be vertical black rectangles to the sides
            e.g. image that has a 0.5:1 ratio, meaning that, when scaled like this, will be 360x720.
            1280-360 = 920
            920 / 2 = 460
            each rectangle will be 460x720 and the first one will be at (0, 0) and the second will be at (460+360, 0)
            */
            GenericSelectable.resizeSpriteWithMidpoint(imagePNG, 0, 720, new FlxPoint(1280/2, 720/2));
            blackRectangle1 = new FlxSprite(0, 0).makeGraphic(Math.floor((1280-imagePNG.width)/2) + 1, 720, FlxColor.BLACK); //Adding 1 to the width of these images as it sometimes leaves an empty pixel
            blackRectangle2 = new FlxSprite((1280-imagePNG.width)/2 + imagePNG.width, 0).makeGraphic(Math.floor((1280-imagePNG.width)/2) + 1, 720, FlxColor.BLACK); 
        } else {
            /*
            if the default ratio is lower than the image ratio, that means that this is an image that will appear with a bigger width than height,
                like someone filming with their phone horizonally
            Meaning, there needs to be horizontal black rectangles on the top and bottom
            e.g. image that has a 2:1 ratio, meaning that, when scaled like this, will be 1280x640
            720-640 = 80
            80 / 2 = 40
            each rectangle will be 1280x40 and the first one will be at (0, 0) and the second will be at (0, 40+640)
            */
            GenericSelectable.resizeSpriteWithMidpoint(imagePNG, 1280, 0, new FlxPoint(1280/2, 720/2));
            blackRectangle1 = new FlxSprite(0, 0).makeGraphic(1280, Math.floor((720-imagePNG.height)/2) + 1, FlxColor.BLACK); //Adding 1 to the height of these images as it sometimes leaves an empty pixel
            blackRectangle2 = new FlxSprite(0, (720-imagePNG.height)/2 + imagePNG.height).makeGraphic(1280, Math.floor((720-imagePNG.height)/2) + 1, FlxColor.BLACK);
        }
    }

    public function setViewed() {
        viewed = true;
        background.animation.play('green');
    }
}