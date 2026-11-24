package mobile;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Hitbox extends FlxTypedGroup<TouchButton>
{
	static inline var DODGE_HEIGHT:Int = 150;
	static inline var STICKY_PADDING:Float = 45;

	var lanes:Array<TouchButton> = [];
	var assignments:Map<Int, Int> = new Map<Int, Int>();
	var assignedFrame:Int = -1;
	var point:FlxPoint = FlxPoint.get();

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

		var edges:Array<Float> = ArrowsMode.active ? [for (i in 0...5) ArrowsMode.getLaneEdge(i)] : [0, laneWidth, laneWidth * 2, laneWidth * 3, FlxG.width];
		var colors:Array<FlxColor> = [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F];
		var controls:Array<Control> = [LEFT, DOWN, UP, RIGHT];
		for (i in 0...4)
		{
			var x:Int = Std.int(edges[i]);
			var lane:TouchButton = make(x, laneY, Std.int(edges[i + 1]) - x, laneHeight, colors[i], controls[i]);
			var index:Int = i;
			lane.touchCheck = function() return isLaneTouched(index);
			lanes.push(lane);
		}
		buttonLeft = lanes[0];
		buttonDown = lanes[1];
		buttonUp = lanes[2];
		buttonRight = lanes[3];

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

	function isLaneTouched(index:Int):Bool
	{
		updateAssignments();
		for (lane in assignments)
			if (lane == index)
				return true;
		return false;
	}

	function updateAssignments():Void
	{
		if (assignedFrame == MobileInput.currentFrame)
			return;
		assignedFrame = MobileInput.currentFrame;

		var alive:Array<Int> = [];
		for (touch in FlxG.touches.list)
		{
			if (!touch.pressed || MobileInput.isBlocked(touch))
				continue;

			var id:Int = touch.touchPointID;
			alive.push(id);
			touch.getWorldPosition(lanes[0].getCameras()[0], point);

			var current:Int = assignments.exists(id) ? assignments.get(id) : -1;
			if (current != -1 && laneContains(lanes[current], STICKY_PADDING))
				continue;

			var found:Int = -1;
			for (i in 0...lanes.length)
			{
				if (laneContains(lanes[i], 0))
				{
					found = i;
					break;
				}
			}

			if (found == -1)
				assignments.remove(id);
			else
				assignments.set(id, found);
		}

		for (id in [for (key in assignments.keys()) key])
			if (!alive.contains(id))
				assignments.remove(id);
	}

	function laneContains(lane:TouchButton, padding:Float):Bool
	{
		return point.x >= lane.x - padding && point.x < lane.x + lane.width + padding && point.y >= lane.y - padding && point.y < lane.y + lane.height + padding;
	}

	public function dodgeJustPressed():Bool
	{
		return buttonDodge != null && buttonDodge.justPressed();
	}

	override function destroy():Void
	{
		point.put();
		lanes = [];
		assignments.clear();
		owner = null;
		super.destroy();
	}
}
