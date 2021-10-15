package njf;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;

/**
    Class used for creating the time in the VideoClipSprite class, similar to how a Youtube video thumbnail has the video length in the bottom left corner.
**/
class TimeSprite extends FlxGroup {

    public var x:Float;
    public var y:Float;
    public var height:Float;
    var blackBackground:FlxSprite;
    var timeText:FlxText;
    var extraSpace:Int = 5;

    public function new(x:Float, y:Float, timeInSeconds:Int) {
        super();
        this.x = x;
        this.y = y;
        drawTime(parseTime(timeInSeconds));
        height = blackBackground.height;
    }

    /**
        Private function used to turn seconds into time in the string format HH:MM:SS or MM:SS if timeInSeconds < 3600.
    **/
    private static function parseTime(timeInSeconds:Int):String {
        var hours = 0;
        var minutes = 0;
        var seconds = timeInSeconds;

        hours = Std.int(timeInSeconds / 3600);
        seconds -= hours * 3600;
        minutes = Std.int(timeInSeconds / 60);
        seconds -= minutes * 60;

        var stringSeconds = '';
        var stringMinutes = '';
        var stringHours = '';

        if(minutes < 10) {
            stringMinutes = '0' + minutes;
        } else {
            stringMinutes += minutes;
        }

        if(seconds < 10) {
            stringSeconds = '0' + seconds;
        } else {
            stringSeconds += seconds;
        }

        if(hours == 0) {
            return stringMinutes + ':' + stringSeconds;
        } else {
            return hours + ':' + stringMinutes + ':' + stringSeconds;
        }
    }


    /**
        Private function used to create and add the rectangle and time text to the FlxGroup.
    **/
    private function drawTime(parsedTime:String) {
        timeText = new FlxText(0, 0, 0, parsedTime, 20);
        timeText.alpha = 1.0;

        blackBackground = new FlxSprite(x, y).makeGraphic(Std.int(timeText.width + extraSpace*2) - 4, Std.int(timeText.height + extraSpace*2) - 10, FlxColor.BLACK);
        blackBackground.alpha = 0.6;

        if(FlxG.save.data.antialiasing) {
            blackBackground.antialiasing = true;
            timeText.antialiasing = true;
        }

        add(blackBackground);
        add(timeText);
        adjustTime();
    }

    /**
        Set position of the black rectangle; The time will be adjusted so as to have the same midpoint.
    **/
    public function setPosition(x:Float, y:Float) {
        blackBackground.setPosition(x, y);
        adjustTime();
    }

    /**
        Add or subtract to the position of the black rectangle; The time will be adjusted so as to have the same midpoint.
    **/
    public function setPositionRelative(x:Float, y:Float) {
        blackBackground.setPosition(blackBackground.x + x, blackBackground.y + y);
        adjustTime();
    }

    /**
        Private function used to adjust the time to have the same midpoint as the black rectangle.
    **/
    private function adjustTime() {
        timeText.x = blackBackground.getMidpoint().x - timeText.width / 2;
		timeText.y = blackBackground.getMidpoint().y - timeText.height / 2;
    }
}