package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import openfl.events.Event;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import vlc.VlcBitmap;
import Controls.Control;
import flixel.util.FlxTimer;
import flixel.FlxSprite;

// THIS IS FOR TESTING
// DONT STEAL MY CODE >:(

class MP4Handler
{
	public var video:Video;
	public var netStream:NetStream;
	public var finishCallback:FlxState;
	public var sprite:FlxSprite;
	#if desktop
	public var vlcBitmap:VlcBitmap;
	#end
	var path:String;
	public var stopInevitable:Bool;

	public function new()
	{
		stopInevitable = false;
		path = '';
		FlxG.autoPause = false;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
		}
	}

	public function playMP4(path:String, callback:FlxState, ?outputTo:FlxSprite = null, ?repeat:Bool = false, ?isWindow:Bool = false, ?isFullscreen:Bool = false):Void
	{
		this.path = path;
		#if html5
		FlxG.autoPause = false;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
		}

		finishCallback = callback;

		video = new Video();
		video.x = 0;
		video.y = 0;

		FlxG.addChildBelowMouse(video);

		var nc = new NetConnection();
		nc.connect(null);

		netStream = new NetStream(nc);
		netStream.client = {onMetaData: client_onMetaData};

		nc.addEventListener("netStatus", netConnection_onNetStatus);

		netStream.play(path);
		#else
		finishCallback = callback;

		vlcBitmap = new VlcBitmap();
		vlcBitmap.set_height(FlxG.stage.stageHeight);
		//vlcBitmap.set_width(FlxG.stage.stageWidth);
		vlcBitmap.set_width(FlxG.stage.stageHeight * (16 / 9));

		trace("Setting width to " + FlxG.stage.stageHeight * (16 / 9));
		trace("Real width: " + FlxG.stage.stageWidth);
		trace("Setting height to " + FlxG.stage.stageHeight);

		vlcBitmap.onVideoReady = onVLCVideoReady;
		vlcBitmap.onComplete = onVLCComplete;
		vlcBitmap.onError = onVLCError;

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

		if (repeat)
			vlcBitmap.repeat = -1;
		else
			vlcBitmap.repeat = 0;

		vlcBitmap.inWindow = isWindow;
		vlcBitmap.fullscreen = isFullscreen;

		FlxG.addChildBelowMouse(vlcBitmap);
		//FlxG.camera.fade(FlxColor.GRAY, 1, false, function() {
			vlcBitmap.play(checkFile(path));
		//});
		
		if (outputTo != null)
		{
			// lol this is bad kek
			vlcBitmap.alpha = 0;
	
			sprite = outputTo;
		}
		#end
	}

	#if desktop
	public static function checkFile(fileName:String):String
	{
		var pDir = "";
		var appDir = "file:///" + Sys.getCwd() + "/";

		if (fileName.indexOf(":") == -1) // Not a path
			pDir = appDir;
		else if (fileName.indexOf("file://") == -1 || fileName.indexOf("http") == -1) // C:, D: etc? ..missing "file:///" ?
			pDir = "file:///";

		return pDir + fileName;
	}

	/////////////////////////////////////////////////////////////////////////////////////

	function onVLCVideoReady()
	{
		trace("video loaded!");
		if (sprite != null) {
			sprite.loadGraphic(vlcBitmap.bitmapData);
		}
	}

	public function onVLCComplete()
	{
		vlcBitmap.stop();

		// Clean player, just in case! Actually no.

		//FlxG.camera.fade(FlxColor.BLACK, 1, false, function() {
			if (finishCallback != null)
			{
					LoadingState.loadAndSwitchState(finishCallback);
			}
			vlcBitmap.dispose();

			if (FlxG.game.contains(vlcBitmap))
			{
				FlxG.game.removeChild(vlcBitmap);
			}	
		//});
		

	}

	function onInevitableComplete() {
		if(stopInevitable) {
			vlcBitmap.stop();

			// Clean player, just in case! Actually no.

			//FlxG.camera.fade(FlxColor.BLACK, 1, false, function() {
				if (finishCallback != null)
				{
					LoadingState.loadAndSwitchState(finishCallback);
				}
				vlcBitmap.dispose();

				if (FlxG.game.contains(vlcBitmap))
				{
					FlxG.game.removeChild(vlcBitmap);
				}	
			//});
		} else {
			vlcBitmap.stop();
			//FlxG.camera.fade(FlxColor.BLACK, 1, false, function() {
				trace('restarting');
				var video:MP4Handler = new MP4Handler();
				video.playMP4('assets/videos/Inevitable/Inevitable.mp4', new TitleState(), null, false, false);
			//});
		}
	}

	function onVLCError()
	{
		if (finishCallback != null)
		{
			LoadingState.loadAndSwitchState(finishCallback);
		}
	}

	function update(e:Event)
	{
		//trace('yo');
		if(FlxG.keys.justPressed.X) {
			trace('pressed x');
			VideoState.devKeyPressed = true;
		}


		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
		{
			if (vlcBitmap.isPlaying)
			{
				if(path == 'assets/videos/Inevitable/Inevitable.mp4') {
					VideoState.numberOfEnters++;
					trace('stopping inevitable');
					stopInevitable = true;
				}
				// AF Enjoyer: Gotta add the checks here if i want to convert the intros to .mp4
				if(VideoState.devKeyPressed || path != 'assets/videos/Credo/Credo.mp4') {
					onVLCComplete();
				}
			}
		}
		vlcBitmap.volume = FlxG.sound.volume + 0.3; // shitty volume fix. then make it louder.
		if (FlxG.sound.volume <= 0.1) vlcBitmap.volume = 0;

	}
	#end

	/////////////////////////////////////////////////////////////////////////////////////

	function client_onMetaData(path)
	{
		video.attachNetStream(netStream);

		video.width = FlxG.width;
		video.height = FlxG.height;
	}

	function netConnection_onNetStatus(path)
	{
		if (path.info.code == "NetStream.Play.Complete")
		{
			finishVideo();
		}
	}

	function finishVideo()
	{
		netStream.dispose();

		if (FlxG.game.contains(video))
		{
			FlxG.game.removeChild(video);
		}

		if (finishCallback != null)
		{
			LoadingState.loadAndSwitchState(finishCallback);
		}
		else
			LoadingState.loadAndSwitchState(new MainMenuState());
	}

	// old html5 player
	/*
		var nc:NetConnection = new NetConnection();
		nc.connect(null);
		var ns:NetStream = new NetStream(nc);
		var myVideo:Video = new Video();
		myVideo.width = FlxG.width;
		myVideo.height = FlxG.height;
		myVideo.attachNetStream(ns);
		ns.play(path);
		return myVideo;
		ns.close();
	 */
}
