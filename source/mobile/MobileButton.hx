package mobile;

import Controls.Control;
import flixel.FlxSprite;
import flixel.FlxState;

class MobileButton extends FlxSprite
{
	public var owner:FlxState;
	public var control:Control;

	public function new(asset:String, prefix:String, control:Control, size:Float)
	{
		super();
		this.control = control;

		frames = Paths.getSparrowAtlas('mobile/' + asset, 'shared');
		animation.addByNames('idle', [prefix + '0000'], 24, false);
		animation.addByPrefix('press', prefix, 24, false);
		animation.play('idle');

		setGraphicSize(Std.int(frameWidth * size));
		updateHitbox();
		scrollFactor.set();
		antialiasing = true;

		MobileInput.addBlocker(this);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (owner == MobileInput.topState() && visible && TouchUtil.justTouched(this))
		{
			animation.play('press', true);
			MobileInput.inject(control);
		}

		if (animation.name == 'press' && animation.finished)
			animation.play('idle');
	}

	override function destroy():Void
	{
		MobileInput.removeBlocker(this);
		owner = null;
		super.destroy();
	}
}
