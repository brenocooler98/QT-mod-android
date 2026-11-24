package mobile;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

class Hitbox extends FlxTypedGroup<TouchButton>
{
	static inline var DODGE_HEIGHT:Int = 150;

	public var buttonLeft:TouchButton;
	public var buttonDown:TouchButton;
	public var buttonUp:TouchButton;
	public var buttonRight:TouchButton;
	public var buttonDodge:TouchButton;

	var owner:FlxState;

	var lanesInvisible:Bool;

	public function new(owner:FlxState, withDodge:Bool, dodgeOnTop:Bool, laneTop:Float = 0, invisible:Bool = false)
	{
		super();
		this.owner = owner;
		lanesInvisible = invisible || FlxG.save.data.invisibleHitbox;

		var laneWidth:Int = Std.int(FlxG.width / 4);
		var laneY:Float = Math.max(laneTop, withDodge && dodgeOnTop ? DODGE_HEIGHT : 0);
		var laneBottom:Float = withDodge && !dodgeOnTop ? FlxG.height - DODGE_HEIGHT : FlxG.height;
		var laneHeight:Int = Std.int(Math.max(1, laneBottom - laneY));

		buttonLeft = make(0, laneY, laneWidth, laneHeight, 0xFFC24B99, LEFT);
		buttonDown = make(laneWidth, laneY, laneWidth, laneHeight, 0xFF00FFFF, DOWN);
		buttonUp = make(laneWidth * 2, laneY, laneWidth, laneHeight, 0xFF12FA05, UP);
		buttonRight = make(laneWidth * 3, laneY, FlxG.width - laneWidth * 3, laneHeight, 0xFFF9393F, RIGHT);

		if (withDodge)
		{
			buttonDodge = new TouchButton(0, dodgeOnTop ? 0 : FlxG.height - DODGE_HEIGHT, FlxG.width, DODGE_HEIGHT, 0xFFFFFF00, null, NONE, false);
			buttonDodge.owner = owner;
			buttonDodge.idleAlpha = 0;
			buttonDodge.pressedAlpha = FlxG.save.data.invisibleHitbox ? 0 : 0.5;
			add(buttonDodge);
		}
	}

	function make(x:Float, y:Float, width:Int, height:Int, color:FlxColor, control:Control):TouchButton
	{
		var button:TouchButton = new TouchButton(x, y, width, height, color, control, NONE, false);
		button.owner = owner;
		button.idleAlpha = 0;
		button.pressedAlpha = lanesInvisible ? 0 : 0.3;
		add(button);
		return button;
	}

	public function dodgeJustPressed():Bool
	{
		return buttonDodge != null && buttonDodge.justPressed();
	}

	override function destroy():Void
	{
		owner = null;
		super.destroy();
	}
}
