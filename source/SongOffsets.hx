package;

import flixel.FlxG;

class SongOffsets
{
	public static function get(song:String):Float
	{
		var offsets:Map<String, Float> = FlxG.save.data.songOffsets;
		if (offsets == null || !offsets.exists(song.toLowerCase()))
			return 0;
		return offsets.get(song.toLowerCase());
	}

	public static function set(song:String, value:Float):Void
	{
		var offsets:Map<String, Float> = FlxG.save.data.songOffsets;
		if (offsets == null)
			offsets = new Map<String, Float>();
		offsets.set(song.toLowerCase(), value);
		FlxG.save.data.songOffsets = offsets;
		FlxG.save.flush();
	}
}
