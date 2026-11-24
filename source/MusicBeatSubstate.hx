package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxCamera;
import mobile.Hitbox;
import mobile.TouchButton;
import mobile.VirtualPad;
import flixel.util.FlxColor;
import flixel.FlxSubState;

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public var virtualPad:VirtualPad;
	public var hitbox:Hitbox;

	var mobileCamera:FlxCamera;

	function getMobileCamera():FlxCamera
	{
		if (mobileCamera == null)
		{
			mobileCamera = new FlxCamera();
			mobileCamera.bgColor = FlxColor.TRANSPARENT;
			FlxG.cameras.add(mobileCamera, false);
		}
		return mobileCamera;
	}

	public function addVirtualPad(dpad:DPadMode, action:ActionMode):Void
	{
		removeVirtualPad();
		virtualPad = new VirtualPad(this, dpad, action);
		var camera:FlxCamera = getMobileCamera();
		virtualPad.forEach(function(button:TouchButton) button.cameras = [camera]);
		add(virtualPad);
	}

	public function removeVirtualPad():Void
	{
		if (virtualPad != null)
		{
			remove(virtualPad, true);
			virtualPad.destroy();
			virtualPad = null;
		}
	}

	public function addHitbox(withDodge:Bool, dodgeOnTop:Bool):Void
	{
		hitbox = new Hitbox(this, withDodge, dodgeOnTop);
		var camera:FlxCamera = getMobileCamera();
		hitbox.forEach(function(button:TouchButton) button.cameras = [camera]);
		add(hitbox);
	}

	override function destroy()
	{
		if (mobileCamera != null && FlxG.cameras.list.contains(mobileCamera))
			FlxG.cameras.remove(mobileCamera);
		mobileCamera = null;
		super.destroy();
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep > 0)
			stepHit();


		super.update(elapsed);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
