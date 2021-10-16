package njf;

import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxSprite;



class KQBubble extends FlxSprite {

    var middleY:Float;
    static var maxVel:Float = 10;
    var D:Float = 9.8/(maxVel*maxVel);
    var currentAirResistance:FlxPoint;
    var trueAcceleration:Float;
    public var gameplayMovement:Bool;
    var totalTimePassed:Float;
    var hasExploded:Bool;
    var theHand:FlxSprite;
    var handAlpha:Float;
    var explosion:FlxSprite;
    public var standStill:Bool;

    static var bsEffectivenessM:Float = (1.0 - 0.8) / (400-1050); // -0.000307682307692
    static var bsEffectivenessB:Float = 1.0 - (400*bsEffectivenessM); // 1.123
    static var nickEffectivenessM:Float = -bsEffectivenessM; // 0.000307682307692
    static var nickEffectivenessB:Float = 1.0 - (1050*-bsEffectivenessM); // 0.677

    public function new(x:Float, y:Float) {
        super(x, y);

        this.x = x;
        this.y = y;
        middleY = y;
        gameplayMovement = false;
        standStill = false;
        hasExploded = false;
        currentAirResistance = new FlxPoint(0, 0);

        totalTimePassed = 0;

        if(FlxG.save.data.antialiasing)
			antialiasing = true;

        //FlxG.sound.play(Paths.music('KQ_Shooting'), 1);

        frames = Paths.getSparrowAtlas('NJF/Bubble_Cracking');
        animation.addByIndices('idle', 'Bubble_Cracking', [0], '', 24, true);
        animation.addByIndices('crack 1', 'Bubble_Cracking', [1], '', 24, true);
		animation.addByIndices('crack 2', 'Bubble_Cracking', [2], '', 24, true);
		animation.addByIndices('crack 3', 'Bubble_Cracking', [3], '', 24, true);

        animation.play('idle', true);
    }

    public override function update(elapsed:Float) {
        totalTimePassed += elapsed;
        if(gameplayMovement) {
            // First, calculate the air resistance, which is based on the velocity. It will always be opposite to the direction of the velocity
            airResistance();

            // Then make the bubbles acceleration equal to the acceleration applied by hitting notes + air resistance
            //trace('xAirRes: ' + currentAirResistance.x);
            acceleration.x = trueAcceleration + currentAirResistance.x;

            // Then, have the acceleration created by the notes decrease over time, like a gust of wind
            trueAcceleration -= trueAcceleration * elapsed;

            //var numberlol:Int = 10;
            /*
            if(velocity.x <= numberlol*elapsed || velocity.x >= -numberlol*elapsed) {
                velocity.x = 0;
            }
            */
            //if(trueAcceleration <= numberlol*elapsed && trueAcceleration >= -numberlol*elapsed) {
            //    trueAcceleration = 0;
            //}

            yMovement();

            //trace("KQ's: " + "Vel: " + velocity + "; Acc: " + acceleration + "Pos: (x: " + x + " | y: " + y + ");");
            
        } else {
            if(!standStill) {
                yMovement();
                maxVel = 80;
                airResistance();
                acceleration.x = currentAirResistance.x;
                if(x > 600) {
                    gameplayMovement = true;
                    maxVel = 40;
                }
            }
        }
        //Incase im testing something and dont want to die
        if(PlayState.SONG.song.toLowerCase() == 'they fight you')
           x = 400;
        super.update(elapsed);
    }

    /*
    The bubble, gameplay-wise, will always be between x=400 and x=1050
    Im going to add something so that Nick will be more effective with his bubble movement the closer the bubble is to him, and make BS's movement of the bubble weaker the further away it is from him.
    Point 1 - 400 | Point 2 - 1050
    Distance = 1050-400 = 650
    I want BS's effectiveness to be 80% when the bubble is at 1050 and 100% when the bubble is at 400
    This will be linear
    2 Points -> (1050, 0.8) and (400, 1.0)
    m = (1.0 - 0.8) / (400-1050) <=> m = -0.000(307692) aka -0.000307692307692307692307692307692...
    y = m*x + b <=> 1.0 = 400*-0.000(307692) + b <=> b = 1.0 + 400*-0.000(307692) <=> b = 1.123
    THIS IS THE LINE FOR BEN
    Now for nick
    2 Points -> (1050, 1.2) and (400, 1.0)
    so m = 0.000(307692)
    b = 0.677
    <---------------------------------->
    BS's effectiveness is 80% at max range and 100% at min range
    Nick's effectiveness is 100% at max range and 120% at min range
    */

    static var accCap:Int = 50;
    static var velCap:Int = 50;

    //If acceleration is negative, it means its a force in favor of nick, that makes the bubble go towards ben. If positive, its the reverse
    public function accelerate(acceleration:Float, isMiss:Bool) {
        //If its a push from ben to nick
        if(acceleration > 0) {
            if(isMiss) {
                //If its a miss, ignore acceleration cap
                trueAcceleration += acceleration;
            } else {
                //if it isnt a miss and it goes over the acceleration cap, set it to the cap
                if(trueAcceleration + acceleration*(x*bsEffectivenessM + bsEffectivenessB) > accCap) {
                    if(trueAcceleration < accCap)
                        trueAcceleration = accCap;
                //if it isnt a miss and it doesnt go over the cap, just add it
                } else {
                    trueAcceleration += acceleration * (x*bsEffectivenessM + bsEffectivenessB);
                }
            }
        //If its a push from nick to ben
        } else {
            //if it isnt a miss and it goes over the acceleration cap, set it to the cap
            if(trueAcceleration + acceleration*(x*nickEffectivenessM + nickEffectivenessB) < -accCap) {
                if(trueAcceleration > -accCap)
                    trueAcceleration = -accCap;
            //if it isnt a miss and it doesnt go over the cap, just add it
            } else {
                trueAcceleration += acceleration * (x*nickEffectivenessM + nickEffectivenessB);
            }
        }
    }

    //Same for velocity
    public function speedUp(velocity:Float, isMiss:Bool) {
        //If its a push from ben to nick
        if(velocity > 0) {
            if(isMiss) {
                //If its a miss, ignore velocity cap
                this.velocity.x += velocity;
            } else {
                //if it isnt a miss and it goes over the velocity cap, set it to the cap
                if(this.velocity.x + velocity*(x*bsEffectivenessM + bsEffectivenessB) > velCap) {
                    if(this.velocity.x < velCap)
                        this.velocity.x = velCap;
                //if it isnt a miss and it doesnt go over the cap, just add it
                } else {
                    this.velocity.x += velocity * (x*bsEffectivenessM + bsEffectivenessB);
                }
            }
        //If its a push from nick to ben
        } else {
            //if it isnt a miss and it goes over the velocity cap, set it to the cap
            if(this.velocity.x + velocity*(x*nickEffectivenessM + nickEffectivenessB) < -velCap) {
                if(this.velocity.x > -velCap)
                    this.velocity.x = -velCap;
            //if it isnt a miss and it doesnt go over the cap, just add it
            } else {
                this.velocity.x += velocity * (x*nickEffectivenessM + nickEffectivenessB);
            }
        }
    }

    private function airResistance() {
        var modVel:Float = modVel();
        //trace('modVel: ' + modVel);
        D = 20/(maxVel*maxVel);
        currentAirResistance.x = -D * modVel * velocity.x;
        //currentAirResistance.y = -D * modVel * velocity.y;
        //trace('D: ' + D);
    }

    public function explode() {
        if(!hasExploded) {
            FlxG.sound.play(Paths.music('KQ_Explosion'), 1);
        }
    }

    

    private function yMovement() {
        velocity.y = Math.sin(-totalTimePassed * 0.75) * 15;
    }

    private function modVel():Float {
       return Math.sqrt(this.velocity.x*this.velocity.x + this.velocity.y*this.velocity.y);
    }

    public function crack(?endFunction:Void->Void, playAnimation:Bool = false) {

        trace('KQ\'s Bubble Position -> x: ' + x + '; y: ' + y + ';');

        if(FlxG.sound.music != null)
            FlxG.sound.music.stop();


		standStill = true;
		gameplayMovement = false;

        if(endFunction == null) {
            endFunction = function() {};
        }
        
        new FlxTimer().start(2, function(tmr:FlxTimer) {
            if(playAnimation) {
                PlayState.dad.playAnim('Explode', true, false, 50);
            }
            FlxG.sound.play(Paths.music('bubble_cracking_one'));
            animation.play('crack 1', true);

            new FlxTimer().start(1, function(tmr:FlxTimer) {
                FlxG.sound.play(Paths.music('bubble_cracking_two'));
                animation.play('crack 2', true);

                new FlxTimer().start(1, function(tmr:FlxTimer) {
                    FlxG.sound.play(Paths.music('bubble_cracking_three'));
                    animation.play('crack 3', true);

                    endFunction();
                });
            });
        });
    }
}