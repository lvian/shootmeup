package enemies;
import enemies.EnemyBulletExplosion;
import flixel.addons.effects.FlxTrail;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;

/**
 * ...
 * @author ...
 */
class EnemyBaseBullet extends FlxSprite
{

	// First we will instantiate the bullets you fire at your enemies.
	public var target:FlxPoint;
	public var speed:Int;
	public var damage:Int;
	public var explosions:FlxGroup;
	
	public function new() 
	{
		
		super(-64 , -64);
		damage = 1;
		loadGraphic(Reg.BULLETS, true);
		animation.add("live", [0, 1, 2, 3, 4, 5, 6], 7, true);
		
		//animation.add("poof",[2, 3, 4], 50, false);
		//makeGraphic(4, 6, FlxColor.BLUE);
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
		else if (!isOnScreen())
		{
			kill();
		}
		
		super.update(elapsed);
	}
	
	public function shootBullet(x:Float, y:Float):Void
	{
		// reset() makes the sprite exist again, at the new location you tell it.
		super.reset(x, y);  
		
		solid = true;
		
		velocity.y = 300;
		
	}
	
	
	
	override public function kill():Void
	{
		var explo:enemies.EnemyBulletExplosion = cast(explosions.recycle(), enemies.EnemyBulletExplosion);
		explo.reset(this.x, this.y);
		explo.angle = FlxG.random.float(0, 360);
		explo.animation.play('live', true);
		angle = 0;
		velocity.set(0, 0);
		alive = false;
		super.kill();
		
	}
	
}