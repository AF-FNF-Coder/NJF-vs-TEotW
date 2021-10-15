package;

import flixel.math.FlxPoint;
import openfl.Lib;
import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.FlxCamera;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import njf.*;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	static function weekData():Array<Dynamic>
	{
		return [
			['Tutorial'],
			['Bopeebo', 'Fresh', 'Dad Battle'],
			['Spookeez', 'South', "Monster"],
			['Pico', 'Philly Nice', "Blammed"],
			['Satin Panties', "High", "Milf"],
			['Cocoa', 'Eggnog', 'Winter Horrorland'],
			['Senpai', 'Roses', 'Thorns'],
			// AF Enjoyer: BS's songs
			["They Ignore You", "They Mock You", "They Fight You", "You Win"],
			// Oceanfall's songs
			["Icicle Bay"]
		];
	}
	var curDifficulty:Int = 2;

	public static var weekUnlocked:Array<Bool> = [];

	var weekCharacters:Array<Dynamic> = [
		['', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
		['spooky', 'bf', 'gf'],
		['pico', 'bf', 'gf'],
		['mom', 'bf', 'gf'],
		['parents-christmas', 'bf', 'gf'],
		['senpai', 'bf', 'gf'],
		// AF Enjoyer: Ben Shapiro, Nick Fuentes and the third character, for now its GF
		['BS', 'NJF', 'groyper'],
		['kaji', 'mei', 'gf']
	];

	// AF Enjoyer: Added BS's Week
	var weekNames:Array<String> = CoolUtil.coolTextFile(Paths.txt('data/weekNames'));

	var txtWeekTitle:FlxText;

	var curSong:Int = 0;

	// AF Enjoyer: Adding some variables here
	public var currentSelected:String = 'they ignore you';
	public var forceSong:Bool = false;
	var selectablesList:Map<String, MenuSprite> = new Map();
	var justChanged:Bool = false;
	var storyMenuCamera:FlxCamera;
	var menuAssetsArray:Array<FlxSprite> = new Array();
	public var camFollow:FlxObject;
	var danceLeft:Bool = false;
	var week:Int = 7;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	function unlockWeeks():Array<Bool>
	{
		var weeks:Array<Bool> = [];
		#if debug
		for(i in 0...weekNames.length)
			weeks.push(true);
		return weeks;
		#end
		
		weeks.push(true);

		// AF Enjoyer: Changing so my 7th week is always unlocked
		for(i in 0...7)
			{
				weeks.push(true);
			}
		return weeks;
	}

	override function create()
	{
		if(!FlxG.sound.music.playing || forceSong) {
			//trace('its trying man');
			TitleState.playRandomAFSong();
		}

		FlxG.sound.music.looped = true;

		storyMenuCamera = new FlxCamera();
		FlxG.cameras.reset(storyMenuCamera);

		weekUnlocked = unlockWeeks();

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// AF Enjoyer: This is for the head bobbing
		Conductor.changeBPM(100);

		persistentUpdate = persistentDraw = true;

		/*
		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);
		*/










		// AF Enjoyer: Adding stuff here
		var background:FlxSprite = new FlxSprite(-1000, -1000).loadGraphic(Paths.image('menu_NJF/bg_full'));
		add(background);


		// AF Enjoyer: Lines
		// If y = yPositionOfRectangle, then horizontal line connecting that rectangle to another should be of y + 75
		var firstSongToSecondSongFullLine = new MenuAsset(100, 375, "hf-line").getSprite();
		add(firstSongToSecondSongFullLine);

		var secondSongToThirdSongFullLine = new MenuAsset(500, 375, "hf-line").getSprite();
		add(secondSongToThirdSongFullLine);

		var thirdSongToFourthSongFullLine = new MenuAsset(900, 375, "hf-line").getSprite();
		add(thirdSongToFourthSongFullLine);

		//var tutorialSongToRetrospecterTutorialSongFullLine = new MenuAsset(-150-150, 300, "vf-line").getSprite();
		//add(tutorialSongToRetrospecterTutorialSongFullLine);

		var firstSongTo1stSetOfClipsDashedLine = new MenuAsset(250, 300, "vd-line").getSprite();
		add(firstSongTo1stSetOfClipsDashedLine);

		var secondSongTo2ndSetOfClipsDashedLine = new MenuAsset(650, 300, "vd-line").getSprite();
		add(secondSongTo2ndSetOfClipsDashedLine);

		var thirdSongTo3rdSetOfClipsDashedLine = new MenuAsset(1050, 300, "vd-line").getSprite();
		add(thirdSongTo3rdSetOfClipsDashedLine);

		var fourthSongTo4thSetOfClipsDashedLine = new MenuAsset(1450, 300, "vd-line").getSprite();
		add(fourthSongTo4thSetOfClipsDashedLine);

		menuAssetsArray.push(firstSongToSecondSongFullLine);
		menuAssetsArray.push(secondSongToThirdSongFullLine);
		menuAssetsArray.push(thirdSongToFourthSongFullLine);
		//menuAssetsArray.push(tutorialSongToRetrospecterTutorialSongFullLine);
		menuAssetsArray.push(firstSongTo1stSetOfClipsDashedLine);


		// AF Enjoyer: Song rectangles

		var firstSongRectangle = new MenuSprite(100, 300, 'They_Ignore_You_Menu', "they ignore you", false, "tutorial", "they mock you", null, 'clips a');
		add(firstSongRectangle);

		var secondSongRectangle = new MenuSprite(500, 300, 'They_Mock_You_Menu', "they mock you", true, "they ignore you", "they fight you", null, 'clips b');
		add(secondSongRectangle);

		var thirdSongRectangle = new MenuSprite(900, 300, 'They_Fight_You_Menu', "they fight you", true, "they mock you", "you win", null, 'clips c');
		add(thirdSongRectangle);

		var fourthSongRectangle = new MenuSprite(1300, 300, 'You_Win_Menu', "you win", true, "they fight you", null, 'oceanfalls', 'clips d');
		add(fourthSongRectangle);

		var tutorialSongRectangle = new MenuSprite(-300-150, 300, 'Menu Assets', "tutorial", false, null, "they ignore you", null, "retrospecter tutorial", true);
		add(tutorialSongRectangle);

		//var retrospecterTutorialSongRectangle = new MenuSprite(-300-150, 700, null, "retrospecter tutorial", true, null, null, "tutorial", null);
		//add(retrospecterTutorialSongRectangle);

		var oceanfallsSongRectangle = new MenuSprite(1300, -100, 'Oceanfalls_Menu', "oceanfalls", true, null, null, null, 'you win');
		add(oceanfallsSongRectangle);

		// AF Enjoyer: Fog of war
		/*
		if(thirdSongRectangle.isInFogOfWar) {
			var fogOfWar:FlxSprite = new FlxSprite(700, -1000).loadGraphic(Paths.image('menu_NJF/Fog_Of_War_2'));
			add(fogOfWar);
		} else if(fourthSongRectangle.isInFogOfWar) {
			var fogOfWar:FlxSprite = new FlxSprite(1100, -1000).loadGraphic(Paths.image('menu_NJF/Fog_Of_War_2'));
			add(fogOfWar);
		}
		*/
		//ok fuck fog of war this shit is stupid

		// AF Enjoyer: Clips

		var firstSetOfClips = new MenuSprite(100, 700, 'Clips_Inside_Image_1', 'clips a', true, null, null, 'they ignore you', null);
		add(firstSetOfClips);

		var secondSetOfClips = new MenuSprite(500, 700, 'Clips_Inside_Image_2', 'clips b', true, null, null, 'they mock you', null);
		add(secondSetOfClips);

		var thirdSetOfClips = new MenuSprite(900, 700, 'Clips_Inside_Image_3', 'clips c', true, null, null, 'they fight you', null);
		add(thirdSetOfClips);

		var fourthSetOfClips = new MenuSprite(1300, 700, 'Clips_Inside_Image_4', 'clips d', true, null, null, "you win", null);
		add(fourthSetOfClips);


		// AF Enjoyer: Songs
		selectablesList.set(firstSongRectangle.topText, firstSongRectangle);
		selectablesList.set(secondSongRectangle.topText, secondSongRectangle);
		selectablesList.set(thirdSongRectangle.topText, thirdSongRectangle);
		selectablesList.set(fourthSongRectangle.topText, fourthSongRectangle);
		selectablesList.set(tutorialSongRectangle.topText, tutorialSongRectangle);
		//selectablesList.set(retrospecterTutorialSongRectangle.topText, retrospecterTutorialSongRectangle);
		selectablesList.set(oceanfallsSongRectangle.topText, oceanfallsSongRectangle);

		// AF Enjoyer: Clips
		selectablesList.set(firstSetOfClips.topText, firstSetOfClips);
		selectablesList.set(secondSetOfClips.topText, secondSetOfClips);
		selectablesList.set(thirdSetOfClips.topText, thirdSetOfClips);
		selectablesList.set(fourthSetOfClips.topText, fourthSetOfClips);

		// AF Enjoyer: Unlocking songs

		//trace(FlxG.save.data.songsUnlocked);
		//#if !debug
		//if(!VideoState.devKeyPressed) {
			switch(FlxG.save.data.songsUnlocked) {
				case 1:
					selectablesList.get("they mock you").unlock();
					selectablesList.get('clips a').unlock();
				case 2:
					selectablesList.get('they mock you').unlock();
					selectablesList.get('they fight you').unlock();
					selectablesList.get('clips a').unlock();
					selectablesList.get('clips b').unlock();
				case 3:
					selectablesList.get('they mock you').unlock();
					selectablesList.get('they fight you').unlock();
					selectablesList.get('you win').unlock();
					selectablesList.get('clips a').unlock();
					selectablesList.get('clips b').unlock();
					selectablesList.get('clips c').unlock();
				case 4:
					selectablesList.get('they mock you').unlock();
					selectablesList.get('they fight you').unlock();
					selectablesList.get('you win').unlock();
					selectablesList.get('oceanfalls').unlock();
					selectablesList.get('clips a').unlock();
					selectablesList.get('clips b').unlock();
					selectablesList.get('clips c').unlock();
					selectablesList.get('clips d').unlock();
			}
		#if debug
			//selectablesList.get('clips d').unlock();
			for(name => selectable in selectablesList) {
				if(name != 'tutorial')
					selectable.unlock();
			}
		#end
		//} else {
			/*
			for(name => selectable in selectablesList) {
				if(name != 'tutorial')
					selectable.unlock();
			}
			*/
		//}
		//#else
		/*
		for(name => selectable in selectablesList) {
			if(name != 'tutorial')
				selectable.unlock();
		}
		*/
		//#end


		this.cameras = [storyMenuCamera];
		storyMenuCamera.focusOn(selectablesList.get(currentSelected).getBackground().getMidpoint());
		selectablesList.get(currentSelected).expand();
		
		for(selectable in selectablesList) {
			selectable.cameras = [storyMenuCamera];
		}
		for(asset in menuAssetsArray) {
			asset.cameras = [storyMenuCamera];
		}

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(selectablesList.get(currentSelected).getBackground().getMidpoint().x, selectablesList.get(currentSelected).getBackground().getMidpoint().y);

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast(Lib.current.getChildAt(0), Main)).getFPS()));
		FlxG.camera.focusOn(camFollow.getPosition());





		
		//grpWeekText = new FlxTypedGroup<MenuItem>();
		//add(grpWeekText);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		//add(grpLocks);

		//var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		//add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);


		super.create();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		//scoreText.text = "WEEK SCORE:" + lerpScore;

		//txtWeekTitle.text = weekNames[curSong].toUpperCase();
		//txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curSong];


		checkForPossibleMoves();

		//selectablesList.get('tutorial').insideImage.update(elapsed);

		if(justChanged) {
			selectablesList.get(currentSelected).expand();
			justChanged = false;
		}



		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectSong()
	{
		//trace(curSong);
		//trace(weekUnlocked[curSong]);
		//if (weekUnlocked[week])
		//{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				selectablesList.get(currentSelected).startFlashing();
				stopspamming = true;
			}

			// AF Enjoyer: Another variable to determine if its tutorial or BS's week
			PlayState.storyPlaylist = weekData()[week];
			var songsAhead:Int = 0;
			for(song in PlayState.storyPlaylist) {
				if(song.toLowerCase() == currentSelected) {
					songsAhead = PlayState.storyPlaylist.indexOf(song);
					break;
				}
			}
			while(songsAhead != 0) {
				PlayState.storyPlaylist.remove(PlayState.storyPlaylist[0]);
				songsAhead--;
			}
			PlayState.isStoryMode = true;
			selectedWeek = true;


			PlayState.storyDifficulty = curDifficulty;

			var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}

			var poop:String = Highscore.formatSong(songFormat, curDifficulty);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			//AF Enjoyer: Wont always start from the first song now
			PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
			PlayState.storyWeek = curSong;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		//}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curSong, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curSong, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeSong(change:Int = 0):Void
	{
		curSong += change;

		if (curSong >= weekData().length)
			curSong = 0;
		if (curSong < 0)
			curSong = weekData().length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curSong;
			if (item.targetY == Std.int(0) && weekUnlocked[curSong])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curSong][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curSong][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curSong][2]);

		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData()[curSong];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curSong, curDifficulty);
		#end
	}

	public static function unlockNextWeek(week:Int):Void
	{
		if(week <= weekData().length - 1 && FlxG.save.data.weekUnlocked == week)
		{
			weekUnlocked.push(true);
			trace('Week ' + week + ' beat (Week ' + (week + 1) + ' unlocked)');
		}

		FlxG.save.data.weekUnlocked = weekUnlocked.length - 1;
		FlxG.save.flush();
	}

	override function beatHit()
	{
		super.beatHit();
		if(selectablesList.get('tutorial').insideImage != null)
			bopHead(selectablesList.get('tutorial').insideImage);

	}

	// AF Enjoyer: My functions

	function checkForPossibleMoves() {
		if (!movedBack)
			{
				if (!selectedWeek)
				{
					var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
					var temp:MenuSprite = selectablesList.get(currentSelected);
					if (gamepad != null)
					{
						if (gamepad.justPressed.DPAD_UP)
						{
							move(temp.upConnection);
						}
						if (gamepad.justPressed.DPAD_DOWN)
						{
							move(temp.downConnection);
						}
	
						if (gamepad.justPressed.DPAD_RIGHT) {
							move(temp.rightConnection);
						}
						if (gamepad.justPressed.DPAD_LEFT) {
							move(temp.leftConnection);
						}
					}
	
					if (FlxG.keys.justPressed.UP)
					{
						move(temp.upConnection);
					}
	
					if (FlxG.keys.justPressed.DOWN)
					{
						move(temp.downConnection);
					}

					if (FlxG.keys.justPressed.RIGHT)
					{
						move(temp.rightConnection);
					}

					if (FlxG.keys.justPressed.LEFT)
					{
						move(temp.leftConnection);
					}

					// AF Enjoyer: Look, i dont know if there is a better way ok, dont judge me
					switch(currentSelected) {
						case 'they ignore you':
							curSong = 0;
							week = 7;
						case 'they mock you':
							curSong = 1;
							week = 7;
						case 'they fight you':
							curSong = 2;
							week = 7;
						case 'you win':
							curSong = 3;
							week = 7;
						case 'tutorial':
							curSong = 0;
							week = 0;
						case 'oceanfalls':
							curSong = 0;
							week = 8;
					}

					if(currentSelected.startsWith('clips')) {
						curSong = -1;
						week = -1;
					}
				}
	
				if (controls.ACCEPT)
				{
					if(curSong != -1 && week != -1) {
						selectSong();
					} else {
						var clipsGallery:ClipsGalleryState = new ClipsGalleryState();
						clipsGallery.clipsMenu = selectablesList.get(currentSelected).topText.split(" ")[1].toUpperCase();
						//trace('BRUH LOOK: ' + clipsGallery.clipsMenu);
						switch(clipsGallery.clipsMenu) {
							case 'A':
								clipsGallery.currentSelected = 'Debate Nick Fuentes';
							case 'B':
								clipsGallery.currentSelected = 'Why Other Streamers Suck';
							case 'C':
								clipsGallery.currentSelected = 'Lego Nick';
							case 'D':
								clipsGallery.currentSelected = 'Stupid Bitch';
						}
						LoadingState.loadAndSwitchState(clipsGallery, true);
					}
				}
			}
	}

	private function move(connection:String) {
		var temp:Dynamic = selectablesList.get(currentSelected);
		var camMidPoint:FlxPoint;

		if(connection != null && selectablesList.get(connection) != null && !selectablesList.get(connection).isLocked) {
				FlxG.sound.play(Paths.sound('scrollMenu'));

				temp.retract();

				currentSelected = connection;
				temp = selectablesList.get(currentSelected);

				camMidPoint = temp.getBackground().getMidpoint();
				camFollow.setPosition(camMidPoint.x, camMidPoint.y);
				justChanged = true;
		}
	}

	public function bopHead(animationSprite:FlxSprite, LastFrame:Bool = false):Void {
		danceLeft = !danceLeft;
	
		if (danceLeft)
			animationSprite.animation.play("danceLeft", true);
		else
			animationSprite.animation.play("danceRight", true);
			
		if (LastFrame) {
			animationSprite.animation.finish();
		}
	}

}
