package mobile;

import flixel.FlxG;

class ArrowsMode
{
	public static var active(default, null):Bool = false;

	static var savedDownscroll:Null<Bool> = null;

	public static function begin():Void
	{
		active = FlxG.save.data.hitboxMode == 'Arrows';
		if (!active || savedDownscroll != null)
			return;

		savedDownscroll = FlxG.save.data.downscroll == true;
		FlxG.save.data.downscroll = true;
	}

	public static function end():Void
	{
		if (savedDownscroll != null)
		{
			FlxG.save.data.downscroll = savedDownscroll;
			savedDownscroll = null;
			FlxG.save.flush();
		}
		active = false;
	}

	public static function getLaneX(index:Int, width:Float):Float
	{
		var laneWidth:Float = FlxG.width / 4;
		return laneWidth * index + (laneWidth - width) / 2;
	}
}
