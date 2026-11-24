package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.util.FlxColor;
import haxe.CallStack;
import lime.app.Application;
import mobile.MobileInput;
import mobile.StorageUtil;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;

class Main extends Sprite
{
	var gameWidth:Int = 1280;
	var gameHeight:Int = 720;
	var initialState:Class<FlxState> = TitleState;
	var framerate:Int = 60;
	var skipSplash:Bool = true;
	var startFullscreen:Bool = true;

	public static var watermarks = true;
	public static var qtOptimisation = false;

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);

		setupGame();
	}

	private function setupGame():Void
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);

		game = new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen);
		addChild(game);

		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		toggleFPS(FlxG.save.data.fps);

		FlxG.mouse.visible = false;
		FlxG.android.preventDefaultKeys = [BACK];
		MobileInput.init();
	}

	function onCrash(event:UncaughtErrorEvent):Void
	{
		var message:String = Std.string(event.error) + '\n\n' + CallStack.toString(CallStack.exceptionStack(true));

		try
		{
			var path:String = StorageUtil.getStoragePath() + 'crash/';
			if (!FileSystem.exists(path))
				FileSystem.createDirectory(path);
			File.saveContent(path + 'crash-' + Date.now().getTime() + '.txt', message);
		}
		catch (e:Dynamic) {}

		Application.current.window.alert(message, 'Friday Night Funkin\' QT Mod crashed');
		Sys.exit(1);
	}

	var game:FlxGame;

	var fpsCounter:FPS;

	public function toggleFPS(fpsEnabled:Bool):Void
	{
		fpsCounter.visible = fpsEnabled;
	}

	public function changeFPSColor(color:FlxColor)
	{
		fpsCounter.textColor = color;
	}

	public function setFPSCap(cap:Float)
	{
		openfl.Lib.current.stage.frameRate = cap;
	}

	public function getFPSCap():Float
	{
		return openfl.Lib.current.stage.frameRate;
	}

	public function getFPS():Float
	{
		return fpsCounter.currentFPS;
	}
}
