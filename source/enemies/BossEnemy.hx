package enemies;
import enemies.BaseEnemy;
import enemies.EnemyBaseBullet;
import flixel.addons.display.FlxNestedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import player.Player;

/**
 * ...
 * @author 
 */
class BossEnemy extends enemies.MultiSpriteEnemy
{

	public var body:FlxNestedSprite;
	public var leftCannon:FlxNestedSprite;
	public var rightCannon:FlxNestedSprite;
	public var middleCannon:FlxNestedSprite;
	
	public var fireBurst:Int;
	public var leftCannonDestroyed:Bool;
	public var middleCannonDestroyed:Bool;
	public var rightCannonDestroyed:Bool;
	public var defeated:Bool;
	
	override public function new(bullets:FlxTypedGroup<enemies.EnemyBaseBullet>, player:player.Player) 
	{
		super();
		this.player = player;
		enemyBullets = bullets;
		fireDelay = 2;
		fireCooldown = 0;
		defeated = false;
		hitPoints = 250;
		points = 10000;
		fightTimer = 0;
		fireBurst = 10;
		makeGraphic(0, 0, 0x00FFFFFF);
		
		leftCannonDestroyed = false;
		middleCannonDestroyed = false;
		rightCannonDestroyed = false;
		
		body = new FlxNestedSprite();
		body.makeGraphic(300, 150, FlxColor.YELLOW);
		body.visible = true;
		body.solid = false;
		body.health = 200;
		add(body);
		
		leftCannon = new FlxNestedSprite();
		leftCannon.makeGraphic(32, 32, FlxColor.RED);
		leftCannon.relativeX= 16 ;
		leftCannon.relativeY = body.height - (leftCannon.height + 16);
		leftCannon.solid = true;
		leftCannon.health = 100;
		add(leftCannon);
		
		middleCannon = new FlxNestedSprite();
		middleCannon.makeGraphic(32, 32, FlxColor.RED);
		middleCannon.relativeX= (body.width / 2) - (middleCannon.width /2) ;
		middleCannon.relativeY = body.height - (middleCannon.height + 16);
		middleCannon.solid = true;
		middleCannon.health = 100;
		add(middleCannon);
		
		rightCannon = new FlxNestedSprite();
		rightCannon.makeGraphic(32, 32, FlxColor.RED);
		rightCannon.relativeX = body.width - (rightCannon.width + 16);
		rightCannon.relativeY = body.height- (rightCannon.height + 16);
		rightCannon.solid = true;
		rightCannon.health = 100;
		add(rightCannon);
		
	}
	
	
	public function shoot()
	{
		
		if (fireCooldown <= 0)
		{
			if (fireBurst > 0)
			{
				var bullet:enemies.EnemyBaseBullet = enemyBullets.recycle();
				switch FlxG.random.int(1, 3)
				{
					case 1:
						bullet.reset( leftCannon.getMidpoint().x , leftCannon.getMidpoint().y);
					case 2:
						bullet.reset( middleCannon.getMidpoint().x , middleCannon.getMidpoint().y);
					case 3:
						bullet.reset( rightCannon.getMidpoint().x , rightCannon.getMidpoint().y);
				}
				
				bullet.angle = 0;
				bullet.animation.play("live");	
				FlxVelocity.moveTowardsPoint(bullet, player.getGraphicMidpoint() , 120);
				fireBurst --;
				fireCooldown = 0.2;
			} else
			{
				fireBurst =  10;
				fireCooldown = fireDelay; 
			}
			
		}		
	}
	
	override public function kill():Void
	{
		
		//Explosion animation
		defeated = true;
		super.kill();
	
	}
	
	/* INTERFACE IEnemyStates */
	
	public override function enteringScreen():Void 
	{
		
		if (y >= 10)
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
		//drag.y = 75;
		velocity.set(0,0);
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
	
	public override function checkOtherEffects():Void 
	{
		
		if (leftCannon.health <= 0)
		{
			//change cannon sprite
			leftCannon.solid = false;
			leftCannonDestroyed = true;
		}
		if (middleCannon.health <= 0)
		{
			middleCannon.solid = false;
			middleCannonDestroyed = true;
		}
		if (rightCannon.health <= 0)
		{
			rightCannon.solid = false;
			rightCannonDestroyed = true;
		}
		
		if (rightCannonDestroyed && middleCannonDestroyed && leftCannonDestroyed && body.solid == false)
		{
			body.solid = true;
		}
		
		if (body.solid && body.health <= 0)
		{
			//Boss destroyed animation
			kill();
			
		}
	}
	
}