package mobile;

import androidmanager.content.Context;
import haxe.io.Path;
import lime.system.System;
import sys.FileSystem;

class StorageUtil
{
	public static function getStoragePath():String
	{
		var path:Null<String> = Context.getExternalFilesDir();
		if (path == null || path.length == 0)
			path = Context.getFilesDir();
		if (path == null || path.length == 0)
			path = System.applicationStorageDirectory;
		return Path.addTrailingSlash(path);
	}

	public static function getReplaysPath():String
	{
		var path:String = getStoragePath() + 'replays/';
		if (!FileSystem.exists(path))
			FileSystem.createDirectory(path);
		return path;
	}
}
