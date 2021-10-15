package;

import openfl.events.SampleDataEvent;
import flixel.FlxState;
import flixel.FlxG;

import vlc.LibVLC;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.system.FlxSound;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import openfl.display.Sprite;

import openfl.Lib;

using StringTools;

class VideoState extends MusicBeatState
{
	// AF Enjoyer: Adding a variable to count number of enters

	public static var numberOfEnters:Int = 0;

	// AF Enjoyer: Adding another for me, the dev, to skip them so i can quickly debug stuff

	public static var devKeyPressed:Bool = false;

	public static var instance:VideoState = null;

	public var leSource:String = "";
	public var transClass:FlxState;
	public var txt:FlxText;
	public var fuckingVolume:Float = 1;
	public var notDone:Bool = true;
	public var vidSound:FlxSound;
	public var soundLength:Float;
	public var useSound:Bool = false;
	public var soundMultiplier:Float = 1;
	public var prevSoundMultiplier:Float = 1;
	public var videoFrames:Int = 0;
	public var defaultText:String = "";
	public var doShit:Bool = false;
	public var pauseText:String = "Press P To Pause/Unpause";
	public var autoPause:Bool = false;
	public var musicPaused:Bool = false;

	public function new(source:String, toTrans:FlxState, frameSkipLimit:Int = -1, autopause:Bool = false)
	{
		instance = this;
		super();
		autoPause = autopause;
		
		leSource = source;
		transClass = toTrans;
		if (frameSkipLimit != -1 && GlobalVideo.isWebm)
		{
			//GlobalVideo.getWebm().webm.SKIP_STEP_LIMIT = frameSkipLimit;	
		}
	}
	
	override function create()
	{
		super.create();
		FlxG.autoPause = false;
		doShit = false;
		
		if (GlobalVideo.isWebm) {
			videoFrames = Std.parseInt(Assets.getText(leSource.replace(".webm", ".txt")));
			GlobalVideo.get().webm.frameRate = GlobalVideo.get().webm.duration / videoFrames;
			trace('frameRate: ' + GlobalVideo.get().webm.frameRate);
		}
		
		fuckingVolume = FlxG.sound.music.volume;
		FlxG.sound.music.volume = 0;
		var isHTML:Bool = false;
		#if web
		isHTML = true;
		#end
		// AF Enjoyer: Bro stfu nobody cares about your html5 support
		/*
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var html5Text:String = "You Are Not Using HTML5...\nThe Video Didnt Load!";
		if (isHTML)
		{
			html5Text = "You Are Using HTML5!";
		}
		defaultText = "If Your On HTML5\nTap Anything...\nThe Bottom Text Indicates If You\nAre Using HTML5...\n\n" + html5Text;
		txt = new FlxText(0, 0, FlxG.width,
			defaultText,
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
		*/

		if (GlobalVideo.isWebm)
		{
			if (Assets.exists(leSource.replace(".webm", ".ogg"), MUSIC) || Assets.exists(leSource.replace(".webm", ".ogg"), SOUND))
			{
				useSound = true;
				vidSound = FlxG.sound.play(leSource.replace(".webm", ".ogg"));
			}
		}

		

		// Sound length is .ogg duration in secs
		soundLength = vidSound.length / 1000;

		GlobalVideo.get().source(leSource);
		GlobalVideo.get().clearPause();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().updatePlayer();
		}
		GlobalVideo.get().show();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().restart();
		} else {
			GlobalVideo.get().play();
		}

		
		/*if (useSound)
		{*/
			//vidSound = FlxG.sound.play(leSource.replace(".webm", ".ogg"));
		
			/*new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{*/
				vidSound.time = vidSound.length * soundMultiplier;
				/*new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					if (useSound)
					{
						vidSound.time = vidSound.length * soundMultiplier;
					}
				}, 0);*/
				doShit = true;
			//}, 1);
		//}
		
		if (autoPause && FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			musicPaused = true;
			FlxG.sound.music.pause();
		}
	}

	/**
		Function used for getting the time of an .mp4 file in seconds
	**/
	public static function getVidTime(source:String):Int {
		//trace('source: ' + source);
		//trace('FlxG.sound.cache(source): ' + FlxG.sound.cache(source));
		var libVLC:LibVLC = LibVLC.create();
        libVLC.setPath(MP4Handler.checkFile(source));
		//trace('duration: ' + Std.int(libVLC.getDuration()/1000));
		return Std.int(libVLC.getDuration()/1000);
	}
	
	var startedUpdating:Bool = false;
	var relativeSoundTime:Float = 0;
	var framesRelative:Float = 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(!startedUpdating) {
			vidSound.time = 0;
			startedUpdating = true;
		}
		
		if (useSound)
		{
			var wasFuckingHit = GlobalVideo.get().webm.wasHitOnce;
			/*
			soundMultiplier = GlobalVideo.get().webm.renderedCount / videoFrames;
			
			if (soundMultiplier > 1)
			{
				soundMultiplier = 1;
			}
			if (soundMultiplier < 0)
			{
				soundMultiplier = 0;
			}
			if (doShit)
			{
				var compareShit:Float = 200;
				if (vidSound.time >= (vidSound.length * soundMultiplier) + compareShit || vidSound.time <= (vidSound.length * soundMultiplier) - compareShit) {
					vidSound.time = vidSound.length * soundMultiplier;
				}
			}
			*/

			// AF Enjoyer: Ok instead of skipping sound bytes, which is awful, what if we skipped video frames

			//trace('vidSound.time/1000: ' + vidSound.time/1000);
			//framesRelative = GlobalVideo.get().webm.renderedCount / videoFrames;
			/*
			framesRelative = GlobalVideo.get().webm.renderedCount / videoFrames;
			var compareShit = 50;
			relativeSoundTime = vidSound.time / soundLength;
			GlobalVideo.get().webm.relativeSoundTime = relativeSoundTime;
			//trace('relativeSoundTime & framesRelative: ' + relativeSoundTime + ' & ' + framesRelative);
			// Altering renderedFrameCount doesnt work
			if(relativeSoundTime > framesRelative + compareShit/videoFrames) {
				trace('skipping frames');
				GlobalVideo.get().webm.skipAFrame(relativeSoundTime, framesRelative, videoFrames);
			} else if(relativeSoundTime < framesRelative - compareShit/videoFrames) {
				trace('didnt play frame');
				GlobalVideo.get().webm.dontPlayFrame();
			}
			*/
			//if(whatTimeIsIt < GlobalVideo.get().webm.soundElapsedTimeDontAskWhyThisVariableExists - compareShit/videoFrames) {
			//	GlobalVideo.get().webm.skippedSteps++;
			//} else if(whatTimeIsIt > GlobalVideo.get().webm.soundElapsedTimeDontAskWhyThisVariableExists + compareShit/videoFrames) {
			//	GlobalVideo.getWebm().updatePlayer();
			//}
			//GlobalVideo.get().webm.lastDecodedVideoFrame = vidSound.time/1000 + 0.2;
			//GlobalVideo.get().webm.lastRequestedVideoFrame = vidSound.time/1000;
			//GlobalVideo.get().webm.lastDecodedVideoFrame2 = vidSound.time/1000;

			soundMultiplier = 1;
			prevSoundMultiplier = 1;
			if(!vidSound.playing) {
				vidSound.resume();
			}
			
			if (wasFuckingHit)
			{
			if (soundMultiplier == 0)
			{
				if (prevSoundMultiplier != 0)
				{
					vidSound.pause();
					vidSound.time = 0;
				}
			} else {
				if (prevSoundMultiplier == 0)
				{
					vidSound.resume();
					vidSound.time = vidSound.length * soundMultiplier;
				}
			}
			prevSoundMultiplier = soundMultiplier;
			}
			
		}
		
		if (notDone)
		{
			FlxG.sound.music.volume = 0;
		}
		GlobalVideo.get().update(elapsed);

		if (controls.RESET)
		{
			//GlobalVideo.get().restart();
		}
		
		if (FlxG.keys.justPressed.P)
		{
			//txt.text = pauseText;
			trace("PRESSED PAUSE");
			GlobalVideo.get().togglePause();
			if (GlobalVideo.get().paused)
			{
				GlobalVideo.get().alpha();
			} else {
				GlobalVideo.get().unalpha();
				//txt.text = defaultText;
			}
		}

		if(controls.CHEAT) {
			devKeyPressed = true;
		}

		#if debug
			devKeyPressed = true;
		#end
		
		// AF Enjoyer: Changing a few things so Credo cant be skipped, but lobby music can
		// Also, making it so lobby music loops
		if (((GlobalVideo.get().ended || GlobalVideo.get().stopped) && leSource != 'assets/videos/Inevitable/Inevitable.webm') || (controls.ACCEPT && leSource != 'assets/videos/Credo/Credo.webm'))
		{
			//txt.visible = false;
			GlobalVideo.get().hide();
			GlobalVideo.get().stop();
		}
		
		// AF Enjoyer: Changing a few things so Credo cant be skipped, but lobby music can
		if ((controls.ACCEPT && leSource != 'assets/videos/Credo/Credo.webm') || (GlobalVideo.get().ended && leSource != 'assets/videos/Inevitable/Inevitable.webm'))
		{
			notDone = false;
			FlxG.sound.music.volume = fuckingVolume;
			//txt.text = pauseText;
			if (musicPaused)
			{
				musicPaused = false;
				FlxG.sound.music.resume();
			}
			FlxG.autoPause = true;
			FlxG.switchState(transClass);
		}

		if(GlobalVideo.get().ended && leSource == 'assets/videos/Inevitable/Inevitable.webm') {
			GlobalVideo.get().restart();
			// AF Enjoyer: Gotta have these two lines for the sound to repeat, or else it will be silent
			useSound = true;
			vidSound = FlxG.sound.play(leSource.replace(".webm", ".ogg"));
		}

		// AF Enjoyer: If you have pressed enter, add 1 to this variable
		if(controls.ACCEPT) {
			trace('you have entered');
			numberOfEnters++;
		}
		
		if (GlobalVideo.get().played || GlobalVideo.get().restarted)
		{
			GlobalVideo.get().show();
		}
		
		GlobalVideo.get().restarted = false;
		GlobalVideo.get().played = false;
		GlobalVideo.get().stopped = false;
		GlobalVideo.get().ended = false;
	}
}
