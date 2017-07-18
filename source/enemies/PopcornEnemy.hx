package enemies;

import enemies.BaseEnemy;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxVelocity;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author 
 */
enum Formation {
	Square;
	Line;
	Double;
	Circle;
 }
 
 
class PopcornEnemy extends BaseEnemy
{
	
	var formation:Formation;
	
	override public function new(bullets:FlxTypedGroup<enemies.EnemyBaseBullet>, player:player.Player , form:Formation) 
	{
		super();
		this.player = player;
		enemyBullets = bullets;
		formation = form;
		fireDelay = GameSettings.SHOOTERFIREDELAY;
		fireCooldown = 0;
		velocity.x = GameSettings.SHOOTERFIREDELAY;
		hitPoints = GameSettings.SHOOTERHITPOINTS;
		points = GameSettings.SHOOTERPOINTS;
		fightTimer = 0;
		
		loadGraphic(Reg.SHOOTER, true, 32, 32);
		animation.add("live", [0, 1, 2, 3, 4, 5, 6],10, true);
		//animation.add("explosion", [0, 1, 2, 3], 30, true);
		animation.play("live");
	}
	
	public function shoot()
	{
		if (fireCooldown <= 0)
		{
			var bullet:enemies.EnemyBaseBullet = enemyBullets.recycle();
			bullet.reset(x , y);
			bullet.angle = 0;
			bullet.animation.play("live");	
			FlxVelocity.moveTowardsPoint(bullet, player.getGraphicMidpoint() , 220);
			fireCooldown = fireDelay; 
		}		
	}
	
	override public function kill():Void
	{
		
		//Explosion animation
		fireCooldown = 0;
		hitPoints = 2;
		fightTimer = 0; 
		setPosition( -50, -50);
		enterPosition = null;
		exitPosition= null;
		super.kill();
	
	}
	
	/* INTERFACE IEnemyStates */
	
	public override function enteringScreen():Void 
	{
		if (enterPosition == NW)
		{
			if (exitPosition == NW)
			{
				if (y >= (FlxG.height / 7) * 2 )
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
			} else {
				if (y >= (FlxG.height / 7) )
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
			}
		}
		else if (enterPosition == NE)
		{
			if (exitPosition == NE)
			{
				if (y >= (FlxG.height / 7) * 2 )
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
			} else
			{
				if (y >= (FlxG.height / 7) )
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
			}
		}
		else if (enterPosition == SW )
		{
			if (exitPosition == SW)
			{
				if (y <= ((FlxG.height / 7) * 5) - height  )
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
			}else
			{
				if (y <= ((FlxG.height / 7) * 6 ) - height)
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
			}
		}
		else if ( enterPosition == SE)
		{
			if (exitPosition == SE)
			{
				if (y <= ((FlxG.height / 7) * 5) - height )
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
			}else
			{
				if (y <= ((FlxG.height / 7) * 6) - height )
				{
					state = enemies.BaseEnemy.EnemyState.Idle;
				}
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
		//tween = FlxTween.cubicMotion(this , x, y, FlxRandom.floatRanged( 20 , FlxG.width - 20), FlxRandom.floatRanged( 20 , FlxG.height / 2), FlxRandom.floatRanged( 20 , FlxG.width - 20), FlxRandom.floatRanged( 20 , FlxG.height / 2), FlxRandom.floatRanged( 20 , FlxG.width - 20), FlxRandom.floatRanged( 20 , FlxG.height / 2), 2) ;
		state = enemies.BaseEnemy.EnemyState.Fighting;
		startTween();
		
	}
	
	public override function fighting():Void 
	{
		shoot();
		fightTimer += FlxG.elapsed;
		if (fightTimer > GameSettings.SHOOTERFIGHTTIME || tween.finished)
		{
			state = enemies.BaseEnemy.EnemyState.LeavingScreen;		
			fightTimer = 0;
		}
		//FlxTween.cubicMotion(this,
	}
	
	public override function moving():Void 
	{
		
	}
	
	public override function leavingScreen():Void 
	{
		shoot();
		if (exitPosition != null)
		{
			switch (exitPosition) {
				case NW:
					velocity.y = -125;
				case NE:
					velocity.y = -125;
				case SW:
					velocity.y = 125;
				case SE: 
					velocity.y = 125;
			}
		} else {
			velocity.y = 125;
		}
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
	
	public function startTween()
	{
		if (enterPosition != null)
		{
			switch (enterPosition) {
				case NW:
					switch (exitPosition) {
						case NW:
							tween = FlxTween.circularMotion(this,
														x + (FlxG.height / 7) * 2, 
														y, 
														(FlxG.height / 7) * 2,
														180,
														false,
														4);
						case NE:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											FlxG.width /  2 ,
											(FlxG.height /  3) ,
											(FlxG.width /  2 ) ,
											(FlxG.height /  3) * 2,
											x ,
											(FlxG.height /  7) * 6,
											4) ;
						case SW:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											FlxG.width /  2 ,
											(FlxG.height /  3) ,
											(FlxG.width /  2 ) ,
											(FlxG.height /  3) * 2,
											x ,
											(FlxG.height /  7) * 6,
											4) ;
						case SE:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											FlxG.width /  4 ,
											(FlxG.height /  2) ,
											(FlxG.width /  3) * 2 ,
											(FlxG.height /  3) ,
											((FlxG.width /  7)  * 6) - width / 2 ,
											(FlxG.height /  7) * 6,
											4) ;
					}
				case NE:
					
					switch (exitPosition) {
						case NW:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											(FlxG.width /  3) * 2 ,
											(FlxG.height /  3) * 2,
											(FlxG.width /  3 ) ,
											(FlxG.height /  3) * 2,
											(FlxG.width /  7) - width / 2 ,
											FlxG.height /  7  ,
											4) ;
						case NE:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											FlxG.width /  2 ,
											(FlxG.height /  3) ,
											(FlxG.width /  2 ) ,
											(FlxG.height /  3) * 2,
											x ,
											(FlxG.height /  7) * 6,
											4) ;
						case SW:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											(FlxG.width /  4) * 3,
											(FlxG.height /  2) ,
											(FlxG.width /  3) ,
											(FlxG.height /  3) ,
											(FlxG.width /  7) - width / 2 ,
											(FlxG.height /  7) * 6,
											4) ;
						case SE:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											FlxG.width /  2 ,
											(FlxG.height /  3) ,
											(FlxG.width /  2 ) ,
											(FlxG.height /  3) * 2,
											x ,
											(FlxG.height /  7) * 6,
											4) ;
					}
				case SW:
					
					switch (exitPosition) {
						case NW:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											FlxG.width /  2 ,
											(FlxG.height /  3) * 2 ,
											(FlxG.width /  2 ) ,
											(FlxG.height /  3) ,
											x ,
											(FlxG.height /  7) ,
											4) ;
						case NE:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											FlxG.width /  4 ,
											(FlxG.height /  2) ,
											(FlxG.width /  3) * 2 ,
											(FlxG.height /  3) * 2 ,
											((FlxG.width /  7)  * 6) - width / 2 ,
											(FlxG.height /  7),
											4) ;
						case SW:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											FlxG.width /  2 ,
											(FlxG.height /  3) * 2 ,
											(FlxG.width /  2 ) ,
											(FlxG.height /  3) ,
											x ,
											(FlxG.height /  7) ,
											4) ;
						case SE:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											(FlxG.width /  3)  ,
											(FlxG.height /  3) ,
											(FlxG.width /  3 ) * 2 ,
											(FlxG.height /  3) ,
											((FlxG.width /  7) * 6) - width / 2 ,
											(FlxG.height /  7  * 6) - height,
											4) ;
					}
				case SE:
					
					switch (exitPosition) {
						case NW:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											(FlxG.width /  4) * 3 ,
											(FlxG.height /  2) ,
											(FlxG.width /  3)  ,
											(FlxG.height /  3) * 2 ,
											(FlxG.width /  7) - width / 2 ,
											(FlxG.height /  7),
											4) ;
						case NE:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											FlxG.width /  2  ,
											(FlxG.height /  3) * 2 ,
											(FlxG.width /  2 ) ,
											(FlxG.height /  3) ,
											x ,
											(FlxG.height /  7) ,
											4) ;
						case SW:
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											(FlxG.width /  3) *2  ,
											(FlxG.height /  3) ,
											(FlxG.width /  3 )  ,
											(FlxG.height /  3) ,
											((FlxG.width /  7) ) - width / 2 ,
											(FlxG.height /  7  * 6) - height,
											4) ;
						case SE:
							
							tween = FlxTween.cubicMotion( this ,
											x,
											y,
											FlxG.width /  2  ,
											(FlxG.height /  3) * 2 ,
											(FlxG.width /  2 ) ,
											(FlxG.height /  3) ,
											x ,
											(FlxG.height /  7) ,
											4) ;
														
					}
			}
		} else 
		{
			tween = FlxTween.cubicMotion( this ,
										x,
										y,
										FlxG.random.float( 20, FlxG.width- 20) ,
										FlxG.random.float( (FlxG.height/ 6), (FlxG.height / 6) * 3),
										FlxG.random.float( 20, FlxG.width- 20) ,
										FlxG.random.float( (FlxG.height/ 6) * 3, (FlxG.height / 6) * 4),
										FlxG.random.float( 20, FlxG.width- 20) ,
										(FlxG.height / 6) * 5,
										4) ;
		}
	}
}