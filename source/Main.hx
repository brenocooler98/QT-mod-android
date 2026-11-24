package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.util.FlxColor;
import haxe.CallStack;
import androidmanager.callback.Callback;
import androidmanager.view.Window;
import lime.app.Application;
import mobile.MobileInput;
import mobile.ScreenStyle;
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

		ScreenStyle.load();
		gameWidth = ScreenStyle.getGameWidth(stage.stageWidth, stage.stageHeight);

		fpsCounter = new FPS(0, 0, 0xFFFFFF);

		game = new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen);
		addChild(game);

		addChild(fpsCounter);
		toggleFPS(FlxG.save.data.fps);

		stage.addEventListener(Event.RESIZE, onResize);
		onResize();

		Window.keepScreenOn = true;
		Window.immersive = true;
		Callback.init();
		Callback.onPause.add(onAppPause);

		FlxG.mouse.visible = false;
		FlxG.android.preventDefaultKeys = [BACK];
		MobileInput.init();
	}

	function onResize(?event:Event):Void
	{
		if (fpsCounter == null)
			return;

		var scale:Float = Math.min(stage.stageWidth / gameWidth, stage.stageHeight / gameHeight);
		var offsetX:Float = (stage.stageWidth - gameWidth * scale) / 2;
		var offsetY:Float = (stage.stageHeight - gameHeight * scale) / 2;

		fpsCounter.scaleX = fpsCounter.scaleY = scale * 1.5;
		fpsCounter.x = offsetX + 10 * scale;
		fpsCounter.y = offsetY + 6 * scale;
	}

	function onAppPause():Void
	{
		if (Std.isOfType(FlxG.state, PlayState) && FlxG.state.subState == null)
			MobileInput.inject(PAUSE);
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
		if (fpsCounter != null)
			fpsCounter.visible = fpsEnabled;
	}

	public function changeFPSColor(color:FlxColor)
	{
		if (fpsCounter != null)
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
		return fpsCounter != null && fpsCounter.currentFPS > 0 ? fpsCounter.currentFPS : framerate;
	}
}
