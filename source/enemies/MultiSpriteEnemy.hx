package enemies;

import enemies.EnemyBaseBullet;
import flixel.addons.display.FlxNestedSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import enemies.BaseEnemy;
import flixel.util.FlxSpriteUtil;
import player.Player;

/**
 * ...
 * @author 
 */
class MultiSpriteEnemy extends FlxNestedSprite
{

	public var enemyBullets:FlxTypedGroup<enemies.EnemyBaseBullet>;
	public var fireDelay:Float;
	public var fireCooldown:Float;
	public var player:player.Player;
	public var upgradeLevel:Int;
	public var hitPoints:Int;
	public var points:Int;
	public var state:EnemyState;
	public var fightTimer:Float;
	public var tween:FlxTween; 
	
	
	public function new() 
	{
		super();
		fireCooldown = 0;
	}


	
	
	
	override public function update(elapsed:Float):Void
	{
		fireCooldown -= FlxG.elapsed; 
		
		switch(state) {
				
			case EnteringScreen:
				enteringScreen();
			case Idle:
				idle();
			case Fighting:
				fighting();
			case Moving:
				moving();
			case LeavingScreen:
				leavingScreen();
			case Attacking:
				attacking();
			case Other:
				other();
		}
		
		checkOtherEffects();
		
		super.update(elapsed);
	}
	
		
	public function tookDamage(damage:Int):Void
	{
		
		hitPoints -= damage;
		if (hitPoints <= 0)
		{
			this.kill();			
		}else
		{
			FlxSpriteUtil.flicker(this, 0.5, 0.05);
		}
	
	}
	
	override public function kill():Void
	{
		//FlxG.sound.play("Asplode");
		Reg.deadEnemies  .dispatch();
		Reg.updateScore  .dispatch(points);
		acceleration.set(0, 0);
		velocity.set(0, 0);
		if (tween != null && tween.active)
		{
			tween.cancel();
		}
		super.kill();
		
		
	}
	
	/* INTERFACE IEnemyStates */
	
	public function enteringScreen():Void 
	{
		
	}
	
	public function idle():Void 
	{
		
	}
	
	public function fighting():Void 
	{
		
	}
	
	public function moving():Void 
	{
		
	}
	
	public function leavingScreen():Void 
	{
		
	}
	
	public function attacking():Void 
	{
		
	}
	
	public function other():Void 
	{
		
	}
	
	public function checkOtherEffects():Void 
	{
		
	}
}