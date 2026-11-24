package mobile;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxState;
import flixel.input.FlxInput.FlxInputState;

class MobileInput
{
	static var buttons:Array<TouchButton> = [];

	public static function register(button:TouchButton):Void
	{
		if (!buttons.contains(button))
			buttons.push(button);
	}

	public static function unregister(button:TouchButton):Void
	{
		buttons.remove(button);
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
		if (state == JUST_PRESSED && (control == BACK || control == PAUSE) && FlxG.android.justReleased.BACK)
			return true;

		var top:FlxState = topState();
		for (button in buttons)
			if (button.owner == top && button.control == control && button.check(state))
				return true;
		return false;
	}

	public static function anyTouchJustPressed():Bool
	{
		for (touch in FlxG.touches.list)
			if (touch.justPressed)
				return true;
		return false;
	}
}
