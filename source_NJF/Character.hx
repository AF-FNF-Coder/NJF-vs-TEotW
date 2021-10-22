package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		if(FlxG.save.data.antialiasing)
		{
			antialiasing = true;
		}

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('GF_assets','shared',true);
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('gfChristmas','shared',true);
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('gfCar','shared',true);
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('gfPixel','shared',true);
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('DADDY_DEAREST','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('spooky_kids_assets','shared',true);
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('Mom_Assets','shared',true);
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('momCar','shared',true);
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('Monster_Assets','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('monsterChristmas','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('Pico_FNF_assetss','shared',true);
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('BOYFRIEND','shared',true);
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('bfChristmas','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('bfCar','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('bfPixel','shared',true);
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('bfPixelsDEAD','shared',true);
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, false);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				loadOffsetFile(curCharacter);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('senpai','shared',true);
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('senpai','shared',true);
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('spirit','shared',true);
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':

				frames = Paths.getSparrowAtlas('mom_dad_christmas_assets','shared',true);
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			// AF Enjoyer: Adding support for all the characters
			case 'NJF':
				tex = Paths.getSparrowAtlas('NJF/NJF_assets1');
				frames = tex;

				animation.addByPrefix('idle', 'Nick Idle', 24, false);
				animation.addByPrefix('singUP', 'Nick Up0', 24, false);
				animation.addByPrefix('singDOWN', 'Nick Down0', 24, false);
				animation.addByPrefix('singLEFT', 'Nick Left0', 24, false);
				animation.addByPrefix('singRIGHT', 'Nick Right0', 24, false);
				animation.addByPrefix('singUPmiss', 'Nick Up Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Nick Left Miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Nick Right Miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Nick Down Miss', 24, false);

				animation.addByPrefix('firstDeath', "Nick Death Sprite", 24, false);
				animation.addByPrefix('deathLoop', "Nick Death Loop", 24, true);
				animation.addByPrefix('deathConfirm', "Nick Death Confirm", 24, false);
				animation.addByPrefix('Stalemate', 'Nick Stalemate', 24, true);

				
				addOffset('idle');
				addOffset("singUP", -96, 7); //y used to be 11
				addOffset("singRIGHT", -144); //x used to be -140
				addOffset("singLEFT", -31, -12); //used to be -14, 2
				addOffset("singDOWN", -135, -24); //used to be -133, -14
				addOffset("singUPmiss", -98, 28);
				addOffset("singRIGHTmiss", -141, 37); 
				addOffset("singLEFTmiss", -5, 13); 
				addOffset("singDOWNmiss", -132, 15); 
				// AF Enjoyer: For X, Adding makes the character go LEFT and subtracting makes them go RIGHT
				// For Y,  Adding makes the character go UP and subtracting makes them go DOWN
				addOffset('firstDeath', 81, 99 + 0.5);
				addOffset('deathLoop', 80-51, 99-114); //Seems to line up
				addOffset('deathConfirm', 80-44, 99+43); //Is good
				addOffset('Stalemate', -107, -18);

				playAnim('firstDeath');
				playAnim('idle');
				
				flipX = true;
			case 'BS':
				tex = Paths.getSparrowAtlas('NJF/BS_Assets');
				frames = tex;
	
				animation.addByPrefix('idle', 'BS Idle', 24, false);
				animation.addByPrefix('singUP', 'BS Up', 24, false);
				animation.addByPrefix('singDOWN', 'BS Down', 24, false);
				animation.addByPrefix('singLEFT', 'BS Left', 24, false);
				animation.addByPrefix('singRIGHT', 'BS Right', 24, false);
	
				addOffset('idle', -85, -75);
				addOffset("singUP", -85-2, -75-10);
				addOffset("singRIGHT", -85+2, -75-19); 
				addOffset("singLEFT", -85+29, -75-19); 
				addOffset("singDOWN", -85+9, -75-16);
	
				playAnim('idle');
			case 'groyper':
				tex = Paths.getSparrowAtlas('NJF/groyper');
				frames = tex;
				animation.addByIndices('singUP', 'Groyper', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'Groyper', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Groyper', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	
				addOffset('singUP');
				addOffset("danceLeft");
				addOffset("danceRight"); 
	
				playAnim('danceRight');
	
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = true;
			case 'groyper-menu':
				tex = Paths.getSparrowAtlas('menu_NJF/Menu Assets');
				frames = tex;
				animation.addByIndices('singUP', 'Tutorial_Menu', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'Tutorial_Menu', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Tutorial_Menu', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	
				addOffset('singUP');
				addOffset("danceLeft");
				addOffset("danceRight"); 
	
				playAnim('danceRight', true);
	
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = true;
			case 'kaji':
				tex = Paths.getSparrowAtlas('NJF/Kaji_Pyxis');
				frames = tex;
	
				animation.addByPrefix('idle', 'Kaji_Idle', 24, false);
				animation.addByPrefix('singUP', 'Up_Arrow_Kaji', 24, false);
				animation.addByPrefix('singDOWN', 'Down_Arrow_Kaji', 24, false);
				animation.addByPrefix('singLEFT', 'Left_Arrow_Kaji', 24, false);
				animation.addByPrefix('singRIGHT', 'Right_Arrow_Kaji', 24, false);
	
				addOffset('idle', -77, 92);
				addOffset("singUP", -79, 116);
				addOffset("singRIGHT", -91, 101); 
				addOffset("singLEFT", -66, 89); 
				addOffset("singDOWN", -77, 81); 
	
				playAnim('idle');
			case 'mei':
				tex = Paths.getSparrowAtlas('NJF/Meimona_Corvus');
				frames = tex;

				animation.addByPrefix('idle', 'Mei_Idle', 24, false);
				animation.addByPrefix('singUP', 'Up_Arrow_Mei', 24, false);
				animation.addByPrefix('singDOWN', 'Down_Arrow_Mei', 24, false);
				animation.addByPrefix('singLEFT', 'Left_Arrow_Mei', 24, false);
				animation.addByPrefix('singRIGHT', 'Right_Arrow_Mei', 24, false);
				animation.addByPrefix('singUPmiss', 'Miss_Up_Arrow_Mei', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Miss_Left_Arrow_Mei', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Miss_Right_Arrow_Mei', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Miss_Down_Arrow_Mei', 24, false);

				animation.addByPrefix('firstDeath', "Mei_Dies", 24, false);
				animation.addByPrefix('deathLoop', "Mei_Dead_Loop", 24, true);
				animation.addByPrefix('deathConfirm', "Mei_Retry", 24, false);

				
				addOffset('idle', 3, -3);
				addOffset("singUP", 98, 4);
				addOffset("singRIGHT", -12, 0);
				addOffset("singLEFT", 211, -4);
				addOffset("singDOWN", 5, -13);
				addOffset("singUPmiss", 94, 4);
				addOffset("singRIGHTmiss", -8, 0);
				addOffset("singLEFTmiss", 211, -4);
				addOffset("singDOWNmiss", 6, -13);
				// AF Enjoyer: For X, Adding makes the character go LEFT and subtracting makes them go RIGHT
				// For Y,  Adding makes the character go UP and subtracting makes them go DOWN
				addOffset('firstDeath', 34, 23);
				addOffset('deathLoop', 17, -8);
				addOffset('deathConfirm', 99, 177);

				playAnim('idle');
				
				flipX = true;
			case 'bgCharacters':
				frames = Paths.getSparrowAtlas('NJF/Background_Characters');
				animation.addByPrefix('trance', 'Background Characters', 24, true);
				playAnim('trance');
			case 'groyper_scared':
				tex = Paths.getSparrowAtlas('NJF/groyper_scared');
				frames = tex;
				animation.addByIndices('singUP', 'Groyper_Scared', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'Groyper_Scared', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Groyper_Scared', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	
				addOffset('singUP');
				addOffset("danceLeft");
				addOffset("danceRight"); 
	
				playAnim('danceRight');
	
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
			case 'BS_angry':
				tex = Paths.getSparrowAtlas('NJF/BS_Assets_Angry');
				frames = tex;
	
				animation.addByPrefix('idle', 'BS Idle Angry', 24, false);
				animation.addByPrefix('singUP', 'BS Up Angry', 24, false);
				animation.addByPrefix('singDOWN', 'BS Down Angry', 24, false);
				animation.addByPrefix('singLEFT', 'BS Left Angry', 24, false);
				animation.addByPrefix('singRIGHT', 'BS Right Angry', 24, false);
				animation.addByPrefix('Stalemate', 'BS Stalemate', 24, true);

				addOffset('idle', -85, -75);
				addOffset("singUP", -85-2, -75-10);
				addOffset("singRIGHT", -85+2, -75-19); 
				addOffset("singLEFT", -85+29, -75-19); 
				addOffset("singDOWN", -85+9, -75-16);
				addOffset('Stalemate', -107, -92);

				playAnim('idle');
			case 'BS_exploded':
				tex = Paths.getSparrowAtlas('NJF/BS_Assets_Exploded');
				frames = tex;
	
				animation.addByPrefix('Explode', 'BS Explode1', 24, false);
				animation.addByPrefix('idle', 'BS Exploded', 24, false);
				animation.addByPrefix('singUP', 'BS Exploded', 24, false);
				animation.addByPrefix('singDOWN', 'BS Exploded', 24, false);
				animation.addByPrefix('singLEFT', 'BS Exploded', 24, false);
				animation.addByPrefix('singRIGHT', 'BS Exploded', 24, false);
				animation.addByPrefix('falling', 'BS Falling', 24, false);
				
				var xOffset:Int = -130;
				var yOffset:Int = -153;

				addOffset('Explode', 52, 321);
				addOffset('idle', xOffset, yOffset);
				addOffset("singUP", xOffset, yOffset);
				addOffset("singRIGHT", xOffset, yOffset); 
				addOffset("singLEFT", xOffset, yOffset); 
				addOffset("singDOWN", xOffset, yOffset);
				addOffset('falling', -129, -167);

				playAnim('Explode', true);
			}



		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			// AF Enjoyer: Added support for NJF, the other player1
			if (!curCharacter.startsWith('bf') && !curCharacter.startsWith("NJF") && !curCharacter.startsWith("mei"))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public function loadOffsetFile(character:String)
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.txt('images/characters/' + character + "Offsets", 'shared'));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	// AF Enjoyer: Added support for NJF
	// and mei
	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf')  && !curCharacter.startsWith("NJF") && !curCharacter.startsWith("mei"))
		{
			if (animation.curAnim != null && animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				//trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(forced:Bool = false)
	{
		if (!debugMode)
		{
			//trace('curCharacter: ' + curCharacter);
			switch (curCharacter)
			{
				// AF Enjoyer: Added groyper support
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel' | 'groyper' | 'groyper-menu' | 'groyper_scared':
					if (animation.curAnim != null && !animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;
						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'spooky':
					danced = !danced;
					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				// AF Enjoyer: Gotta add one for exploded ben shapiro
				case 'BS_exploded':
					if(!PlayState.instance.fall) {
						if(!PlayState.instance.playExplodedAnimation) {
							playAnim('Explode', true);
							//trace('ben shapiro exploded dancing1');
						} else {
							playAnim('idle');
							//trace('ben shapiro exploded dancing2');
						}
					} else {

					}
				default:
					playAnim('idle', forced);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
