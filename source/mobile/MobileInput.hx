package mobile;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.touch.FlxTouch;
import mobile.TouchUtil.SwipeDirection;

class MobileInput
{
	static var buttons:Array<TouchButton> = [];
	static var blockers:Array<FlxSprite> = [];
	static var swipeStates:Array<FlxState> = [];
	static var injected:Map<Control, Int> = new Map<Control, Int>();
	static var frame:Int = 0;
	static var initialized:Bool = false;

	public static function init():Void
	{
		if (initialized)
			return;
		initialized = true;
		FlxG.signals.preUpdate.add(function() frame++);
	}

	public static function register(button:TouchButton):Void
	{
		if (!buttons.contains(button))
			buttons.push(button);
	}

	public static function unregister(button:TouchButton):Void
	{
		buttons.remove(button);
	}

	public static function addBlocker(sprite:FlxSprite):Void
	{
		if (!blockers.contains(sprite))
			blockers.push(sprite);
	}

	public static function removeBlocker(sprite:FlxSprite):Void
	{
		blockers.remove(sprite);
	}

	public static function addSwipeState(state:FlxState):Void
	{
		if (!swipeStates.contains(state))
			swipeStates.push(state);
	}

	public static function removeSwipeState(state:FlxState):Void
	{
		swipeStates.remove(state);
	}

	public static function inject(control:Control):Void
	{
		injected.set(control, frame + 1);
	}

	public static function isBlocked(touch:FlxTouch):Bool
	{
		for (blocker in blockers)
			if (blocker.exists && blocker.visible && touch.overlaps(blocker, blocker.getCameras()[0]))
				return true;
		return false;
	}

	public static function topState():FlxState
	{
		var state:FlxState = FlxG.state;
		while (state != null && state.subState != null)
			state = state.subState;
		return state;
	}

	public static function check(control:Control, state:FlxInputState):Bool
	{
		var top:FlxState = topState();

		if (state == JUST_PRESSED)
		{
			if ((control == BACK || control == PAUSE) && FlxG.android.justReleased.BACK)
				return true;

			if (injected.get(control) == frame)
				return true;

			if (swipeStates.contains(top))
			{
				var swiped:Bool = switch (control)
				{
					case UP: TouchUtil.swipe(SwipeDirection.DOWN);
					case DOWN: TouchUtil.swipe(SwipeDirection.UP);
					case LEFT: TouchUtil.swipe(SwipeDirection.RIGHT);
					case RIGHT: TouchUtil.swipe(SwipeDirection.LEFT);
					default: false;
				}
				if (swiped)
					return true;
			}
		}

		for (button in buttons)
			if (button.owner == top && button.control == control && button.check(state))
				return true;
		return false;
	}

	public static function anyTouchJustPressed():Bool
	{
		for (touch in FlxG.touches.list)
			if (touch.justPressed && !isBlocked(touch))
				return true;
		return false;
	}
}
