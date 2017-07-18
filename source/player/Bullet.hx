package player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import player.PlayerBulletExplosion;


/**
 * ...
 * @author ...
 */
class Bullet extends FlxSprite
{

	public var damage:Int;
	public var explosions:FlxGroup;
		
	public function new() 
	{
		
		super( -64 , -64);
		
		loadGraphic(Reg.PLAYERBULLETS, true, 6, 16);
		animation.add("live",[0, 1, 2, 3, 4], 20, true);
		damage = 1;
		
	}
	
	public override function update(elapsed:Float):Void
	{
		if (!alive)
		{
			if (animation.finished)
			{
				exists = false;
			}
		}
		else if (touching != 0)
		{
			
			kill();
		}
		else if (!isOnScreen())
		{
			kill();
		}
		super.update(elapsed);
	}
	
	public function shootBullet( X:Float, Y:Float):Void
	{
		// reset() makes the sprite exist again, at the new location you tell it.
		
		super.reset(X ,Y );  
		solid = true;
		
	}
	
	
	override public function kill():Void
	{
		//cast(player, Player).tookDamage(cast(bullet, EnemyBaseBullet).damage);
		var explo:player.PlayerBulletExplosion = cast(explosions.recycle(), player.PlayerBulletExplosion);
		explo.reset(this.x, this.y);
		explo.angle = FlxG.random.float(0, 360);
		explo.animation.play('live', true);
		angle = 0;
		velocity.set(0, 0);
		alive = false;
		super.kill();
		
	}
	
}