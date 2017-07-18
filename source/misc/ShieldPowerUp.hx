package misc;

import flixel.util.FlxColor;
import misc.BasePowerUp.PowerUpType;

/**
 * ...
 * @author 
 */
class ShieldPowerUp extends BasePowerUp
{

	public function new(type:PowerUpType) 
	{
		super();
		
		//loadGraphic(Reg.PLAYERBULLETS, true, 6, 16);
		//animation.add("live",[0, 1, 2, 3, 4], 20, true);
		makeGraphic(32	, 32 , FlxColor.BLUE);
		powerUpType = type;
	}
	
	
}