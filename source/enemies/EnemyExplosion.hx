package enemies;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * ...
 * @author 
 */
class EnemyExplosion extends FlxSprite
{

	public function new() 
	{
		// X,Y: Starting coordinates
		super(-64,-64);
		
		loadGraphic(Reg.ENEMYEXPLOSION, true, 32, 32);
		animation.add("live", [0, 1, 2, 3, 4, 5, 6, 7, 8], 20, false);
		//animation.play("live"); 
	}
	
	
	
	public override function update(elapsed:Float):Void
	{
				
		if ( animation.finished)
		{
			
			kill();
		}
		
		super.update(elapsed);
	}
	
}