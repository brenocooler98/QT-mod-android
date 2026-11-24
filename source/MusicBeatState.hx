package;

import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.Lib;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxCamera;
import mobile.Hitbox;
import mobile.TouchButton;
import mobile.VirtualPad;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;

class MusicBeatState extends FlxUIState
{
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

	override function create()
	{
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
	}


	var array:Array<FlxColor> = [
		FlxColor.fromRGB(148, 0, 211),
		FlxColor.fromRGB(75, 0, 130),
		FlxColor.fromRGB(0, 0, 255),
		FlxColor.fromRGB(0, 255, 0),
		FlxColor.fromRGB(255, 255, 0),
		FlxColor.fromRGB(255, 127, 0),
		FlxColor.fromRGB(255, 0 , 0)
	];

	var skippedFrames = 0;

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		if (FlxG.save.data.fpsRain && skippedFrames >= 6)
			{
				if (currentColor >= array.length)
					currentColor = 0;
				(cast (Lib.current.getChildAt(0), Main)).changeFPSColor(array[currentColor]);
				currentColor++;
				skippedFrames = 0;
			}
			else
				skippedFrames++;

		if ((cast (Lib.current.getChildAt(0), Main)).getFPSCap != FlxG.save.data.fpsCap)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		lastBeat = curStep;
		curBeat = Math.floor(curStep / 4);
	}

	public static var currentColor = 0;

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
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
