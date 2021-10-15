import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import flixel.FlxG;

class KadeEngineData
{
    public static function initSave()
    {
		// AF Enjoyer: Gonna add another data thing here, to know if the game has ever been booted up before
		if (FlxG.save.data.hasPlayed == null)
			FlxG.save.data.hasPlayed = false;

		// AF Enjoyer: A few more here
		if(FlxG.save.data.songsUnlocked == null)
			FlxG.save.data.songsUnlocked = 0;

		if(FlxG.save.data.twitchSafety == null)
			FlxG.save.data.twitchSafety = false;

		if(FlxG.save.data.hasRevivedBefore == null)
			FlxG.save.data.hasRevivedBefore = false;

		if(FlxG.save.data.youSuck == null) {
			FlxG.save.data.youSuck = false;
		}



        if (FlxG.save.data.weekUnlocked == null)
			FlxG.save.data.weekUnlocked = 8;

		if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		// AF Enjoyer: Turning downscroll on by default, it was off
		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = true;

		if (FlxG.save.data.antialiasing == null)
			FlxG.save.data.antialiasing = true;

		if (FlxG.save.data.missSounds == null)
			FlxG.save.data.missSounds = true;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;
			
		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = false;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = false;

		if (FlxG.save.data.changedHit == null)
		{
			FlxG.save.data.changedHitX = -1;
			FlxG.save.data.changedHitY = -1;
			FlxG.save.data.changedHit = false;
		}

		if (FlxG.save.data.fpsRain == null)
			FlxG.save.data.fpsRain = false;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 120;

		if (FlxG.save.data.fpsCap > 285 || FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 120; // baby proof so you can't hard lock ur copy of kade engine
		
		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.npsDisplay == null)
			FlxG.save.data.npsDisplay = false;

		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;

		if (FlxG.save.data.accuracyMod == null)
			FlxG.save.data.accuracyMod = 1;

		// AF Enjoyer: Where the watermark is turned on by default. Might change it later
		if (FlxG.save.data.watermark == null)
			FlxG.save.data.watermark = true;

		// AF Enjoyer: Changing this option from true by default to false by default
		if (FlxG.save.data.ghost == null)
			FlxG.save.data.ghost = false;

		if (FlxG.save.data.distractions == null)
			FlxG.save.data.distractions = true;
		
		if (FlxG.save.data.stepMania == null)
			FlxG.save.data.stepMania = false;

		if (FlxG.save.data.flashing == null)
			FlxG.save.data.flashing = true;

		if (FlxG.save.data.resetButton == null)
			FlxG.save.data.resetButton = false;
		
		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;

		if (FlxG.save.data.cpuStrums == null)
			FlxG.save.data.cpuStrums = false;

		if (FlxG.save.data.strumline == null)
			FlxG.save.data.strumline = false;
		
		if (FlxG.save.data.customStrumLine == null)
			FlxG.save.data.customStrumLine = 0;

		if (FlxG.save.data.camzoom == null)
			FlxG.save.data.camzoom = true;

		if (FlxG.save.data.scoreScreen == null)
			FlxG.save.data.scoreScreen = true;

		if (FlxG.save.data.inputShow == null)
			FlxG.save.data.inputShow = false;

		if (FlxG.save.data.optimize == null)
			FlxG.save.data.optimize = false;
		
		if (FlxG.save.data.cacheImages == null)
			FlxG.save.data.cacheImages = false;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		
		KeyBinds.gamepad = gamepad != null;

		Conductor.recalculateTimings();
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();

		Main.watermarks = FlxG.save.data.watermark;

		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
	}

	public static function songUnlock(songName:String) {
		var tempNumber:Int = 0;
		switch(songName) {
			case 'they ignore you':
				tempNumber = 1;
			case 'they mock you':
				tempNumber = 2;
			case 'they fight you':
				tempNumber = 3;
			case 'you win':
				tempNumber = 4;
			default:
				return;
		}
		if(FlxG.save.data.songsUnlocked < tempNumber)
			FlxG.save.data.songsUnlocked = tempNumber;
	}
}