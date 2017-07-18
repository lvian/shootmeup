package enemies;
import enemies.BaseEnemy;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxVelocity;
import player.Player;

/**
 * ...
 * @author 
 */
class ChaserEnemy extends enemies.BaseEnemy
{

	override public function new(player:player.Player) 
	{
		
		super();
		this.player = player;
		
		hitPoints = 3;
		points = 25;
		fightTimer = 0;
		
		loadGraphic(Reg.CHASER, true, 32, 32);
		animation.add("live", [0, 1, 2, 3, 4, 5], 15, true);
		//animation.add("explosion", [0, 1, 2, 3], 30, true);
		animation.play("live");
		
	}
	

	
	
	
	override public function kill():Void
	{
		//FlxG.sound.play("Asplode");
		//Reg.deadEnemies  .dispatch();
		hitPoints = 2;
		points = 25;
		fightTimer = 0;
		super.kill();
		
	}
	
	
	/* INTERFACE IEnemyStates */
	
	public override function enteringScreen():Void 
	{
		if (enterPosition == NW)
		{
			
				if (y >= (FlxG.height / 7) )
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
			
		}
		else if (enterPosition == NE)
		{
			
				if (y >= (FlxG.height / 7) )
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
			
		}
		else if (enterPosition == SW )
		{
		
				if (y <= ((FlxG.height / 7) * 6 ) - height)
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
			
		}
		else if ( enterPosition == SE)
		{
			if (y <= ((FlxG.height / 7) * 6) - height )
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
			
		} else {
			if (y <= ((FlxG.height / 7) * 6) - height )
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
		}
	}
	
	public override function idle():Void 
	{
		state = enemies.BaseEnemy.EnemyState.Fighting;
		
	}
	
	public override function fighting():Void 
	{
		FlxVelocity.moveTowardsObject(this, player, 150);
		fightTimer += FlxG.elapsed;
		if (fightTimer > 4)
		{
			state = enemies.BaseEnemy.EnemyState.Other;		
			fightTimer = 0;
		}
		//FlxTween.cubicMotion(this,
	}
	
	public override function moving():Void 
	{
		
	}
	
	public override function leavingScreen():Void 
	{
		
	}
	
	public override function attacking():Void 
	{
		
	}
	
	public override function other():Void 
	{
		
		kill();
		
		
		//Explosion logic
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