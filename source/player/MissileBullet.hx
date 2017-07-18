package player;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.NumTween;
import flixel.math.FlxAngle;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.helpers.FlxRangeBounds;
import player.Bullet;

/**
 * ...
 * @author 
 */
class MissileBullet extends player.Bullet
{
	public var targets:FlxGroup;
	public var target:FlxSprite;
	public var endingVelocity:Int;
	public var startingVelocity:Int;
	public var currentVelocity:NumTween;
	public var chaseTimer:Float;
	public var timerBeforeSeek:Float;
	public var seeker:Bool;
	public var seeking:Bool;
	public var ahead:Bool;
	public var smokeEmitter:FlxEmitter;
	
	
	public function new() 
	{
		
		super();
		
		setPosition(-64,-64);
		//loadGraphic(Reg.PLAYERBULLETS, true, 6, 16);
		//animation.add("live",[0, 1, 2, 3, 4], 20, true);
		loadGraphic(Reg.PLAYERMISSILE, true, 5, 18);
		animation.add("regular", [0,1], 15, true);
		animation.add("seeker", [2,3], 15, true);
		
		startingVelocity = 0;
		endingVelocity = 300;
		chaseTimer = 1.5;
		damage = 2;
		timerBeforeSeek = 0.5;
		seeking = false;
		ahead = true;
		smokeEmitter = new FlxEmitter();
		
		
		
		for (i in 0 ... 25)
        {
        	var p = new FlxParticle();
        	
        	p.loadGraphic(Reg.MISSILESMOKE, true, 5, 5);
        	p.animation.add("live", [0,1,2,3,4], 15, true);
        	p.animation.play("live");
        	p.lifespan = 0.25;
        	smokeEmitter.add(p);
        }
		
		 // Set particle to fade opacity as it goes upwards
        smokeEmitter.alpha.set(1, 1 , 0 , 0);
		
         // Set particle size (scale) range, and grow larger as it fades
        smokeEmitter.scale.set(1, 1, 2, 2);
		
 
		Reg.playerBulletsGroup.add(smokeEmitter);
	}
	
	public override function update(elapsed:Float):Void
	{
		//atualiza velocidade
		
		
		if (seeker && timerBeforeSeek <= 0 )
		{
			if (ahead)
			{
				velocity.set( 0 , - currentVelocity.value) ;
			} else
			{
				velocity.set( 0 ,  currentVelocity.value) ;
			}
			
			if ( chaseTimer >= 0 )
			{
				selectTarget();
				if (target != null)
				{
					FlxTween.angle(this, this.angle , getMidpoint(_point).angleBetween(target.getMidpoint()) , 0.3 , { type: FlxTween.ONESHOT } );
				}
			}
			
			chaseTimer -= FlxG.elapsed;
			var pivot = FlxPoint.weak(0, 0);
			velocity.rotate(pivot, this.angle );// 4.0.0
			
		} else {
			if (ahead)
			{
				velocity.y = - currentVelocity.value ;
			} else
			{
				velocity.y =  currentVelocity.value ;
			}	
		}
		
		
		if (!isOnScreen() )
		{
			kill();
		}
		
		smokeEmitter.focusOn(this);
		timerBeforeSeek -= FlxG.elapsed;
		super.update(elapsed);
		
	}
	
	override public function draw():Void
	{
		smokeEmitter.draw();
		super.draw();
	}
	public function selectTarget() 
	{
		var distance:Int = 500;
		
		for (i in targets)
		{
			if (FlxMath.distanceBetween(this, cast(i,FlxSprite)) < distance && i.alive)
			{
				target = cast(i,FlxSprite);
				distance = FlxMath.distanceBetween(this, cast(i,FlxSprite));
			}
			
		}
		if (distance > 200)
		{
			target = null;
		}
	}
	
	public override function shootBullet( X:Float, Y:Float):Void
	{
		// reset() makes the sprite exist again, at the new location you tell it.
		super.reset(X , Y);  
		angle = 0;
		drag.set(0,0);
		currentVelocity = FlxTween.num(startingVelocity, endingVelocity, 0.5);
		timerBeforeSeek = 0.5;
		seeking = false;
		seeker = false;
		solid = true;
		chaseTimer = 1.5;
		ahead = true;
		
		
        // Start emitting at 1 particle per 0.02 seconds
        smokeEmitter.start(false, 0.5, 0);
	}
	
	override public function kill():Void
	{
		//Play explode animation
		
		smokeEmitter.kill();
		seeking = false;
		super.kill();
	}
}