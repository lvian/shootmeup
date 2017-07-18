package enemies;
import enemies.BaseEnemy;
import enemies.EnemyBaseBullet;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;
import misc.BasePowerUp;
import player.Player;
import misc.WeaponLevelPowerUp;

/**
 * ...
 * @author 
 */
class HardShooterEnemy extends enemies.BaseEnemy
{

	public var fireBurst:Int;
	public var drop:misc.BasePowerUp.PowerUpType;
	override public function new(bullets:FlxTypedGroup<enemies.EnemyBaseBullet>, player:player.Player) 
	{
		super();
		this.player = player;
		enemyBullets = bullets;
		fireDelay = 2;
		fireCooldown = 0;
		
		loadGraphic(Reg.HARDSHOOTER, true, 64, 64);
		animation.add("live", [0, 1, 2, 3, 4, 5, 6 , 7, 8, 9, 10, 11, 12, 13, 14],15, true);
		//animation.add("explosion", [0, 1, 2, 3], 30, true);
		animation.play("live");
		hitPoints = 25;
		points = 250;
		fightTimer = 0;
		fireBurst = 5;
	}
	
	
	public function shoot()
	{
		if (fireCooldown <= 0)
		{
			if (fireBurst > 0)
			{
			var bullet:enemies.EnemyBaseBullet = enemyBullets.recycle();
			bullet.reset( x + (width/2) , y + height);
			bullet.angle = 0;
			bullet.animation.play("live");	
			FlxVelocity.moveTowardsPoint(bullet, player.getGraphicMidpoint() , 120);
			fireBurst --;
			fireCooldown = 0.2;
			} else
			{
				fireBurst =  5;
				fireCooldown = fireDelay; 
			}
			
		}		
	}
	
	override public function kill():Void
	{
		
		//Explosion animation
		fireCooldown = 0;
		hitPoints = 25;
		fightTimer = 0; 
		fireBurst = 5;
		
		if (drop != null)
		{
			var upgrade = new misc.WeaponLevelPowerUp(drop);
			Reg.playerGroup.add(upgrade);
			upgrade.setPosition(getMidpoint().x, getMidpoint().y);
			upgrade.velocity.y = 50;
			//upgrades.add(upgrade);
		}
		
		
		super.kill();
	
	}
	
	/* INTERFACE IEnemyStates */
	
	public override function enteringScreen():Void 
	{
		if (y >= 5)
		{
			state = enemies.BaseEnemy.EnemyState.Idle;
		}else
		{
			velocity.y = 100;
		}
	}
	
	public override function idle():Void 
	{
		//tween = FlxTween.cubicMotion(this , x, y, FlxRandom.floatRanged( 20 , FlxG.width - 20), FlxRandom.floatRanged( 20 , FlxG.height / 2), FlxRandom.floatRanged( 20 , FlxG.width - 20), FlxRandom.floatRanged( 20 , FlxG.height / 2), FlxRandom.floatRanged( 20 , FlxG.width - 20), FlxRandom.floatRanged( 20 , FlxG.height / 2), 2) ;
		drag.y = 75;
		state = enemies.BaseEnemy.EnemyState.Fighting;
		
	}
	
	public override function fighting():Void 
	{
		shoot();
		
	}
	
	public override function moving():Void 
	{
		
	}
	
	public override function leavingScreen():Void 
	{
		if (!isOnScreen())
		{
			kill();
		}
	}
	
	public override function attacking():Void 
	{
		
	}
	
	public override function other():Void 
	{
		
	}
	
	
	public override function set_EnterExit(enter:enemies.BaseEnemy.EnemyPositions , exit:enemies.BaseEnemy.EnemyPositions )
	{
		enterPosition = enter;
		exitPosition = exit;
		var posX:Float;
		var posY:Float;
		var auxVelocity:Float;
		switch (enterPosition) {
			case NW:
				posX = (FlxG.width /  7) - width / 2;
				posY = -50;
				auxVelocity= 125;
			case NE:
				posX = ((FlxG.width /  7) * 6) - width / 2 ;
				posY = -50;
				auxVelocity = 125;
			case SW:
				posX = (FlxG.width /  7) - width / 2;
				posY = FlxG.height + 50;
				auxVelocity = -125;
			case SE: 
				posX = ((FlxG.width /  7) * 6) - width / 2;
				posY = FlxG.height + 50;
				auxVelocity = -125;
		}
		reset(posX, posY);
		velocity.y = auxVelocity;
		state = enemies.BaseEnemy.EnemyState.EnteringScreen;
	}
}