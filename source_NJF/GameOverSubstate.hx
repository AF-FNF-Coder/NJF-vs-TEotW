package;

import njf.Explosion;
import flixel.FlxSprite;
import njf.KQBubble;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;
	var killerQueenEvent:Bool;
	var hasExploded:Bool;
	var explosion:Explosion = new Explosion();
	public var goBack:Bool;
	public var revivePlayer:Bool = false;
	var reviveStarted:Bool = false;
	var finishedAnimation:Bool = false;
	var camScroll:FlxPoint;

	var stageSuffix:String = "";

	//var elapsedTime:Float = 0;

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		hasExploded = false;
		goBack = false;
		
		// AF Enjoyer: Adding a case for NJF
		switch (PlayState.SONG.player1)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'NJF':
				daBf = 'NJF';
			case 'mei':
				daBf = 'mei';
				stageSuffix = '_without_mic_drop';
			default:
				daBf = 'bf';
				stageSuffix = '';
		}

		super();

		var bg:FlxSprite = new FlxSprite(-1000, -1000).makeGraphic(FlxG.width*3, FlxG.height*3, FlxColor.BLACK);
		bg.alpha = 1;
		bg.scrollFactor.set();
		add(bg);

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		// AF Enjoyer: Adding a case for NJF
		// Also trying to make it zoom out so people can see the whole animation
		switch(PlayState.SONG.player1) {
			case 'NJF':
			case 'mei':
				camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y + 50, 1, 1);
			default:
				camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		}
		add(camFollow);

		explosion = new Explosion();


		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
	}

	public function killerQueenFunction(x:Float, y:Float) {
		killerQueenEvent = true;
		explosion.setPosition(x, y);
		add(explosion);
	}

	var startVibin:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(killerQueenEvent && !hasExploded) {
			hasExploded = true;
			explosion.explode(true);
		}

		if(!revivePlayer) {
			if (controls.ACCEPT)
			{
				endBullshit();
			}


			if (controls.BACK)
			{
				if(!PlayState.SONG.song.toLowerCase().startsWith('tutorial')) {
					PlayState.startTime = 0;
					isEnding = true;
					FlxG.sound.music.stop();

					if (PlayState.isStoryMode)
						LoadingState.loadAndSwitchState(new StoryMenuState());
					else
						LoadingState.loadAndSwitchState(new FreeplayState());

					PlayState.loadRep = false;
				
				// AF Enjoyer: For whatever reason, and i do not understand WHY this happens, but if you die in the tutorial, press escape and then load any non-tutorial song, the zoom gets all fucked up
				//			I spent like 3 hours trying to figure out why, and absolutely nothing worked. So now escape has the same functionality as enter for the tutorial only
				} else {
					if (!isEnding)
					{
						PlayState.startTime = 0;
						isEnding = true;
						bf.playAnim('deathConfirm', true);
						FlxG.sound.music.stop();
						FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
						new FlxTimer().start(0.7, function(tmr:FlxTimer)
						{
							FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
							{
								if(!goBack) {
									LoadingState.loadAndSwitchState(new PlayState());
								} else {
			
								}
							});
						});
					}
				}
			}


			if (bf.animation.curAnim.name == 'firstDeath')
				{
					/*if(PlayState.SONG.player1 == 'NJF') {
						// AF Enjoyer:
						// 58/2 = 29
						// Default zoom is 0.95, i have it set to 0.9 which is equal to PlayState's camHUD.zoom
						for(i in 12...29) {
							if(bf.animation.curAnim.curFrame == i) {
								
								FlxG.camera.zoom = 0.9 - (((0.9-0.70) / (58-12)) * (i-12) * 2);
								break;
							}
						}
					}*/
					//FlxG.camera.follow(camFollow, LOCKON, 0.01);
				}

			if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
			{
				FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
				startVibin = true;
			}

			if (FlxG.sound.music.playing)
			{
				Conductor.songPosition = FlxG.sound.music.time;
			}
		} else {
			revivePlayer1();
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (startVibin && !isEnding && !revivePlayer)
		{
			bf.playAnim('deathLoop', true);
		}
		//FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			PlayState.startTime = 0;
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					if(!goBack) {
						LoadingState.loadAndSwitchState(new PlayState());
					} else {

					}
				});
			});
		}
	}

	public function adjustBFPosition(x:Float, y:Float) {
		bf.x = x;
		bf.y = y;
	}

	public function doEverything() {
		if(!revivePlayer) {
			Conductor.changeBPM(100);
			Conductor.songPosition = 0;
		}

		// AF Enjoyer: Adding a case for NJF
		// Also trying to make it zoom out so people can see the whole animation
		switch(PlayState.SONG.player1) {
			case 'NJF':
			case 'mei':
				FlxG.camera.zoom = FlxMath.lerp(1.05, FlxG.camera.zoom, 0.6);
				FlxG.camera.zoom = 0.7;
		}
		add(camFollow);

		//trace('Attempting to play initial death sound');
		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		if(!revivePlayer) {
			FlxG.camera.scroll.set();
			FlxG.camera.target = null;
		} else {
			camScroll = FlxG.camera.scroll;
			FlxG.camera.scroll.set();
		}

		bf.playAnim('firstDeath');
	}

	var startLooping:Bool = false;

	public function revivePlayer1() {
		PlayState.instance.hasRevived = true;
		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished && !finishedAnimation) {
			startLooping = true;
			finishedAnimation = true;
			new FlxTimer().start(2, function(tmr:FlxTimer) {
				FlxG.sound.play(Paths.sound('ifGodIsWithUs')).fadeIn(2, 0.2, 1);
				new FlxTimer().start(2, function(tmr:FlxTimer) {
					reviveStarted = true;
					new FlxTimer().start(4.3, function(tmr:FlxTimer) {
						FlxG.sound.play(Paths.sound('fnf_loss_sfx_reverse'));
					});
					new FlxTimer().start(5.2, function(tmr:FlxTimer) {
						FlxG.sound.play(Paths.music('KQ_Explosion_Reverse'), 1);
					});
					new FlxTimer().start(6, function(tmr:FlxTimer) {
						startLooping = false;
						explosion.animation.play('explode_death', true, true);
						bf.playAnim('firstDeath', true, true);
					});
				});
			});
		}
		if(startLooping) {
			bf.playAnim('firstDeath', true, false, 58);
		}
		//trace('Conduction.songPosition: ' + Conductor.songPosition);
		//trace('revivePlayer1 -> bf.animation.curAnim.curFrame: ' + bf.animation.curAnim.curFrame + '; bf.animation.curAnim.name: ' + bf.animation.curAnim.name);
		if(reviveStarted) {
			if(bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 0) {
				finishedAnimation = false;
				hasExploded = false;
				revivePlayer = false;
				reviveStarted = false;
				remove(explosion);
				PlayState.instance.revivePlayer = true;
				trace('trying to close');
				FlxG.camera.scroll = camScroll;
				close();
			}
		}
	}
}
