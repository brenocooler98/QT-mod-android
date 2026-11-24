package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxCamera;
import Controls.Control;
import mobile.Hitbox;
import mobile.MobileButton;
import mobile.MobileControls;
import mobile.MobileInput;
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

	public var hitbox:Hitbox;
	public var backButton:MobileButton;
	public var pauseButton:MobileButton;

	var mobileCamera:FlxCamera;

	function getMobileCamera():FlxCamera
	{
		if (mobileCamera == null)
			mobileCamera = MobileControls.createCamera();
		return mobileCamera;
	}

	public function enableTouchMenu():Void
	{
		MobileInput.addSwipeState(this);
	}

	public function addBackButton():Void
	{
		backButton = MobileControls.createBackButton(this, getMobileCamera());
		add(backButton);
	}

	public function addPauseButton():Void
	{
		pauseButton = MobileControls.createPauseButton(this, getMobileCamera());
		add(pauseButton);
	}

	public function addHitbox(withDodge:Bool, dodgeOnTop:Bool):Void
	{
		hitbox = MobileControls.createHitbox(this, getMobileCamera(), withDodge, dodgeOnTop);
		add(hitbox);
	}

	function touchList(items:Array<Dynamic>, selected:Int, change:Int->Void):Void
	{
		MobileControls.handleList(this, cast items, selected, change);
	}

	function touchTap(?object:flixel.FlxBasic, control:Control):Bool
	{
		return MobileControls.handleTap(this, object, control);
	}

	override function destroy()
	{
		MobileInput.removeSwipeState(this);
		MobileControls.destroyCamera(mobileCamera);
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
