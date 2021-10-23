package njf;

import flixel.FlxBasic;
import haxe.Exception;
import haxe.DynamicAccess;
import haxe.Json;
import sys.io.File;
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

/**
	This is the state used for the clips gallery.
**/
class ClipsGalleryState extends MusicBeatState
{

	var curClip:Int = 0;
	var viewingVid:Bool = false;

	public var currentSelected:String = 'Debate Nick Fuentes';
	var selectablesList:Map<String, VideoClipSprite> = new Map();
	var justChanged:Bool = false;
	var clipGalleryCamera:FlxCamera;
	var menuAssetsArray:Array<FlxSprite> = new Array();
	public var camFollow:FlxObject;
	var danceLeft:Bool = false;
	var background:FlxSprite;
	var header:FlxSprite;
	public var currentlySelecting:Bool = false;
	var imageToDisplay:FlxSprite;
	var blackRectangle1:FlxSprite;
	var blackRectangle2:FlxSprite;
	public var clipsMenu:String = 'A';

	var hugeBlackBox:FlxSprite;

	override function create()
	{
		hugeBlackBox = new FlxSprite(-100, -100).makeGraphic(2000, 1000, FlxColor.BLACK);
		hugeBlackBox.scrollFactor.set();

		clipGalleryCamera = new FlxCamera();
		FlxG.cameras.reset(clipGalleryCamera);


		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Clips Gallery", null);
		#end

		persistentUpdate = persistentDraw = true;


		background = new FlxSprite(0, 0).loadGraphic(Paths.image('menu_NJF/gallery_bg'));
		add(background);

		header = new FlxSprite(0, 0).loadGraphic(Paths.image('menu_NJF/header_bg'));
		add(header);

		// Clips:
		var clip1:String;
		var clip2:String;
		var clip3:String;
		var clip4:String;
		var clip5:String;
		var clip6:String;
		var clip7:String;
		var clip8:String;
		var clip9:String;
		var clip10:String;
		var clip11:String;
		var clip12:String;
		var clip13:String;
		var clip14:String;
		var clip15:String;
		var clip16:String;
		var clip17:String;
		var clip18:String;
		var clip19:String;
		var clip20:String;
		var clip21:String;
		var clip22:String;
		switch(clipsMenu) {
			case 'A':
			clip1 = 'POV: Woman';
			clip2 = 'Adrenaline';
			clip3 = 'And Youre Right';
			clip4 = 'But We Do';
			clip5 = 'Communism Is Better';
			clip6 = 'Democrat Debate';
			clip7 = 'Documentary Trailer';
			clip8 = 'E-Girls';
			clip9 = 'Foreign Policy';
			clip10 = 'GTA Shapiro';
			clip11 = 'Japanese Nick';
			clip12 = 'Oh No';
			clip13 = 'Pit Vipers';
			clip14 = 'Trillion Ballots';
			clip15 = 'Vaush VS Kirk';
			clip16 = 'Vindicated';
			clip17 = 'Debate Nick Fuentes';
			clip18 = 'Dont Care Didnt Ask';
			clip19 = 'Keemstar Ratio';
			clip20 = 'Minecraft Expert';
			clip21 = 'Elliot Rodger Kills You';
			clip22 = 'Cardi B';
			//left 1, top
			var clip_sprite1:VideoClipSprite = new VideoClipSprite(100, 450, 'pov_woman', clip1,
			true, true, false, true, false, clip3, clip18, null, clip8);
			selectablesList.set(clip_sprite1.topText, clip_sprite1);
			//right 1, top
			var clip_sprite2:VideoClipSprite = new VideoClipSprite(900, 450, 'adrenaline', clip2,
			true, true, true, false, false, clip18, clip4, null, clip10);
			selectablesList.set(clip_sprite2.topText, clip_sprite2);
			//left 2, top
			var clip_sprite3:VideoClipSprite = new VideoClipSprite(-300, 450, 'and_youre_right', clip3,
			false, true, false, true, false, null, clip1, null, clip9);
			selectablesList.set(clip_sprite3.topText, clip_sprite3);
			//right 2, top
			var clip_sprite4:VideoClipSprite = new VideoClipSprite(1300, 450, 'but_we_do', clip4,
			true, true, false, true, false, clip2, clip5, null, clip11);
			selectablesList.set(clip_sprite4.topText, clip_sprite4);
			//right 3, top
			var clip_sprite5:VideoClipSprite = new VideoClipSprite(1700, 450, 'communism_is_better', clip5,
			false, true, true, true, false, clip4, clip6, null, clip19);
			selectablesList.set(clip_sprite5.topText, clip_sprite5);
			//right 4, top
			var clip_sprite6:VideoClipSprite = new VideoClipSprite(2100, 450, 'democrat_debate_moments', clip6,
			true, true, false, true, false, clip5, null, null, clip12);
			selectablesList.set(clip_sprite6.topText, clip_sprite6);
			//center, down 1
			var clip_sprite7:VideoClipSprite = new VideoClipSprite(500, 700, 'documentary_trailer', clip7,
			false, true, true, false, false, clip8, clip10, clip18, clip13);
			selectablesList.set(clip_sprite7.topText, clip_sprite7);

			//left 1, down 1
			var clip_sprite8:VideoClipSprite = new VideoClipSprite(100, 700, 'e-girls_not_even_once', clip8,
			false, true, false, true, false, clip9, clip7, clip1, clip14);
			selectablesList.set(clip_sprite8.topText, clip_sprite8);
			//left 2, down 1
			var clip_sprite9:VideoClipSprite = new VideoClipSprite(-300, 700, 'foreign_policy', clip9,
			false, true, false, true, false, null, clip8, clip3, clip15);
			selectablesList.set(clip_sprite9.topText, clip_sprite9);
			//right 1, down 1
			var clip_sprite10:VideoClipSprite = new VideoClipSprite(900, 700, 'gta_shapiro', clip10,
			true, true, false, true, false, clip7, clip11, clip2, clip16);
			selectablesList.set(clip_sprite10.topText, clip_sprite10);
			//right 2, down 1
			var clip_sprite11:VideoClipSprite = new VideoClipSprite(1300, 700, 'japanese_nick', clip11,
			false, true, false, true, false, clip10, clip19, clip4, clip20);
			selectablesList.set(clip_sprite11.topText, clip_sprite11);
			//right 4, down 1
			var clip_sprite12:VideoClipSprite = new VideoClipSprite(2100, 700, 'oh_no', clip12,
			true, true, false, true, false, clip19, null, clip6, clip22);
			selectablesList.set(clip_sprite12.topText, clip_sprite12);
			//center, down 2
			var clip_sprite13:VideoClipSprite = new VideoClipSprite(500, 950, 'pit_vipers', clip13,
			false, true, false, true, false, clip14, clip16, clip7, null);
			selectablesList.set(clip_sprite13.topText, clip_sprite13);
			//left 1, down 2
			var clip_sprite14:VideoClipSprite = new VideoClipSprite(100, 950, 'trillion_mail-in_ballots', clip14,
			true, true, true, true, false, clip15, clip13, clip8, null);
			selectablesList.set(clip_sprite14.topText, clip_sprite14);
			//left 2, down 2
			var clip_sprite15:VideoClipSprite = new VideoClipSprite(-300, 950, 'vaush_vs_kirk', clip15,
			false, true, false, true, false, null, clip14, clip9, null);
			selectablesList.set(clip_sprite15.topText, clip_sprite15);
			//right 1, down 2
			var clip_sprite16:VideoClipSprite = new VideoClipSprite(900, 950, 'vindicated_vs_destiny', clip16,
			false, true, true, false, false, clip13, clip20, clip10, null);
			selectablesList.set(clip_sprite16.topText, clip_sprite16);
			

			// Images:

			//center, up 1
			var clip_sprite17:VideoClipSprite = new VideoClipSprite(500, 200, 'debate_nick_fuentes', clip17,
			false, false, true, true, false, null, null, null, clip18);
			selectablesList.set(clip_sprite17.topText, clip_sprite17);
			//center, top
			var clip_sprite18:VideoClipSprite = new VideoClipSprite(500, 450, 'dont_care_didnt_ask_blocked', clip18,
			false, false, false, true, true, clip1, clip2, clip17, clip7);
			selectablesList.set(clip_sprite18.topText, clip_sprite18);
			//right 3, down 1
			var clip_sprite19:VideoClipSprite = new VideoClipSprite(1700, 700, 'keemstar_ratio', clip19,
			false, false, false, false, false, clip11, clip12, clip5, clip21);
			selectablesList.set(clip_sprite19.topText, clip_sprite19);
			//right 2, down 2
			var clip_sprite20:VideoClipSprite = new VideoClipSprite(1300, 950, 'minecraft_expert', clip20,
			false, false, false, true, false, clip16, clip21, clip11, null);
			selectablesList.set(clip_sprite20.topText, clip_sprite20);

			var clip_sprite21:VideoClipSprite = new VideoClipSprite(1700, 950, 'elliot_rodger_kills_you', clip21,
			false, true, false, true, true, clip20, clip22, clip19, null);
			selectablesList.set(clip_sprite21.topText, clip_sprite21);

			var clip_sprite22:VideoClipSprite = new VideoClipSprite(2100, 950, 'cardi_b', clip22,
			false, true, false, true, false, clip21, null, clip12, null);
			selectablesList.set(clip_sprite22.topText, clip_sprite22);

			// Have a single image at (500, 200), it will be the center. Put bigger names in the center
			// One line at y=450, with 400 spacing horizontally
		
			case 'B':
				clip1 = 'Doc Part One';
				clip2 = 'MK x NJF';
				clip3 = 'Streamer x NJF';
				clip4 = 'Free Speech';
				clip5 = 'AFPAC II';
				clip6 = 'Starting To Notice';
				clip7 = 'Zoomers Vs Boomers';
				clip8 = 'Funny Clips I';
				clip9 = 'Go Off Moments II';
				clip10 = 'AFPAC Speech';
				clip11 = 'NGE AF Intro';
				clip12 = 'White And Black Pills';
				clip13 = 'White People';
				clip14 = 'Love Superchatters';
				clip15 = 'One Thousand Years';
				clip16 = 'The Women';
				clip17 = 'Why Other Streamers Suck';
				clip18 = 'Women Talking';
				clip19 = 'You Cant Stop Me';
				clip20 = 'Funny Clips II';
				clip21 = 'Bubbly Ad';
				clip22 = 'Fallout Heads';
				//left 1, top
				var clip_sprite1:VideoClipSprite = new VideoClipSprite(100, 450, 'documentary_part_1', clip1,
				false, true, true, false, false, clip3, clip18, null, clip8, 'B');
				selectablesList.set(clip_sprite1.topText, clip_sprite1);
				//right 1, top
				var clip_sprite2:VideoClipSprite = new VideoClipSprite(900, 450, 'mk_x_njf', clip2,
				true, true, false, false, false, clip18, clip4, null, clip10, 'B');
				selectablesList.set(clip_sprite2.topText, clip_sprite2);
				//left 2, top
				var clip_sprite3:VideoClipSprite = new VideoClipSprite(-300, 450, 'streamer_x_njf', clip3,
				true, true, false, false, false, null, clip1, null, clip9, 'B');
				selectablesList.set(clip_sprite3.topText, clip_sprite3);
				//right 2, top
				var clip_sprite4:VideoClipSprite = new VideoClipSprite(1300, 450, 'free_speech', clip4,
				false, false, true, true, false, clip2, clip5, null, clip11, 'B');
				selectablesList.set(clip_sprite4.topText, clip_sprite4);
				//right 3, top
				var clip_sprite5:VideoClipSprite = new VideoClipSprite(1700, 450, 'afpac_2', clip5,
				false, true, true, false, false, clip4, clip6, null, clip19, 'B');
				selectablesList.set(clip_sprite5.topText, clip_sprite5);
				//right 4, top
				var clip_sprite6:VideoClipSprite = new VideoClipSprite(2100, 450, 'starting_to_notice', clip6,
				false, true, false, false, false, clip5, null, null, clip12, 'B');
				selectablesList.set(clip_sprite6.topText, clip_sprite6);
				//center, down 1
				var clip_sprite7:VideoClipSprite = new VideoClipSprite(500, 700, 'zoomers_vs_boomers', clip7,
				false, true, true, true, false, clip8, clip10, clip18, clip13, 'B');
				selectablesList.set(clip_sprite7.topText, clip_sprite7);
	
				//left 1, down 1
				var clip_sprite8:VideoClipSprite = new VideoClipSprite(100, 700, 'funny_clips_1', clip8,
				true, true, false, true, false, clip9, clip7, clip1, clip14, 'B');
				selectablesList.set(clip_sprite8.topText, clip_sprite8);
				//left 2, down 1
				var clip_sprite9:VideoClipSprite = new VideoClipSprite(-300, 700, 'go_off_moments_2', clip9,
				true, true, false, true, false, null, clip8, clip3, clip15, 'B');
				selectablesList.set(clip_sprite9.topText, clip_sprite9);
				//right 1, down 1
				var clip_sprite10:VideoClipSprite = new VideoClipSprite(900, 700, 'afpac_speech', clip10,
				false, true, true, false, false, clip7, clip11, clip2, clip16, 'B');
				selectablesList.set(clip_sprite10.topText, clip_sprite10);
				//right 2, down 1
				var clip_sprite11:VideoClipSprite = new VideoClipSprite(1300, 700, 'nge_af_intro', clip11,
				true, true, false, true, false, clip10, clip19, clip4, clip20, 'B');
				selectablesList.set(clip_sprite11.topText, clip_sprite11);
				//right 4, down 1
				var clip_sprite12:VideoClipSprite = new VideoClipSprite(2100, 700, 'white_and_black_pills', clip12,
				true, true, false, true, false, clip19, null, clip6, clip22, 'B');
				selectablesList.set(clip_sprite12.topText, clip_sprite12);
				//center, down 2
				var clip_sprite13:VideoClipSprite = new VideoClipSprite(500, 950, 'white_people', clip13,
				true, true, true, false, false, clip14, clip16, clip7, null, 'B');
				selectablesList.set(clip_sprite13.topText, clip_sprite13);
				//left 1, down 2
				var clip_sprite14:VideoClipSprite = new VideoClipSprite(100, 950, 'nick_loves_superchatters', clip14,
				false, true, false, true, false, clip15, clip13, clip8, null, 'B');
				selectablesList.set(clip_sprite14.topText, clip_sprite14);
				//left 2, down 2
				var clip_sprite15:VideoClipSprite = new VideoClipSprite(-300, 950, '1000_years_for_the_woman', clip15,
				false, true, true, true, false, null, clip14, clip9, null, 'B');
				selectablesList.set(clip_sprite15.topText, clip_sprite15);
				//right 1, down 2
				var clip_sprite16:VideoClipSprite = new VideoClipSprite(900, 950, 'the_women', clip16,
				true, true, true, true, false, clip13, clip20, clip10, null, 'B');
				selectablesList.set(clip_sprite16.topText, clip_sprite16);
				
	
				// Images:
	
				//center, up 1
				var clip_sprite17:VideoClipSprite = new VideoClipSprite(500, 200, 'why_other_streamers_suck', clip17,
				true, true, true, true, false, null, null, null, clip18, 'B');
				selectablesList.set(clip_sprite17.topText, clip_sprite17);
				//center, top
				var clip_sprite18:VideoClipSprite = new VideoClipSprite(500, 450, 'women_talking', clip18,
				true, true, false, true, false, clip1, clip2, clip17, clip7, 'B');
				selectablesList.set(clip_sprite18.topText, clip_sprite18);
				//right 3, down 1
				var clip_sprite19:VideoClipSprite = new VideoClipSprite(1700, 700, 'you_cant_stop_me', clip19,
				false, true, false, false, false, clip11, clip12, clip5, clip21, 'B');
				selectablesList.set(clip_sprite19.topText, clip_sprite19);
				//right 2, down 2
				var clip_sprite20:VideoClipSprite = new VideoClipSprite(1300, 950, 'funny_clips_2', clip20,
				false, true, false, true, false, clip16, clip21, clip11, null, 'B');
				selectablesList.set(clip_sprite20.topText, clip_sprite20);
	
				var clip_sprite21:VideoClipSprite = new VideoClipSprite(1700, 950, 'bubbly_ad', clip21,
				true, true, false, true, false, clip20, clip22, clip19, null, 'B');
				selectablesList.set(clip_sprite21.topText, clip_sprite21);
	
				var clip_sprite22:VideoClipSprite = new VideoClipSprite(2100, 950, 'fallout_heads', clip22,
				false, true, false, true, false, clip21, null, clip12, null, 'B');
				selectablesList.set(clip_sprite22.topText, clip_sprite22);
				
			case 'C':
				clip1 = 'Keep Typing';
				clip2 = 'Embarrassing';
				clip3 = 'Mentioning Israel';
				clip4 = 'Name The Elites';
				clip5 = 'AOC Booba';
				clip6 = 'So True';
				clip7 = 'Women In Politics';
				clip8 = 'Among Us';
				clip9 = 'STFU Women';
				clip10 = 'Trans Surgery';
				clip11 = 'What Are You Gonna Do';
				clip12 = 'Blacks And White';
				clip13 = 'Go Off Moments I';
				clip14 = 'Kneel On Your Neck';
				clip15 = 'Pee Pee Poo Poo';
				clip16 = 'False Flag Predicted';
				clip17 = 'Lego Nick';
				clip18 = 'No Feminists';
				clip19 = 'RNC Day Three';
				clip20 = 'Gymcels';
				clip21 = 'Corps Pushing Feminism';
				clip22 = 'Poo Poo';
				//left 1, top
				var clip_sprite1:VideoClipSprite = new VideoClipSprite(100, 450, 'keep_typing', clip1,
				true, true, false, true, true, clip3, clip18, null, clip8, clipsMenu);
				selectablesList.set(clip_sprite1.topText, clip_sprite1);
				//right 1, top
				var clip_sprite2:VideoClipSprite = new VideoClipSprite(900, 450, 'you_should_be_embarrassed', clip2,
				false, true, false, false, true, clip18, clip4, null, clip10, clipsMenu);
				selectablesList.set(clip_sprite2.topText, clip_sprite2);
				//left 2, top
				var clip_sprite3:VideoClipSprite = new VideoClipSprite(-300, 450, 'mentioning_israel', clip3,
				false, true, false, true, false, null, clip1, null, clip9, clipsMenu);
				selectablesList.set(clip_sprite3.topText, clip_sprite3);
				//right 2, top
				var clip_sprite4:VideoClipSprite = new VideoClipSprite(1300, 450, 'name_the_elites', clip4,
				true, true, false, true, false, clip2, clip5, null, clip11, clipsMenu);
				selectablesList.set(clip_sprite4.topText, clip_sprite4);
				//right 3, top
				var clip_sprite5:VideoClipSprite = new VideoClipSprite(1700, 450, 'aoc_booba', clip5,
				false, true, false, true, false, clip4, clip6, null, clip19, clipsMenu);
				selectablesList.set(clip_sprite5.topText, clip_sprite5);
				//right 4, top
				var clip_sprite6:VideoClipSprite = new VideoClipSprite(2100, 450, 'so_true', clip6,
				false, true, false, false, true, clip5, null, null, clip12, clipsMenu);
				selectablesList.set(clip_sprite6.topText, clip_sprite6);
				//center, down 1
				var clip_sprite7:VideoClipSprite = new VideoClipSprite(500, 700, 'women_in_politics', clip7,
				true, true, true, false, false, clip8, clip10, clip18, clip13, clipsMenu);
				selectablesList.set(clip_sprite7.topText, clip_sprite7);

				//left 1, down 1
				var clip_sprite8:VideoClipSprite = new VideoClipSprite(100, 700, 'among_us', clip8,
				false, true, false, true, false, clip9, clip7, clip1, clip14, clipsMenu);
				selectablesList.set(clip_sprite8.topText, clip_sprite8);
				//left 2, down 1
				var clip_sprite9:VideoClipSprite = new VideoClipSprite(-300, 700, 'stfu_women', clip9,
				true, true, false, true, true, null, clip8, clip3, clip15, clipsMenu);
				selectablesList.set(clip_sprite9.topText, clip_sprite9);
				//right 1, down 1
				var clip_sprite10:VideoClipSprite = new VideoClipSprite(900, 700, 'trans_surgery', clip10,
				true, true, false, true, false, clip7, clip11, clip2, clip16, clipsMenu);
				selectablesList.set(clip_sprite10.topText, clip_sprite10);
				//right 2, down 1
				var clip_sprite11:VideoClipSprite = new VideoClipSprite(1300, 700, 'what_r_u_gonna_do', clip11,
				true, true, false, true, false, clip10, clip19, clip4, clip20, clipsMenu);
				selectablesList.set(clip_sprite11.topText, clip_sprite11);
				//right 4, down 1
				var clip_sprite12:VideoClipSprite = new VideoClipSprite(2100, 700, 'blacks_and_rw_whites', clip12,
				true, true, true, true, false, clip19, null, clip6, clip22, clipsMenu);
				selectablesList.set(clip_sprite12.topText, clip_sprite12);
				//center, down 2
				var clip_sprite13:VideoClipSprite = new VideoClipSprite(500, 950, 'go_off_moments_1', clip13,
				true, true, true, true, false, clip14, clip16, clip7, null, clipsMenu);
				selectablesList.set(clip_sprite13.topText, clip_sprite13);
				//left 1, down 2
				var clip_sprite14:VideoClipSprite = new VideoClipSprite(100, 950, 'kneel_on_your_neck', clip14,
				true, true, false, true, false, clip15, clip13, clip8, null, clipsMenu);
				selectablesList.set(clip_sprite14.topText, clip_sprite14);
				//left 2, down 2
				var clip_sprite15:VideoClipSprite = new VideoClipSprite(-300, 950, 'pee_pee_poo_poo', clip15,
				false, true, false, true, false, null, clip14, clip9, null, clipsMenu);
				selectablesList.set(clip_sprite15.topText, clip_sprite15);
				//right 1, down 2
				var clip_sprite16:VideoClipSprite = new VideoClipSprite(900, 950, 'predict_the_false_flag', clip16,
				false, true, true, false, false, clip13, clip20, clip10, null, clipsMenu);
				selectablesList.set(clip_sprite16.topText, clip_sprite16);
				

				//center, up 1
				var clip_sprite17:VideoClipSprite = new VideoClipSprite(500, 200, 'lego_nick', clip17,
				false, false, true, true, false, null, null, null, clip18, clipsMenu);
				selectablesList.set(clip_sprite17.topText, clip_sprite17);
				//center, top
				var clip_sprite18:VideoClipSprite = new VideoClipSprite(500, 450, 'remember_no_feminists', clip18,
				true, true, false, true, false, clip1, clip2, clip17, clip7, clipsMenu);
				selectablesList.set(clip_sprite18.topText, clip_sprite18);
				//right 3, down 1
				var clip_sprite19:VideoClipSprite = new VideoClipSprite(1700, 700, 'rnc_day_3', clip19,
				true, true, false, true, false, clip11, clip12, clip5, clip21, clipsMenu);
				selectablesList.set(clip_sprite19.topText, clip_sprite19);
				//right 2, down 2
				var clip_sprite20:VideoClipSprite = new VideoClipSprite(1300, 950, 'gymcels', clip20,
				true, true, false, true, false, clip16, clip21, clip11, null, clipsMenu);
				selectablesList.set(clip_sprite20.topText, clip_sprite20);

				var clip_sprite21:VideoClipSprite = new VideoClipSprite(1700, 950, 'why_corps_push_feminism', clip21,
				true, true, true, true, false, clip20, clip22, clip19, null, clipsMenu);
				selectablesList.set(clip_sprite21.topText, clip_sprite21);

				var clip_sprite22:VideoClipSprite = new VideoClipSprite(2100, 950, 'poopoo', clip22,
				true, true, false, true, true, clip21, null, clip12, null, clipsMenu);
				selectablesList.set(clip_sprite22.topText, clip_sprite22);
			case 'D':
				clip1 = 'Are You Retarded';
				clip2 = 'Based Taliban';
				clip3 = 'Black Women';
				clip4 = 'Building A Movement';
				clip5 = 'College Experience';
				clip6 = 'Dont Wanna Be Alive';
				clip7 = 'Gay Jewish Cringe';
				clip8 = 'Is This Real';
				clip9 = 'JSKC';
				clip10 = 'Later Dudes';

				clip11 = 'Nothing Else Is Good';
				clip12 = 'Persecuted';
				clip13 = 'Pffft';
				clip14 = 'Retard Bitch';
				clip15 = 'Slavery Is A Choice';
				clip16 = 'STFU';
				clip17 = 'Stupid Bitch';
				clip18 = 'That Was So Good';
				clip19 = 'They Were Right';
				clip20 = 'Wake Up';
				clip21 = 'Democracy';
				clip22 = 'Youre Black';
				//left 1, top
				var clip_sprite1:VideoClipSprite = new VideoClipSprite(100, 450, 'are_you_retarded', clip1,
				true, true, false, true, true, clip3, clip18, null, clip8, clipsMenu);
				selectablesList.set(clip_sprite1.topText, clip_sprite1);
				//right 1, top
				var clip_sprite2:VideoClipSprite = new VideoClipSprite(900, 450, 'based_taliban', clip2,
				true, true, true, true, false, clip18, clip4, null, clip10, clipsMenu);
				selectablesList.set(clip_sprite2.topText, clip_sprite2);
				//left 2, top
				var clip_sprite3:VideoClipSprite = new VideoClipSprite(-300, 450, 'black_women', clip3,
				true, true, true, true, false, null, clip1, null, clip9, clipsMenu);
				selectablesList.set(clip_sprite3.topText, clip_sprite3);
				//right 2, top
				var clip_sprite4:VideoClipSprite = new VideoClipSprite(1300, 450, 'building_a_movement', clip4,
				true, true, true, false, false, clip2, clip5, null, clip11, clipsMenu);
				selectablesList.set(clip_sprite4.topText, clip_sprite4);
				//right 3, top
				var clip_sprite5:VideoClipSprite = new VideoClipSprite(1700, 450, 'college_experience', clip5,
				false, true, false, true, false, clip4, clip6, null, clip19, clipsMenu);
				selectablesList.set(clip_sprite5.topText, clip_sprite5);
				//right 4, top
				var clip_sprite6:VideoClipSprite = new VideoClipSprite(2100, 450, 'dont_wanna_be_alive', clip6,
				true, true, false, true, true, clip5, null, null, clip12, clipsMenu);
				selectablesList.set(clip_sprite6.topText, clip_sprite6);
				//center, down 1
				var clip_sprite7:VideoClipSprite = new VideoClipSprite(500, 700, 'gay_jewish_cringe', clip7,
				true, true, false, true, true, clip8, clip10, clip18, clip13, clipsMenu);
				selectablesList.set(clip_sprite7.topText, clip_sprite7);

				//left 1, down 1
				var clip_sprite8:VideoClipSprite = new VideoClipSprite(100, 700, 'is_this_real', clip8,
				false, true, false, false, true, clip9, clip7, clip1, clip14, clipsMenu);
				selectablesList.set(clip_sprite8.topText, clip_sprite8);
				//left 2, down 1
				var clip_sprite9:VideoClipSprite = new VideoClipSprite(-300, 700, 'jskc', clip9,
				true, true, false, true, false, null, clip8, clip3, clip15, clipsMenu);
				selectablesList.set(clip_sprite9.topText, clip_sprite9);
				//right 1, down 1
				var clip_sprite10:VideoClipSprite = new VideoClipSprite(900, 700, 'later_dudes', clip10,
				false, false, false, true, false, clip7, clip11, clip2, clip16, clipsMenu);
				selectablesList.set(clip_sprite10.topText, clip_sprite10);
				//right 2, down 1
				var clip_sprite11:VideoClipSprite = new VideoClipSprite(1300, 700, 'nothing_else_worth_watching', clip11,
				true, true, false, true, false, clip10, clip19, clip4, clip20, clipsMenu);
				selectablesList.set(clip_sprite11.topText, clip_sprite11);
				//right 4, down 1
				var clip_sprite12:VideoClipSprite = new VideoClipSprite(2100, 700, 'persecuted', clip12,
				false, false, true, false, false, clip19, null, clip6, clip22, clipsMenu);
				selectablesList.set(clip_sprite12.topText, clip_sprite12);
				//center, down 2
				var clip_sprite13:VideoClipSprite = new VideoClipSprite(500, 950, 'pffft', clip13,
				true, true, false, true, true, clip14, clip16, clip7, null, clipsMenu);
				selectablesList.set(clip_sprite13.topText, clip_sprite13);
				//left 1, down 2
				var clip_sprite14:VideoClipSprite = new VideoClipSprite(100, 950, 'retard_bitch', clip14,
				true, true, false, true, true, clip15, clip13, clip8, null, clipsMenu);
				selectablesList.set(clip_sprite14.topText, clip_sprite14);
				//left 2, down 2
				var clip_sprite15:VideoClipSprite = new VideoClipSprite(-300, 950, 'slavery_is_a_choice', clip15,
				true, true, true, true, false, null, clip14, clip9, null, clipsMenu);
				selectablesList.set(clip_sprite15.topText, clip_sprite15);
				//right 1, down 2
				var clip_sprite16:VideoClipSprite = new VideoClipSprite(900, 950, 'stfu', clip16,
				false, true, false, false, true, clip13, clip20, clip10, null, clipsMenu);
				selectablesList.set(clip_sprite16.topText, clip_sprite16);
				

				//center, up 1
				var clip_sprite17:VideoClipSprite = new VideoClipSprite(500, 200, 'stupid_bitch', clip17,
				true, true, false, true, false, null, null, null, clip18, clipsMenu);
				selectablesList.set(clip_sprite17.topText, clip_sprite17);
				//center, top
				var clip_sprite18:VideoClipSprite = new VideoClipSprite(500, 450, 'that_was_so_good', clip18,
				false, true, false, true, true, clip1, clip2, clip17, clip7, clipsMenu);
				selectablesList.set(clip_sprite18.topText, clip_sprite18);
				//right 3, down 1
				var clip_sprite19:VideoClipSprite = new VideoClipSprite(1700, 700, 'they_were_right', clip19,
				false, false, true, true, false, clip11, clip12, clip5, clip21, clipsMenu);
				selectablesList.set(clip_sprite19.topText, clip_sprite19);
				//right 2, down 2
				var clip_sprite20:VideoClipSprite = new VideoClipSprite(1300, 950, 'wake_up', clip20,
				true, true, true, true, false, clip16, clip21, clip11, null, clipsMenu);
				selectablesList.set(clip_sprite20.topText, clip_sprite20);

				var clip_sprite21:VideoClipSprite = new VideoClipSprite(1700, 950, 'what_has_democracy_done_for_us', clip21,
				true, true, true, false, false, clip20, clip22, clip19, null, clipsMenu);
				selectablesList.set(clip_sprite21.topText, clip_sprite21);

				var clip_sprite22:VideoClipSprite = new VideoClipSprite(2100, 950, 'youre_black', clip22,
				true, true, false, true, true, clip21, null, clip12, null, clipsMenu);
				selectablesList.set(clip_sprite22.topText, clip_sprite22);
		}



		addClips();
		setViewedStatus();

		cameraInitializer();

		super.create();
	}

	override function update(elapsed:Float)
	{
		checkForPossibleMoves();


		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var stopspamming:Bool = false;


	/**
		Private function to handle the user using arrow keys and enter and escape to move in the menu.
	**/
	function checkForPossibleMoves() {
		if (!movedBack)
		{
			if (!currentlySelecting)
			{
				var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
				var selectedItem:VideoClipSprite = selectablesList.get(currentSelected);
				if (gamepad != null)
					{
						if (gamepad.justPressed.DPAD_UP)
						{
							move(selectedItem.upConnection);
						}
						if (gamepad.justPressed.DPAD_DOWN)
						{
							move(selectedItem.downConnection);
						}
	
						if (gamepad.justPressed.DPAD_RIGHT) {
							move(selectedItem.rightConnection);
						}
						if (gamepad.justPressed.DPAD_LEFT) {
							move(selectedItem.leftConnection);
						}
					}
	
					if (FlxG.keys.justPressed.UP)
					{
						move(selectedItem.upConnection);
					}
	
					if (FlxG.keys.justPressed.DOWN)
					{
						move(selectedItem.downConnection);
					}

					if (FlxG.keys.justPressed.RIGHT)
					{
						move(selectedItem.rightConnection);
					}

					if (FlxG.keys.justPressed.LEFT)
					{
						move(selectedItem.leftConnection);
					}
			}

			if (controls.ACCEPT)
			{
				if(!currentlySelecting) {
					var selectedItem:VideoClipSprite = selectablesList.get(currentSelected);

					add(hugeBlackBox);

					selectedItem.select();

					if(!selectedItem.isVideo || (selectedItem.isTwitchCensored && FlxG.save.data.twitchSafety)) {

						imageToDisplay = selectedItem.imagePNG;
						add(imageToDisplay);

						blackRectangle1 = selectedItem.blackRectangle1;
						add(blackRectangle1);

						blackRectangle2 = selectedItem.blackRectangle2;
						add(blackRectangle2);

						imageToDisplay.scrollFactor.set(0, 0);
						blackRectangle1.scrollFactor.set(0, 0);
						blackRectangle2.scrollFactor.set(0, 0);
						selectedItem.setViewed();
					} else {
						viewingVid = true;
					}
					saveViewedClip(selectedItem.topText);
					currentlySelecting = true;
				}
			}
		}

		if(justChanged) {
			var curSelected:VideoClipSprite = selectablesList.get(currentSelected);
			var frontClip:FlxBasic = this.members[(this.length-1)];
			remove(frontClip, true);
			replace(curSelected, frontClip);
			add(curSelected);

			selectablesList.get(currentSelected).expand();
			justChanged = false;
		}



		if (controls.BACK && !movedBack && !viewingVid)
		{
			if(!currentlySelecting) {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				movedBack = true;
				var storyState:StoryMenuState = new StoryMenuState();
				storyState.currentSelected = 'clips ' + clipsMenu.toLowerCase();
				FlxG.switchState(storyState);
			} else {
				selectablesList.get(currentSelected).unselect();
				currentlySelecting = false;
				remove(hugeBlackBox);
			}
		}
	}

	/**
		Simple private function to handle camera movement and selectable's expansion and retraction.
	**/
	private function move(connection:String) {
		var tempSelection:VideoClipSprite = selectablesList.get(currentSelected);
		var camMidPoint:FlxPoint;
		if(connection != null && !selectablesList.get(connection).isLocked) {
			FlxG.sound.play(Paths.sound('scrollMenu'));

			tempSelection.retract();

			currentSelected = connection;
			tempSelection = selectablesList.get(currentSelected);

			camMidPoint = tempSelection.getBackground().getMidpoint();
			camFollow.setPosition(camMidPoint.x, camMidPoint.y);

			justChanged = true;
		}
	}

	private function cameraInitializer() {
		this.cameras = [clipGalleryCamera];
		clipGalleryCamera.focusOn(selectablesList.get(currentSelected).getBackground().getMidpoint());
		selectablesList.get(currentSelected).expand();
		
		for(selectable in selectablesList) {
			selectable.cameras = [clipGalleryCamera];
		}
		for(asset in menuAssetsArray) {
			asset.cameras = [clipGalleryCamera];
		}

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(selectablesList.get(currentSelected).getBackground().getMidpoint().x, selectablesList.get(currentSelected).getBackground().getMidpoint().y);

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast(Lib.current.getChildAt(0), Main)).getFPS()));
		FlxG.camera.focusOn(camFollow.getPosition());

		background.scrollFactor.set(0, 0);
		header.setGraphicSize(1280, 100);
		header.updateHitbox();
		header.scrollFactor.set(0, 0);
		
	}

	private function addClips() {
		for(clip in selectablesList) {
			add(clip);
		}
	}

	private function parseViewedClips():Array<String> {
		try {
			var unparsedContent:String = File.getContent(Paths.json('clipsViewed'));

			var parsedContent:DynamicAccess<Clips> = Json.parse(unparsedContent);
			trace('parsedContent: ' + parsedContent);

			var viewedClipsArray:Array<String> = parsedContent.get(clipsMenu).clips;
			trace('viewedClipsArray: ' + viewedClipsArray);

			return viewedClipsArray;
		} catch(e:Exception) {
			trace(e.message);
			resetViewedClips();
			return parseViewedClips();
		}
	}

	private function setViewedStatus() {
		var viewedClips:Array<String> = parseViewedClips();
		for(clip in selectablesList) {
			if(viewedClips.contains(clip.topText)) {
				clip.setViewed();
			}
		}
	}

	public static function resetViewedClips() {
		var resetString:String = '{"A":{"clips":[]},"B":{"clips":[]},"C":{"clips":[]},"D":{"clips":[]}}';
		File.saveContent(Paths.json('clipsViewed'), resetString);
	}

	public function saveViewedClip(clipName:String) {
		var unparsedContent:String = File.getContent(Paths.json('clipsViewed'));
		try {
			var parsedContent:DynamicAccess<Clips> = Json.parse(unparsedContent);
			trace('parsedContent: ' + parsedContent);

			var viewedClipsArray:Array<String> = parsedContent.get(clipsMenu).clips;
			trace('viewedClipsArray: ' + viewedClipsArray);
			if(!viewedClipsArray.contains(clipName)) {
				viewedClipsArray.push(clipName);

				parsedContent.get(clipsMenu).clips = viewedClipsArray;
				trace('parsedContent2: ' + parsedContent);

				File.saveContent(Paths.json('clipsViewed'), Json.stringify(parsedContent, null, '\t'));
			}
		}catch(e:Exception) {
			trace(e.message);
			resetViewedClips();
		}
	}
}

typedef Clips = {
	var clips:Array<String>;
}
