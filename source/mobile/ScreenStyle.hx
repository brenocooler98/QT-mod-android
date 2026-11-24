package mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import lime.system.JNI;

class ScreenStyle
{
	public static inline var BASE_WIDTH:Int = 1280;
	public static inline var BASE_HEIGHT:Int = 720;

	public static var full(default, null):Bool = false;

	static var applyJNI:Dynamic = null;
	static var widthJNI:Dynamic = null;
	static var heightJNI:Dynamic = null;

	public static function load():Void
	{
		try
		{
			var save:FlxSave = new FlxSave();
			save.bind('funkin', 'ninjamuffin99');
			full = save.data.screenStyle == 'full';
			save.destroy();
		}
		catch (e:Dynamic)
		{
			full = false;
		}

		if (applyJNI == null)
		{
			applyJNI = JNI.createStaticMethod('qtmod/ScreenStyle', 'apply', '(Z)V');
			widthJNI = JNI.createStaticMethod('qtmod/ScreenStyle', 'getScreenWidth', '()I');
			heightJNI = JNI.createStaticMethod('qtmod/ScreenStyle', 'getScreenHeight', '()I');
		}

		if (applyJNI != null)
			applyJNI(full);
	}

	public static function getGameWidth(stageWidth:Int, stageHeight:Int):Int
	{
		if (!full)
			return BASE_WIDTH;

		var screenWidth:Int = widthJNI != null ? widthJNI() : stageWidth;
		var screenHeight:Int = heightJNI != null ? heightJNI() : stageHeight;
		if (screenWidth <= 0 || screenHeight <= 0)
		{
			screenWidth = stageWidth;
			screenHeight = stageHeight;
		}

		return Std.int(Math.max(BASE_WIDTH, Math.ceil(BASE_HEIGHT * screenWidth / screenHeight)));
	}

	public static inline function getOffset():Float
	{
		return (FlxG.width - BASE_WIDTH) / 2;
	}

	public static function cover(sprite:FlxSprite):Void
	{
		if (sprite.width < FlxG.width)
		{
			var scale:Float = FlxG.width / sprite.frameWidth;
			sprite.scale.set(scale, scale);
			sprite.updateHitbox();
		}
		sprite.screenCenter(X);
	}
}
