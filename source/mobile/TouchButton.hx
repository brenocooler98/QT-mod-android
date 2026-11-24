package mobile;

import Controls.Control;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.FlxInput.FlxInputState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

enum TouchButtonIcon
{
	NONE;
	ARROW(angle:Float);
	LABEL(text:String);
}

class TouchButton extends FlxSprite
{
	public var control:Null<Control>;
	public var owner:FlxState;
	public var idleAlpha:Float = 0.45;
	public var pressedAlpha:Float = 0.85;

	public function new(x:Float, y:Float, width:Int, height:Int, color:FlxColor, ?control:Control, ?icon:TouchButtonIcon, rounded:Bool = true)
	{
		super(x, y);
		this.control = control;
		if (icon == null)
			icon = NONE;

		var key:String = 'touchbutton_${width}x${height}_${color.toHexString()}_${rounded}_${Std.string(icon)}';
		var cached:Bool = FlxG.bitmap.get(key) != null;
		makeGraphic(width, height, FlxColor.TRANSPARENT, false, key);
		graphic.persist = true;
		if (!cached)
			drawGraphic(width, height, color, icon, rounded);

		scrollFactor.set();
		alpha = idleAlpha;
		MobileInput.register(this);
	}

	function drawGraphic(width:Int, height:Int, color:FlxColor, icon:TouchButtonIcon, rounded:Bool):Void
	{
		var radius:Float = rounded ? Math.min(width, height) * 0.3 : 0;
		var border:Int = 4;
		FlxSpriteUtil.drawRoundRect(this, 0, 0, width, height, radius, radius, FlxColor.BLACK);
		FlxSpriteUtil.drawRoundRect(this, border, border, width - border * 2, height - border * 2, radius, radius, color);

		switch (icon)
		{
			case ARROW(angle):
				var cx:Float = width / 2;
				var cy:Float = height / 2;
				var size:Float = Math.min(width, height) * 0.28;
				var rad:Float = angle * Math.PI / 180;
				var points:Array<flixel.math.FlxPoint> = [];
				for (p in [[0.0, -1.0], [1.0, 0.7], [-1.0, 0.7]])
				{
					var px:Float = p[0] * size;
					var py:Float = p[1] * size;
					points.push(flixel.math.FlxPoint.get(cx + px * Math.cos(rad) - py * Math.sin(rad), cy + px * Math.sin(rad) + py * Math.cos(rad)));
				}
				FlxSpriteUtil.drawPolygon(this, points, FlxColor.WHITE, {thickness: 3, color: FlxColor.BLACK});
				for (p in points)
					p.put();
			case LABEL(text):
				var label:FlxText = new FlxText(0, 0, width, text);
				label.setFormat(null, Std.int(Math.min(width, height) * 0.38), FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
				label.borderSize = 2;
				label.drawFrame(true);
				stamp(label, 0, Std.int((height - label.height) / 2));
				label.destroy();
			case NONE:
		}
	}

	public function check(state:FlxInputState):Bool
	{
		if (!exists || !visible)
			return false;

		var camera:FlxCamera = cameras[0];
		for (touch in FlxG.touches.list)
		{
			var stateMatches:Bool = switch (state)
			{
				case PRESSED: touch.pressed;
				case JUST_PRESSED: touch.justPressed;
				case JUST_RELEASED: touch.justReleased;
				case RELEASED: !touch.pressed;
			}
			if (stateMatches && touch.overlaps(this, camera))
				return true;
		}
		return false;
	}

	public inline function pressed():Bool
		return check(PRESSED);

	public inline function justPressed():Bool
		return check(JUST_PRESSED);

	public inline function justReleased():Bool
		return check(JUST_RELEASED);

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		alpha = pressed() ? pressedAlpha : idleAlpha;
	}

	override function destroy():Void
	{
		MobileInput.unregister(this);
		owner = null;
		super.destroy();
	}
}
