package util;
import flixel.FlxBasic;
import enemies.BaseEnemy;
import misc.BasePowerUp;

/**
 * ...
 * @author 
 */

 enum EnemyType {
	Popcorn;
	Shooter;
	Chaser;
	HardShooter;
 }
 
 class EnemyWaves extends FlxBasic
{
	 public var timeToStart:Int;
	 public var quantity:Int;
	 public var type:EnemyType;
	 public var delay:Float;
	 public var enter:EnemyPositions;
	 public var exit:EnemyPositions;
	 public var drop:misc.BasePowerUp.PowerUpType;
	
	 public function new(time:Int , quant:Int , tp:EnemyType, dl:Float= 0, ent:EnemyPositions =null , ext:EnemyPositions =null, drp:misc.BasePowerUp.PowerUpType=null) 
	{
		super();
		timeToStart = time;
		quantity = quant;
		type = tp;
		delay = dl;
		enter = ent;
		exit = ext;
		drop = drp;
	}
	
}