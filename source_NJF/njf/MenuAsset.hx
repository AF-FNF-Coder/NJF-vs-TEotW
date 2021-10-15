package njf;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;


class MenuAsset extends FlxSprite {

    var type:String;
    var image:FlxSprite;
    var imageName:String = "";
    var xPos:Float;
    var yPos:Float;
    
    
    public function new(x:Float, y:Float, type:String = "")
        {
            super();
            this.type = type;
            xPos = x;
            yPos = y;
            
            switch(type) {
                case "hf-line":
                    imageName = 'Full_Black_Line_Horizontal';
                case "vf-line":
                    imageName = 'Full_Black_Line_Vertical';
                case "hd-line": 
                    imageName = 'Dashed_Black_Line_Horizontal';
                case "vd-line":
                    imageName = 'Dashed_Black_Line_Vertical';
                case "fow":
                    imageName = 'Fog_Of_War';
            }


        }

    public function getSprite():FlxSprite {
        return new FlxSprite(xPos, yPos).loadGraphic(Paths.image('menu_NJF/' + imageName));
    }




}