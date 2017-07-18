package enemies;

import enemies.EnemyBaseBullet;
import enemies.EnemyExplosion;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.math.FlxAngle;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.util.FlxSignal;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxVelocity;
import player.Player;

/**
 * ...
 * @author 
 */
enum EnemyState
{
	Idle;
	EnteringScreen;
	LeavingScreen;
	Moving;
	Fighting;
	Attacking;
	Other;
}

enum EnemyPositions
{
	NW;
	NE;
	SW;
	SE;
}
	
class BaseEnemy extends FlxSprite 
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
	public var enterPosition:EnemyPositions;
	public var exitPosition:EnemyPositions;
	public var explosions:FlxTypedGroup<enemies.EnemyExplosion>;
	
	
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
			
		super.update(elapsed);
	}
	
	
	public function new() 
	{
		super();
		
		fireCooldown = 0;
		
	}
		
	public function tookDamage(damage:Int):Void
	{
		
		hitPoints -= damage;
		if (hitPoints <= 0)
		{
			this.deathAnimation();
			this.kill();			
		}else
		{
			FlxSpriteUtil.flicker(this, 0.5, 0.05);
		}
	
	}
	
	public function deathAnimation()
	{
		var explo:enemies.EnemyExplosion = explosions.recycle(enemies.EnemyExplosion);
		explo.reset(this.x, this.y);
		explo.angle = FlxG.random.float(0, 360);
		explo.animation.play('live',true);
	}
	
	override public function kill():Void
	{
		//FlxG.sound.play("Asplode");
		this.deathAnimation();
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
	
	
	public  function set_EnterExit(enter:BaseEnemy.EnemyPositions , exit:BaseEnemy.EnemyPositions )
	{
	
	}
}