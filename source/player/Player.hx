package player;

import player.MissileBullet;
import player.MissileExplosion;
import flixel.*;
import flixel.effects.*;
import flixel.group.*;
import flixel.math.*;
import flixel.util.*;
import flixel.group.FlxGroup.FlxTypedGroup;
import player.*;
import levels.*;
import util.LevelManager.LevelStates;

/**
 * ...
 * @author 
 */

enum PlayerWeapon {
	BULLETWEAPON;
	MISSILEWEAPON;
	LASERWEAPON;
}
 
class Player extends FlxSprite 
{
	public static var BULLETWEAPONVELLOCITY:Int = GameSettings.BULLETWEAPONVELLOCITY ;
		
	private var state:FlxState;
	public var fireDelay:Float;
	public var fireTimer:Float;
	public var moveVelocity:Int;
	public var newPosition:FlxPoint;
	public var weaponUpgradeLevel:Int;
	public var amountOfBullets:Int;
	public var playerBullets:FlxTypedGroup<Bullet>;
	public var playerMissiles:FlxTypedGroup<player.MissileBullet>;
	public var missileExplosion:FlxGroup;
	public var bulletExplosion:FlxGroup;
	//public var playerBullets:FlxTypedGroup<Bullet>;
	public var bulletSpeed:Int;
	private var invulTime:Float = 1;
	private var isInvulnerable:Bool;
	public var hitPoints:Int;
	private var upDown:Bool;
	private var leftRight:Bool;
	public var lives:Int;
	public var shield:Int;
	public var currentWeapon:PlayerWeapon;
	public var targets:FlxGroup;
	
	
	
	
	public function new(Parent:FlxState) 
	{
		// X,Y: Starting coordinates
		super((FlxG.width / 2) - 32, FlxG.height - 65);
		
		hitPoints = GameSettings.PLAYERHITPOINTS ;
		isInvulnerable = false;
		moveVelocity = GameSettings.PLAYERVELOCITY;
		fireDelay = 0.25;
		fireTimer = 0;
		lives = GameSettings.PLAYERLIVES;
		shield = 0;
		state = Parent;  
		weaponUpgradeLevel = 0;
		currentWeapon = PlayerWeapon.BULLETWEAPON;
		loadGraphic(Reg.PLAYER, true, 64, 64);
		width = 44;
		height = 45;
		offset = new FlxPoint(10,12);
		animation.add("live", [0, 1, 2, 3], 30, true);
		animation.add("northwest", [4, 5], 30, true);
		animation.add("northeast", [6, 7], 30, true);
		animation.add("southwest", [8, 9], 30, true);
		animation.add("southeast", [10, 11], 30, true);
		animation.play("live");
		//makeGraphic(25, 30,FlxColor.BLUE);
		
		targets = new FlxGroup();
		
		missileExplosion= new FlxGroup(20);
		// Create missile explosions
		for (i in 0... 20)			
		{
			var explo = new player.MissileExplosion();
			explo.kill();
			missileExplosion.add(explo);			
		}
		
		bulletExplosion= new FlxGroup(20);
		// Create bullets explosions
		for (i in 0... 20)			
		{
			var explo = new player.PlayerBulletExplosion();
			explo.kill();
			bulletExplosion.add(explo);			
		}
		
		playerBullets = new FlxTypedGroup<Bullet>(75);
		
		for (i in 0... 75)			
		{
			var bullet = new Bullet();
			bullet.explosions = bulletExplosion;
			bullet .kill();
			playerBullets.add(bullet);			
		}
		
		
		playerMissiles = new FlxTypedGroup<player.MissileBullet>(50);
		
		for (i in 0... 50)			
		{
			var missile = new player.MissileBullet();
			missile.explosions = missileExplosion;
			missile .kill();
			playerMissiles.add(missile);			
		}
		
			
		
		Reg.playerBulletsGroup.add(playerMissiles);
		Reg.playerBulletsGroup.add(playerBullets);
		Reg.playerBulletsGroup.add(missileExplosion);
		Reg.playerBulletsGroup.add(bulletExplosion);
		
		
	}
	
	public override function update(elapsed:Float):Void
	{
		
		if (Reg.LEVELSTATE == LevelStates.Playing || Reg.LEVELSTATE == LevelStates.Boss)
		{
			//Hide show Cursor based on distance to the ship
			if (FlxMath.distanceToMouse(this) > 100)
			{
				FlxG.mouse.visible = true;
			} else 
			{
				FlxG.mouse.visible = false;
			}
			
			
			if (FlxMath.distanceToMouse(this) < 3)
			{
				velocity.set(0,0);
			} else
			{
				FlxVelocity.moveTowardsPoint( this, FlxG.mouse.getPosition(), moveVelocity);
				//FlxVelocity.moveTowardsMouse(this , moveVelocity);
				
			}
				
			if (velocity.y > 0 && velocity.x > 0)
			{
				animation.play("southeast");
			} else if (velocity.y < 0 && velocity.x > 0)
			{
				animation.play("northeast");
			} else if (velocity.y > 0 && velocity.x < 0)
			{
				animation.play("southwest");
			} else if (velocity.y < 0 && velocity.x < 0)
			{
				animation.play("northwest");
			}
			else {
				animation.play("live");
			}
			
			//autofire
			shoot();  
				
			
					
			// Edge of the map controll
			if (x <= 0)
			{
				x = 0;
			}
			else if ((x + width) > FlxG.width)
			{ 
				x = FlxG.width - width;
			}
			
			if (y <= 0)
			{
				y = 0;
			}
			else if ((y + height) > FlxG.height)
			{
				y = FlxG.height - height;
			}
			
			
			fireTimer += FlxG.elapsed;
		}
		
		if ( Reg.LEVELSTATE == LevelStates.AfterEnd)
		{
			
			if (FlxMath.distanceToPoint(this, new FlxPoint(FlxG.width /2 , FlxG.height -50 )) < 5)
			{
				velocity.set(0,0);
			} else
			{
				FlxVelocity.moveTowardsPoint(this, new FlxPoint( FlxG.width / 2, FlxG.height -50 ), moveVelocity);
				
			}
		}
		super.update(elapsed);
	}
	
	
	public function increseWeaponUpgradeLevel() 
	{
		if (weaponUpgradeLevel < 4)
		{
			weaponUpgradeLevel++;
		}
	}
	
	public function decreaseWeaponUpgradeLevel() 
	{
		if (weaponUpgradeLevel > 0)
		{
			weaponUpgradeLevel--;
		}
	}
	
	private function shoot():Void 
	{
		if (fireTimer >= fireDelay)
		{
			switch currentWeapon {
				case BULLETWEAPON:
					bulletWeaponFire();
				case MISSILEWEAPON:
					missileWeaponFire();
				case LASERWEAPON:
					laserWeaponFire();
				
			}
			
			
			fireTimer = 0;
		}
	}
	
	override public function kill():Void
	{
		if (!alive) 
		{
			return;
		}
		
		super.kill();
		
		FlxG.cameras.shake(0.005, 0.35);
		FlxG.cameras.flash(0xffDB3624, 0.35);
	}
	
	public function tookDamage(damage:Int):Void
	{
		
		if (isInvulnerable == false)
		{
			isInvulnerable = true;
			FlxG.cameras.shake(0.005, 0.35);
			
			if (shield > 0)
			{
				shield -= damage;
				FlxSpriteUtil.flicker(this, invulTime, 0.1,true,true,endInvulnerability);
			}
			else 
			{
				hitPoints -= damage;
				if (hitPoints <= 0)
					if (lives == 0)
					{
						FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
							FlxG.resetState();
						});
					} else
					{
						lives--;
						//play destruction animation
						exists = false;
						new FlxTimer().start(3 , playerRespawn, 1);
						
					}
				else
				{
					FlxSpriteUtil.flicker(this, invulTime, 0.1,true,true,endInvulnerability);
				}
			}
		}
	
	}
	
	public function endInvulnerability(fl:FlxFlicker):Void
	{
		isInvulnerable = false;
	}
	
	public function bulletWeaponFire():Void
	{
		switch(weaponUpgradeLevel){
			case 0:
					var bullet:Bullet = playerBullets.recycle(Bullet);
					bullet.shootBullet(getMidpoint().x - bullet.width / 2, getMidpoint().y -5);
					bullet.velocity.y = BULLETWEAPONVELLOCITY;
					bullet.animation.play("live");
					FlxG.sound.play(Reg.SOUNDBULLET, 0.5);
					fireDelay = GameSettings.BULLETFIREDELAY;
			case 1:
					var bullet:Bullet = playerBullets.recycle(Bullet);
					var bullet2:Bullet = playerBullets.recycle(Bullet);
					bullet.shootBullet(getMidpoint().x - (bullet.width +3) , getMidpoint().y -5);
					bullet2.shootBullet(getMidpoint().x + 3 , getMidpoint().y -5);
					bullet.velocity.y = BULLETWEAPONVELLOCITY;
					bullet2.velocity.y = BULLETWEAPONVELLOCITY;
					bullet.animation.play("live");
					bullet2.animation.play("live");
					FlxG.sound.play(Reg.SOUNDBULLET, 0.5);
					fireDelay = GameSettings.BULLETFIREDELAY;
			case 2:
					var bullet:Bullet = playerBullets.recycle(Bullet);
					var bullet2:Bullet = playerBullets.recycle(Bullet);
					var bullet3:Bullet = playerBullets.recycle(Bullet);
					bullet.shootBullet(getMidpoint().x - (bullet.width / 2) , getMidpoint().y - 10);
					bullet2.shootBullet(getMidpoint().x - (bullet.width +8) , getMidpoint().y );
					bullet3.shootBullet(getMidpoint().x + 8, getMidpoint().y );
					bullet.velocity.y = BULLETWEAPONVELLOCITY;
					bullet2.velocity.y = BULLETWEAPONVELLOCITY;
					bullet3.velocity.y = BULLETWEAPONVELLOCITY;
					bullet.animation.play("live");
					bullet2.animation.play("live");
					bullet3.animation.play("live");
					FlxG.sound.play(Reg.SOUNDBULLET, 0.5);
					fireDelay = GameSettings.BULLETFIREDELAY;
			case 3:
					var bullet:Bullet = playerBullets.recycle(Bullet);
					var bullet2:Bullet = playerBullets.recycle(Bullet);
					var bullet3:Bullet = playerBullets.recycle(Bullet);
					var bullet4:Bullet = playerBullets.recycle(Bullet);
					var bullet5:Bullet = playerBullets.recycle(Bullet);
					bullet.shootBullet(getMidpoint().x - (bullet.width / 2) , getMidpoint().y - 10);
					bullet2.shootBullet(getMidpoint().x - (bullet.width +8) , getMidpoint().y );
					bullet3.shootBullet(getMidpoint().x + 8, getMidpoint().y );
					bullet4.shootBullet(getMidpoint().x - (bullet.width +12), getMidpoint().y);
					bullet5.shootBullet(getMidpoint().x + 12, getMidpoint().y);
					bullet.velocity.y = BULLETWEAPONVELLOCITY;
					bullet2.velocity.y = BULLETWEAPONVELLOCITY;
					bullet3.velocity.y = BULLETWEAPONVELLOCITY;
					bullet4.velocity.y = BULLETWEAPONVELLOCITY;
					bullet5.velocity.y = BULLETWEAPONVELLOCITY;
					
					bullet4.angle = -30;
					var pivot4 = FlxPoint.weak(0, 0);
					bullet4.velocity.rotate(pivot4, bullet4.angle);// 4.0.0
					
										
					bullet5.angle = 30;
					var pivot5 = FlxPoint.weak(0, 0);
					bullet5.velocity.rotate(pivot5, bullet5.angle);// 4.0.0
					
					bullet.animation.play("live");
					bullet2.animation.play("live");
					bullet3.animation.play("live");
					bullet4.animation.play("live");
					bullet5.animation.play("live");
					FlxG.sound.play(Reg.SOUNDBULLET, 0.5);
					fireDelay = GameSettings.BULLETFIREDELAY;
			case 4:
					var bullet:Bullet = playerBullets.recycle(Bullet);
					var bullet2:Bullet = playerBullets.recycle(Bullet);
					var bullet3:Bullet = playerBullets.recycle(Bullet);
					var bullet4:Bullet = playerBullets.recycle(Bullet);
					var bullet5:Bullet = playerBullets.recycle(Bullet);
					var bullet6:Bullet = playerBullets.recycle(Bullet);
					var bullet7:Bullet = playerBullets.recycle(Bullet);
					bullet.shootBullet(getMidpoint().x - (bullet.width / 2) , getMidpoint().y - 10);
					bullet2.shootBullet(getMidpoint().x - (bullet.width +8) , getMidpoint().y );
					bullet3.shootBullet(getMidpoint().x + 8, getMidpoint().y);
					bullet4.shootBullet(getMidpoint().x - (bullet.width +12), getMidpoint().y );
					bullet5.shootBullet(getMidpoint().x + 12, getMidpoint().y );
					bullet6.shootBullet(getMidpoint().x - (bullet.width +12), getMidpoint().y + 5);
					bullet7.shootBullet(getMidpoint().x + 12, getMidpoint().y + 5);
					bullet.velocity.y = BULLETWEAPONVELLOCITY;
					bullet2.velocity.y = BULLETWEAPONVELLOCITY;
					bullet3.velocity.y = BULLETWEAPONVELLOCITY;
					bullet4.velocity.y = BULLETWEAPONVELLOCITY;
					bullet5.velocity.y = BULLETWEAPONVELLOCITY;
					
					bullet4.angle = -30;
					var pivot4 = FlxPoint.weak(0, 0);
					bullet4.velocity.rotate(pivot4, bullet4.angle);// 4.0.0
					
					
					bullet5.angle = 30;
					var pivot5 = FlxPoint.weak(0, 0);
					bullet5.velocity.rotate(pivot5, bullet5.angle);// 4.0.0
					
					bullet6.angle = -90;
					bullet7.angle = 90;
					bullet6.velocity.x = BULLETWEAPONVELLOCITY;
					bullet7.velocity.x = -BULLETWEAPONVELLOCITY;
					bullet.animation.play("live");
					bullet2.animation.play("live");
					bullet3.animation.play("live");
					bullet4.animation.play("live");
					bullet5.animation.play("live");
					bullet6.animation.play("live");
					bullet7.animation.play("live");
					FlxG.sound.play(Reg.SOUNDBULLET, 0.5);
					fireDelay = GameSettings.BULLETFIREDELAY;
		}
		
	}
	
	public function missileWeaponFire():Void
	{
		switch(weaponUpgradeLevel){
			case 0:
					var missile:player.MissileBullet= playerMissiles.recycle(player.MissileBullet);
					missile.shootBullet(getMidpoint().x - missile.width / 2, getMidpoint().y -10 );
					missile.seeker = false;
					missile.animation.play("regular");
					//missile.targets = targets;
					fireDelay = GameSettings.MISSILEFIREDELAY; 
			case 1:
					var missile:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					missile.shootBullet(getMidpoint().x - ( missile.width + 4), getMidpoint().y -10 );
					missile.seeker = false;
					missile.animation.play("regular");
					missile.velocity.x = - 20;
					missile.drag.x = 15;
					
					var missile2:player.MissileBullet= playerMissiles.recycle(player.MissileBullet);
					missile2.shootBullet(getMidpoint().x + 4, getMidpoint().y -10 );
					missile2.seeker = false;
					missile2.animation.play("regular");
					missile2.velocity.x = 20;
					missile2.drag.x = 15;
					
					fireDelay = GameSettings.MISSILEFIREDELAY; 
			case 2:
					var missile:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					var missile2:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					var missile3:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					
					missile.shootBullet(getMidpoint().x - missile.width / 2, getMidpoint().y -10 );
					missile.seeker = true;
					missile.animation.play("seeker");
					missile3.velocity.set(0, -300);
					missile.targets = targets;
					
					missile2.shootBullet(getMidpoint().x - (missile2.width +12), getMidpoint().y - 10);
					missile2.angle = -25;
					missile2.animation.play("regular");
					missile2.seeker = false;
					missile2.velocity.set(0, -300);
					var pivot2 = FlxPoint.weak(0, 0);
					missile2.velocity.rotate(pivot2, missile2.angle);// 4.0.0
					FlxG.log.notice( missile2.velocity);
					
					
					missile3.shootBullet(getMidpoint().x + 12, getMidpoint().y - 10);
					missile3.angle = 25;
					missile3.animation.play("regular");
					missile3.seeker = false;
					missile3.velocity.set(0, -300);
					var pivot3 = FlxPoint.weak(0, 0);
					missile3.velocity.rotate(pivot3, missile3.angle);// 4.0.0
					
					fireDelay = GameSettings.MISSILEFIREDELAY; 
			case 3:
					
					var missile:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					var missile2:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					var missile3:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					var missile4:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					
					missile.shootBullet(getMidpoint().x - ( missile.width + 4), getMidpoint().y -10 );
					missile.seeker = false;
					missile.animation.play("regular");
					missile.targets = targets;
					missile.velocity.x = - 20;
					missile.drag.x = 15;
					
					missile2.shootBullet(getMidpoint().x + 4, getMidpoint().y -10 );
					missile2.seeker = false;
					missile2.animation.play("regular");
					missile2.targets = targets;
					missile2.velocity.x = 20;
					missile2.drag.x = 15;
										
					missile3.shootBullet(getMidpoint().x - (missile3.width +12), getMidpoint().y - 10);
					missile3.angle = -25;
					missile3.seeker = true;
					missile3.animation.play("seeker");
					missile3.targets = targets;
					missile3.velocity.set(0, -300);
					var pivot3 = FlxPoint.weak(0, 0);
					missile3.velocity.rotate(pivot3, missile3.angle);// 4.0.0
					
					missile4.shootBullet(getMidpoint().x + 12, getMidpoint().y - 10);
					missile4.angle = 25;
					missile4.seeker = true;
					missile4.animation.play("seeker");
					missile4.targets = targets;
					missile4.velocity.set(0, -300);
					var pivot4 = FlxPoint.weak(0, 0);
					missile4.velocity.rotate(pivot4, missile4.angle);// 4.0.0
					
					fireDelay = GameSettings.MISSILEFIREDELAY; 
					
				case 4:
					var missile:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					var missile2:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					var missile3:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					var missile4:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					var missile5:player.MissileBullet = playerMissiles.recycle(player.MissileBullet);
					
					missile.shootBullet(getMidpoint().x - ( missile.width + 4), getMidpoint().y -10 );
					missile.seeker = false;
					missile.animation.play("regular");
					missile.targets = targets;
					missile.velocity.x = - 25;
					missile.drag.x = 15;
					
					missile2.shootBullet(getMidpoint().x + 4, getMidpoint().y -10 );
					missile2.seeker = false;
					missile2.animation.play("regular");
					missile2.targets = targets;
					missile2.velocity.x = 25;
					missile2.drag.x = 15;
					
					missile3.shootBullet(getMidpoint().x - (missile3.width +12), getMidpoint().y - 10);
					missile3.angle = -25;
					missile3.seeker = true;
					missile3.animation.play("seeker");
					missile3.targets = targets;
					missile3.velocity.set(0, -300);
					var pivot3 = FlxPoint.weak(0, 0);
					missile3.velocity.rotate(pivot3, missile3.angle);// 4.0.0
					
					missile4.shootBullet(getMidpoint().x + 12, getMidpoint().y - 10);
					missile4.angle = 25;
					missile4.seeker = true;
					missile4.animation.play("seeker");
					missile4.targets = targets;
					missile4.velocity.set(0, -300);
					var pivot4 = FlxPoint.weak(0, 0);
					missile4.velocity.rotate(pivot4, missile4.angle);// 4.0.0
					
					//Maybe replace by a mine
					missile5.shootBullet(getMidpoint().x - ( missile.width /2 ), getMidpoint().y -10 );
					missile5.seeker = true;
					missile5.animation.play("seeker");
					missile5.targets = targets;
						
					fireDelay = GameSettings.MISSILEFIREDELAY; 
					
		}
		
	}
	
	public function laserWeaponFire():Void
	{
		switch(weaponUpgradeLevel){
			case 0:
					
					//trace("laser 0");
			case 1:
					
					//trace("laser 1");
			case 2:
					
					//trace("laser 2");
			case 3:
					
					//trace("laser max");
		}
		
	}
	
	public function playerRespawn(Timer:FlxTimer):Void
	{
		weaponUpgradeLevel = 0;
		hitPoints = GameSettings.PLAYERHITPOINTS;
		FlxSpriteUtil.flicker(this, invulTime, 0.1,true,true,endInvulnerability);
		//Reg.playerHealthChanged.dispatch(hitPoints);
		reset(FlxG.width /2 , FlxG.height + 25);
		
	}
	
	
}