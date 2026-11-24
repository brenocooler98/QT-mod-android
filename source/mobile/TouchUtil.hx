package mobile;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxPoint;

enum SwipeDirection
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

class TouchUtil
{
	public static var tapDistance:Float = 30;

	public static var verticalStep:Float = 70;
	public static var horizontalStep:Float = 110;

	static var anchors:Map<Int, FlxPoint> = new Map<Int, FlxPoint>();
	static var steps:Array<SwipeDirection> = [];
	static var dragged:Array<Int> = [];

	public static function updateDrags():Void
	{
		steps.resize(0);

		var active:Array<Int> = [];
		for (touch in FlxG.touches.list)
		{
			var id:Int = touch.touchPointID;
			if (!touch.pressed && !touch.justReleased)
				continue;
			active.push(id);

			var anchor:FlxPoint = anchors.get(id);
			if (anchor == null || touch.justPressed)
			{
				if (anchor != null)
					anchor.put();
				anchors.set(id, FlxPoint.get(touch.viewX, touch.viewY));
				dragged.remove(id);
				continue;
			}

			var dx:Float = touch.viewX - anchor.x;
			var dy:Float = touch.viewY - anchor.y;

			if (Math.abs(dy) >= Math.abs(dx))
			{
				while (Math.abs(dy) >= verticalStep)
				{
					var sign:Int = dy < 0 ? -1 : 1;
					steps.push(sign < 0 ? UP : DOWN);
					if (!dragged.contains(id))
						dragged.push(id);
					anchor.y += sign * verticalStep;
					dy -= sign * verticalStep;
				}
			}
			else
			{
				while (Math.abs(dx) >= horizontalStep)
				{
					var sign:Int = dx < 0 ? -1 : 1;
					steps.push(sign < 0 ? LEFT : RIGHT);
					if (!dragged.contains(id))
						dragged.push(id);
					anchor.x += sign * horizontalStep;
					dx -= sign * horizontalStep;
				}
			}
		}

		for (id in [for (key in anchors.keys()) key])
		{
			if (!active.contains(id))
			{
				anchors.get(id).put();
				anchors.remove(id);
				dragged.remove(id);
			}
		}
	}

	public static function swipe(direction:SwipeDirection):Bool
	{
		return steps.contains(direction);
	}

	static function isTap(touch:FlxTouch):Bool
	{
		if (!touch.justReleased || dragged.contains(touch.touchPointID) || MobileInput.isBlocked(touch))
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
			if (touch.overlaps(object, getCamera(object, camera)))
				return true;
		}
		return false;
	}

	public static function justTouched(object:FlxBasic, ?camera:FlxCamera):Bool
	{
		for (touch in FlxG.touches.list)
			if (touch.justPressed && touch.overlaps(object, getCamera(object, camera)))
				return true;
		return false;
	}

	public static function tappedIndex(objects:Array<FlxBasic>, ?camera:FlxCamera):Int
	{
		for (i in 0...objects.length)
		{
			var object:FlxBasic = objects[i];
			if (object != null && object.exists && object.visible && tapped(object, camera))
				return i;
		}
		return -1;
	}

	static function getCamera(object:FlxBasic, ?fallback:FlxCamera):FlxCamera
	{
		@:privateAccess var own:Array<FlxCamera> = object._cameras;
		if (own != null && own.length > 0)
			return own[0];
		if (fallback != null)
			return fallback;
		var cameras:Array<FlxCamera> = object.getCameras();
		return cameras != null && cameras.length > 0 ? cameras[0] : FlxG.camera;
	}

	public static function getStateCamera(state:flixel.FlxState):FlxCamera
	{
		var cameras:Array<FlxCamera> = state.getCameras();
		return cameras != null && cameras.length > 0 ? cameras[0] : FlxG.camera;
	}
}
