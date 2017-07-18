package misc;
import flixel.FlxSprite;

/**
 * ...
 * @author 
 */

enum PowerUpType {
	BulletWeapon;
	MissileWeapon;
	LaserWeapon;
	WeaponLevelUpgrade;
	Money;
	Live;
	Shield;
}
 
class BasePowerUp extends FlxSprite
{
	public var powerUpType:PowerUpType;
	
	public function new() 
	{
		super();
	}
		
}