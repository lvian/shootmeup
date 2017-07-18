package player;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import player.PlayerBulletExplosion;

/**
 * ...
 * @author 
 */
class MissileExplosion extends player.PlayerBulletExplosion
{

	public function new() 
	{
		// X,Y: Starting coordinates
		super();
		
		loadGraphic(Reg.MISSILEXPLOSION, true, 16, 16);
		animation.add("live", [0, 1, 2, 3, 4, 5, 6], 20, false);
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