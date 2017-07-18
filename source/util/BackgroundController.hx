package util;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */


@:enum
abstract BackgroundSpeed(Float) 
{
	var Stopped = 0;
	var Half = 0.5;
	var Normal = 1;
	var Double = 2;
}

class BackgroundController
{
	
	var background:FlxBackdrop;
	var originalVelocity:Float;
		
	public function new(backgroundFile:String , backgroundVelocity) 
	{
		background = new FlxBackdrop(backgroundFile);	
		originalVelocity = backgroundVelocity;
		background.velocity.set(0, originalVelocity);
		
		
		Reg.backgroundGroup.add(background);
		
	}
	
	
	public function backgroundSpeed(speed:BackgroundSpeed)
	{
		background.velocity.set(0, ( cast(speed, Float) * originalVelocity )  );
	}
	
}