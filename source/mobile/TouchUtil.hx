package mobile;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.touch.FlxTouch;

enum SwipeDirection
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

class TouchUtil
{
	public static var swipeDistance:Float = 60;
	public static var tapDistance:Float = 30;

	public static function swipe(direction:SwipeDirection):Bool
	{
		for (swipe in FlxG.swipes)
		{
			if (swipe.distance < swipeDistance)
				continue;

			var dx:Float = swipe.endPosition.x - swipe.startPosition.x;
			var dy:Float = swipe.endPosition.y - swipe.startPosition.y;
			var result:SwipeDirection = Math.abs(dy) >= Math.abs(dx) ? (dy < 0 ? UP : DOWN) : (dx < 0 ? LEFT : RIGHT);
			if (result == direction)
				return true;
		}
		return false;
	}

	static function isTap(touch:FlxTouch):Bool
	{
		if (!touch.justReleased || MobileInput.isBlocked(touch))
			return false;
		var dx:Float = touch.viewX - touch.justPressedPosition.x;
		var dy:Float = touch.viewY - touch.justPressedPosition.y;
		return Math.sqrt(dx * dx + dy * dy) <= tapDistance;
	}

	public static function tapped(?object:FlxBasic, ?camera:FlxCamera):Bool
	{
		for (touch in FlxG.touches.list)
		{
			if (!isTap(touch))
				continue;
			if (object == null)
				return true;
			if (touch.overlaps(object, camera != null ? camera : getCamera(object)))
				return true;
		}
		return false;
	}

	public static function justTouched(object:FlxBasic, ?camera:FlxCamera):Bool
	{
		for (touch in FlxG.touches.list)
			if (touch.justPressed && touch.overlaps(object, camera != null ? camera : getCamera(object)))
				return true;
		return false;
	}

	public static function tappedIndex(objects:Array<FlxBasic>):Int
	{
		for (i in 0...objects.length)
		{
			var object:FlxBasic = objects[i];
			if (object != null && object.exists && object.visible && tapped(object))
				return i;
		}
		return -1;
	}

	static function getCamera(object:FlxBasic):FlxCamera
	{
		var cameras:Array<FlxCamera> = object.getCameras();
		return cameras != null && cameras.length > 0 ? cameras[0] : FlxG.camera;
	}
}
