package mobile;

import haxe.io.Path;
import lime.system.System;
import sys.FileSystem;

class StorageUtil
{
	public static function getStoragePath():String
	{
		return Path.addTrailingSlash(System.applicationStorageDirectory);
	}

	public static function getReplaysPath():String
	{
		var path:String = getStoragePath() + 'replays/';
		if (!FileSystem.exists(path))
			FileSystem.createDirectory(path);
		return path;
	}
}
