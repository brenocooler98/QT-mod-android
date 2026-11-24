package mobile;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import mobile.TouchButton.TouchButtonIcon;

enum DPadMode
{
	NONE;
	UP_DOWN;
	LEFT_RIGHT;
	FULL;
}

enum ActionMode
{
	NONE;
	A;
	B;
	A_B;
	A_B_C;
}

class VirtualPad extends FlxTypedGroup<TouchButton>
{
	static inline var SIZE:Int = 132;
	static inline var MARGIN:Int = 24;

	public var buttonUp:TouchButton;
	public var buttonDown:TouchButton;
	public var buttonLeft:TouchButton;
	public var buttonRight:TouchButton;
	public var buttonA:TouchButton;
	public var buttonB:TouchButton;
	public var buttonC:TouchButton;

	var owner:FlxState;

	public function new(owner:FlxState, dpad:DPadMode, action:ActionMode)
	{
		super();
		this.owner = owner;

		var bottom:Float = FlxG.height - MARGIN - SIZE;

		switch (dpad)
		{
			case UP_DOWN:
				buttonUp = make(MARGIN, bottom - SIZE, 0xFF12FA05, UP, ARROW(0));
				buttonDown = make(MARGIN, bottom, 0xFF00FFFF, DOWN, ARROW(180));
			case LEFT_RIGHT:
				buttonLeft = make(MARGIN, bottom, 0xFFC24B99, LEFT, ARROW(270));
				buttonRight = make(MARGIN + SIZE, bottom, 0xFFF9393F, RIGHT, ARROW(90));
			case FULL:
				buttonUp = make(MARGIN + SIZE, bottom - SIZE, 0xFF12FA05, UP, ARROW(0));
				buttonLeft = make(MARGIN, bottom - SIZE / 2, 0xFFC24B99, LEFT, ARROW(270));
				buttonRight = make(MARGIN + SIZE * 2, bottom - SIZE / 2, 0xFFF9393F, RIGHT, ARROW(90));
				buttonDown = make(MARGIN + SIZE, bottom, 0xFF00FFFF, DOWN, ARROW(180));
			case NONE:
		}

		var right:Float = FlxG.width - MARGIN - SIZE;

		switch (action)
		{
			case A:
				buttonA = make(right, bottom, 0xFFFF0000, ACCEPT, LABEL('A'));
			case B:
				buttonB = make(right, bottom, 0xFFFFCB00, BACK, LABEL('B'));
			case A_B:
				buttonA = make(right, bottom, 0xFFFF0000, ACCEPT, LABEL('A'));
				buttonB = make(right - SIZE, bottom, 0xFFFFCB00, BACK, LABEL('B'));
			case A_B_C:
				buttonA = make(right, bottom, 0xFFFF0000, ACCEPT, LABEL('A'));
				buttonB = make(right - SIZE, bottom, 0xFFFFCB00, BACK, LABEL('B'));
				buttonC = make(right - SIZE * 2, bottom, 0xFF44FF44, RESET, LABEL('C'));
			case NONE:
		}
	}

	function make(x:Float, y:Float, color:FlxColor, control:Control, icon:TouchButtonIcon):TouchButton
	{
		var button:TouchButton = new TouchButton(x, y, SIZE, SIZE, color, control, icon);
		button.owner = owner;
		add(button);
		return button;
	}

	override function destroy():Void
	{
		owner = null;
		super.destroy();
	}
}
