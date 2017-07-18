package util;
import enemies.BaseEnemy;
import enemies.PopcornEnemy.Formation;
import levels.BaseState;
import levels.MenuState;
import misc.BasePowerUp;
import player.Player;
import util.BackgroundController.BackgroundSpeed;

import enemies.BossEnemy;

import player.MissileBullet;
import enemies.MultiSpriteEnemy;

import misc.ShieldPowerUp;
import enemies.ShooterEnemy;
import misc.WeaponLevelPowerUp;
import enemies.*;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxNestedSprite;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.text.FlxTypeText;
import flixel.addons.ui.FlxUI;
import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import util.EnemyWaves;

/**
 * ...
 * @author 
 */

 enum LevelStates {
	BeforeStart;
	Playing;
	Paused;
	Boss;
	AfterEnd;	 
 }
 
 
 
class LevelManager extends FlxBasic
{
	var levelState(null , set):LevelStates;
	
	var enemySpawnDelay:Float;
	var state:FlxState;
	var enemyBullets:FlxTypedGroup<EnemyBaseBullet>;
	var shooterEnemies:FlxTypedGroup<enemies.ShooterEnemy>;
	var popcornEnemies:FlxTypedGroup<enemies.PopcornEnemy>;
	var chaserEnemies:FlxTypedGroup<enemies.ChaserEnemy>;
	var hardShooterEnemies:FlxTypedGroup<enemies.HardShooterEnemy>;
	var basicEnemies:FlxTypedGroup<enemies.BaseEnemy>;
	var multiSpriteEnemies:FlxTypedGroup<enemies.MultiSpriteEnemy>;
	var playerBullets:FlxTypedGroup<player.Bullet>;
	var playerMissiles:FlxTypedGroup<player.MissileBullet>;
	var trailArea:FlxTrailArea;
	var UI:FlxUI;
	
	//var playerLasers:FlxTypedGroup<LaserBullet>;
	var upgrades:FlxTypedGroup<misc.BasePowerUp>;
	var player:player.Player;
	var levelTmer:Float;
	
	//Enemies 
	var chaserEnabled:Bool;
	var hardShooterEnabled:Bool;
	var boss:enemies.BossEnemy;
	var enemyWaves:FlxTypedGroup<EnemyWaves>;
	var maxNumberOfEnemies:Int;
	var numberOfEnemies:Int;
	var enemiesExplosion:FlxTypedGroup<EnemyExplosion>;
	var bulletExplosion:FlxGroup;
	
	//WeaponIcons
	var bulletWeaponIcon:FlxSprite;
	var missileWeaponIcon:FlxSprite;
	var laserWeaponIcon:FlxSprite;
	
	//LivesIcons
	var livesIcon:FlxSprite;
	
	//Weapon Power Text-Icon
	var weaponPowerIcon:FlxText;
	var livesCounterIcon:FlxText;
	
	//Dialogs
	var dialogWindow:FlxSprite;
	var text:FlxTypeText;
	var curretDialogFinished:Bool;
	var currentMultiDialog:Array<String>;
	var dialogCounter:Int;
	var dialogToShow:Int;
	var preDialogs:Array<String>;
	var postDialogs:Array<String>;
	var midScreenText:FlxText;
	var isStart:Bool;
	var isEnd:Bool;
	
	
	public function new(playState:FlxState , player:player.Player, enWaves:FlxTypedGroup<EnemyWaves> ,  preDialog:Array<String> , postDialog:Array<String> ) 
	{
		super();
		
		// The first thing to do is setting up the FlxTrailArea
		var trailArea = new FlxTrailArea(0, 0, FlxG.width , FlxG.height);
		
		
		set_levelState( LevelStates.BeforeStart);
		preDialogs = preDialog;
		postDialogs = postDialog;
		
		state = playState;
		numberOfEnemies = 0;
		maxNumberOfEnemies = 6;
		enemySpawnDelay = 0;
		levelTmer = 0;
		this.player = player;
		this.playerBullets = player.playerBullets;
		this.playerMissiles = player.playerMissiles;
		
		//this.playerLasers = player.playerLasers;
		
		enemyBullets = new FlxTypedGroup(100);
		shooterEnemies = new FlxTypedGroup(15);
		popcornEnemies = new FlxTypedGroup(30);
		chaserEnemies = new FlxTypedGroup(10);
		hardShooterEnemies = new FlxTypedGroup(5);
		this.enemyWaves = enWaves;
		chaserEnabled = false;
		hardShooterEnabled = false;
	
		basicEnemies = new FlxTypedGroup();
		multiSpriteEnemies = new FlxTypedGroup();
		enemiesExplosion = new FlxTypedGroup(15);
		
		
		upgrades = new FlxTypedGroup();
				
		Reg.deadEnemies.add(enemyDied);
		
		
		
		
		
		// Create enemy explosions
		for (i in 0... 15)			
		{
			var explo = new EnemyExplosion();
			explo.kill();
			enemiesExplosion.add(explo);			
		}
		
		// Create shooter enemies for recycle
		for (i in 0... 15)			
		{
			var enemy = new enemies.ShooterEnemy(enemyBullets, player);
			enemy.immovable = true;
			enemy.exists = false;
			enemy.explosions = enemiesExplosion;
			shooterEnemies.add(enemy);
			basicEnemies.add(enemy);
			this.player.targets.add(enemy);
		}
		
		// Create shooter enemies for recycle
		for (i in 0... 30)			
		{
			var enemy = new enemies.PopcornEnemy(enemyBullets, player , Formation.Double);
			enemy.immovable = true;
			enemy.exists = false;
			enemy.explosions = enemiesExplosion;
			popcornEnemies.add(enemy);
			basicEnemies.add(enemy);
			this.player.targets.add(enemy);
		}
		
		// Create Chaser enemies for recycle
		for (i in 0... 10)			
		{
			var enemy = new ChaserEnemy(player);
			enemy.immovable = true;
			enemy.exists = false;
			enemy.explosions = enemiesExplosion;
			chaserEnemies.add(enemy);
			basicEnemies.add(enemy);
			this.player.targets.add(enemy);
		}
		
		
		// Create hard shooters enemies for recycle
		for (i in 0... 5)			
		{
			var enemy = new HardShooterEnemy(enemyBullets, player);
			enemy.immovable = true;
			enemy.exists = false;
			enemy.explosions = enemiesExplosion;
			hardShooterEnemies.add(enemy);
			basicEnemies.add(enemy);
			this.player.targets.add(enemy);
		}
		
		bulletExplosion= new FlxGroup(20);
		// Create bullets explosions
		for (i in 0... 20)			
		{
			var explo = new EnemyBulletExplosion();
			explo.kill();
			bulletExplosion.add(explo);			
		}
		
		// Create bullets for the enemies recycle
		for (i in 0... 100)			
		{
			var enemyBullet = new EnemyBaseBullet();
			enemyBullet.explosions = bulletExplosion;
			enemyBullet.kill();
			enemyBullets.add(enemyBullet);	
			trailArea.add(enemyBullet);
		}
		
		
		// Level boss
		boss = new enemies.BossEnemy(enemyBullets, player);
		boss.immovable = true;
		boss.exists = false;
		multiSpriteEnemies.add(boss);
		Reg.enemiesGroup.add(boss);
		this.player.targets.add((boss));

		//add bullets to trail area
		
		UI = cast (state, levels.BaseState ).getUI();
		dialogWindow = cast(UI.getAsset("dialogwindow"), FlxSprite);
		bulletWeaponIcon = cast UI.getAsset("weapon_bullet_icon");
		missileWeaponIcon = cast(UI.getAsset("weapon_missile_icon"), FlxSprite);
		missileWeaponIcon.kill();
		laserWeaponIcon = cast(UI.getAsset("weapon_laser_icon"), FlxSprite);
		laserWeaponIcon.kill();
		livesIcon = cast(UI.getAsset("lives_icon"), FlxSprite);
		
		livesCounterIcon = UI.getFlxText("lives");
		livesCounterIcon.text = 'x' + Std.string(player.lives);
		
		weaponPowerIcon = UI.getFlxText("weaponpower");
		weaponPowerIcon.text = 'x' + Std.string(player.weaponUpgradeLevel + 1);
				
		Reg.GUIGroup.add(dialogWindow);
		dialogWindow.kill();
		FlxMouseEventManager.add(dialogWindow, dialogWindowClick); 
		curretDialogFinished = false;
		
		Reg.enemiesGroup.add(trailArea);
		Reg.enemiesGroup.add(bulletExplosion);
		Reg.enemiesGroup.add(enemyBullets);
		Reg.enemiesGroup.add(shooterEnemies);
		Reg.enemiesGroup.add(popcornEnemies);
		Reg.enemiesGroup.add(chaserEnemies);
		Reg.enemiesGroup.add(hardShooterEnemies);
		Reg.enemiesGroup.add(enemiesExplosion);
		
		
		//Create text for dialogs and its configurations
		text = new FlxTypeText(dialogWindow.x + 10 , dialogWindow.y +10 , Std.int(dialogWindow.width) -20, "", 16, true);
		text.delay = 0.1;
		text.eraseDelay = 0.2;
		text.showCursor = true;
		text.cursorBlinkSpeed = 1.0;
		//text.setTypingVariation(0.75, true);
		text.useDefaultSound = true;
		text.color = 0x8811EE11;
		text.skipKeys = ["SPACE"];
		text.kill();
		Reg.GUIGroup.add(text);
				
		
				
		dialogCounter = 0;
		isStart = true;
		isEnd = false;
		
	}
		
	
	
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		switch levelState {
			
			case BeforeStart:
				if (dialogCounter == 0)
				{
					currentMultiDialog = preDialogs;
					dialogCounter = preDialogs.length;
					dialogToShow = 0;
					showMultiDialogWindow();
				}
				set_levelState(LevelStates.Paused);
			case Playing:
				
				new FlxTimer().start(1, checkWaves, 0);
				
				if (enemySpawnDelay <= 0 && numberOfEnemies < maxNumberOfEnemies )
				{
					//spawnRandomEnemies();
					
				}
				enemySpawnDelay -= FlxG.elapsed;
				levelTmer  += FlxG.elapsed;
				
				if (levelTmer >= 15 && chaserEnabled == false)
				{
					chaserEnabled = true;
				}
				
				if (levelTmer >= 120)
				{
					maxNumberOfEnemies = 8;
				} else if (levelTmer >= 240)
				{
					maxNumberOfEnemies = 10;
				}
				
				
					
				if (levelTmer >= 300) //300
				{
					set_levelState(LevelStates.Boss);
					
				}
			case Paused:
				
			case Boss:
				if ( !boss.exists && !boss.defeated)
				{
					cast(state , BaseState).backgroundController.backgroundSpeed( BackgroundSpeed.Stopped);
					boss.reset( 250 , - 300);
					boss.state = enemies.BaseEnemy.EnemyState.EnteringScreen;
					
				}else if ( boss.defeated )
				{
					cast(state , BaseState).backgroundController.backgroundSpeed( BackgroundSpeed.Normal);
					set_levelState(LevelStates.AfterEnd);
				}
				
			case AfterEnd:
				if (dialogCounter == 0)
				{
					cast(state , BaseState).backgroundController.backgroundSpeed( BackgroundSpeed.Double);
					currentMultiDialog = postDialogs;
					dialogCounter = postDialogs.length;
					dialogToShow = 0;
					showMultiDialogWindow();
					isEnd = true;
				}
			
		}
		
		
		if (FlxG.keys.anyJustPressed(["I"]))
		{
			FlxG.timeScale = 0.5;
		}
		if (FlxG.keys.anyJustPressed(["O"]))
		{
			FlxG.timeScale = 1.0;
		}
		if (FlxG.keys.anyJustPressed(["P"]))
		{
			FlxG.timeScale = 2.0;
		}
		
		if (FlxG.keys.anyJustPressed(["Q"]))
		{
			var upgrade = new misc.ShieldPowerUp( misc.BasePowerUp.PowerUpType.Shield);
			Reg.playerGroup.add(upgrade);
			upgrade.setPosition(FlxG.mouse.x, FlxG.mouse.y);
			upgrade.velocity.y = 50;
			upgrades.add(upgrade);
		}
		if (FlxG.keys.anyJustPressed(["R"]))
		{
			var upgrade = new misc.WeaponLevelPowerUp(misc.BasePowerUp.PowerUpType.WeaponLevelUpgrade);
			Reg.playerGroup.add(upgrade);
			upgrade.setPosition(FlxG.mouse.x, FlxG.mouse.y);
			upgrade.velocity.y = 50;
			upgrades.add(upgrade);
		} 
		
		if (FlxG.keys.anyJustPressed(["ONE"]))
		{
			
			var upgrade = new misc.WeaponLevelPowerUp(misc.BasePowerUp.PowerUpType.BulletWeapon);
			Reg.playerGroup.add(upgrade);
			upgrade.setPosition(FlxG.mouse.x, FlxG.mouse.y);
			upgrade.velocity.y = 50;
			upgrades.add(upgrade);
		} 
		
		if (FlxG.keys.anyJustPressed(["TWO"]))
		{
			
			var upgrade = new misc.WeaponLevelPowerUp(misc.BasePowerUp.PowerUpType.MissileWeapon);
			Reg.playerGroup.add(upgrade);
			upgrade.setPosition(FlxG.mouse.x, FlxG.mouse.y);
			upgrade.velocity.y = 50;
			upgrades.add(upgrade);
		} 
		
		if (FlxG.keys.anyJustPressed(["THREE"]))
		{
			
			var upgrade = new misc.WeaponLevelPowerUp(misc.BasePowerUp.PowerUpType.LaserWeapon);
			Reg.playerGroup.add(upgrade);
			upgrade.setPosition(FlxG.mouse.x, FlxG.mouse.y);
			upgrade.velocity.y = 50;
			upgrades.add(upgrade);
		} 
		
			
		if (FlxG.keys.anyJustPressed(["X"]))
		{
			
			boss.body.solid = true;
		}
		
		//Test collisions
		if (levelState == LevelStates.Playing || levelState == LevelStates.Boss)
		{
			FlxG.overlap(player , enemyBullets , playerHit);
			FlxG.overlap(player , basicEnemies, shipCollision);
			FlxG.overlap(playerBullets , basicEnemies, enemyHit);
			FlxG.overlap(playerMissiles , basicEnemies, enemyHit);
			FlxG.overlap(player , Reg.playerGroup, powerUpCollected);
			//FlxG.overlap(playerBullets , boss, multiEnemyHit);
			FlxG.overlap(playerMissiles , boss.body, multiEnemyHit);
			FlxG.overlap(playerMissiles , boss.leftCannon, multiEnemyHit);
			FlxG.overlap(playerMissiles , boss.middleCannon, multiEnemyHit);
			FlxG.overlap(playerMissiles , boss.rightCannon, multiEnemyHit);
			FlxG.overlap(playerBullets , boss.body, multiEnemyHit);
			FlxG.overlap(playerBullets , boss.leftCannon, multiEnemyHit);
			FlxG.overlap(playerBullets, boss.middleCannon, multiEnemyHit);
			FlxG.overlap(playerBullets, boss.rightCannon, multiEnemyHit);
			
		}
	}
	
	
	public function spawnRandomEnemies()
	{
		if (FlxG.random.bool(50) || chaserEnabled == false )
		{
			var enemy:enemies.ShooterEnemy = shooterEnemies.recycle();
			enemy.reset(FlxG.random.int(20, FlxG.width - 20), -34);
			enemy.state = enemies.BaseEnemy.EnemyState.EnteringScreen;
			enemy.velocity.y = 125;
			numberOfEnemies ++;
			enemySpawnDelay = (2 / 5) * numberOfEnemies;
		}
		else 
		{
			var enemy:ChaserEnemy= chaserEnemies.recycle();
			enemy.reset(FlxG.random.int(20, FlxG.width - 20), -34);
			enemy.state = enemies.BaseEnemy.EnemyState.EnteringScreen;
			enemy.velocity.y = 125;
			numberOfEnemies ++;
			enemySpawnDelay = (2 / 5) * numberOfEnemies;
			
		}
		
	}
	
	public function spawnPopcornEnemy(enter:enemies.BaseEnemy.EnemyPositions, exit:enemies.BaseEnemy.EnemyPositions)
	{
		var enemy:PopcornEnemy = popcornEnemies.recycle();
		enemy.set_EnterExit(enter, exit);
		
		numberOfEnemies ++;
	}
	
	public function spawnShooterEnemy(enter:enemies.BaseEnemy.EnemyPositions, exit:enemies.BaseEnemy.EnemyPositions)
	{
		var enemy:enemies.ShooterEnemy = shooterEnemies.recycle();
		enemy.set_EnterExit(enter, exit);
		
		numberOfEnemies ++;
	}
	
	public function spawnChaserEnemy(enter:enemies.BaseEnemy.EnemyPositions, exit:enemies.BaseEnemy.EnemyPositions) 
	{
		var enemy:ChaserEnemy= chaserEnemies.recycle();
		enemy.set_EnterExit(enter, exit);
		
		numberOfEnemies ++;
	}
	
	public function spawnHardShooterEnemy(enter:enemies.BaseEnemy.EnemyPositions, exit:enemies.BaseEnemy.EnemyPositions , drp:misc.BasePowerUp.PowerUpType)
	{
		var enemy:HardShooterEnemy= hardShooterEnemies.recycle();
		enemy.set_EnterExit(enter, exit);
		enemy.drop = drp;
		enemy.state = enemies.BaseEnemy.EnemyState.EnteringScreen;
		numberOfEnemies ++;
	}
	
	
	public function enemyDied()
	{
		numberOfEnemies --;
	}

	public function playerHit(player:FlxObject, bullet:FlxObject):Void
	{
		cast(player, player.Player).tookDamage(cast(bullet, EnemyBaseBullet).damage);
		livesCounterIcon.text = 'x' + Std.string(cast(player, player.Player).lives);
		cast(bullet, EnemyBaseBullet).kill();
	}
	
	public function enemyHit(bullet :FlxObject, enemy:FlxObject):Void
	{
		cast(enemy, enemies.BaseEnemy).tookDamage(cast(bullet, player.Bullet).damage);
		
		cast(bullet, player.Bullet).kill();
	}
	
	
	public function multiEnemyHit(bullet :FlxObject, enemy:FlxObject):Void
	{
		
		cast(enemy, FlxNestedSprite).health -=(cast(bullet, player.Bullet).damage);
		
		
		cast(bullet, player.Bullet).kill();
	}
	
	public function shipCollision(player:FlxObject, enemy:FlxObject):Void
	{
		
		cast(player, player.Player).tookDamage(1);
		
		//cast(enemy, BaseEnemy).tookDamage(1);
	}
	
	public function powerUpCollected(player :FlxObject, powerUp:FlxObject):Void
	{
		switch(cast(powerUp, misc.BasePowerUp).powerUpType) {
			case BulletWeapon:
				if (cast(player, Player).currentWeapon != PlayerWeapon.BULLETWEAPON)
				{
					cast(player, Player).currentWeapon = PlayerWeapon.BULLETWEAPON;
					this.setWeaponIcon(PlayerWeapon.BULLETWEAPON);
					cast(player, Player).decreaseWeaponUpgradeLevel();
					Reg.updateScore  .dispatch(250);
					weaponPowerIcon.text = 'x' + Std.string(cast(player, Player).weaponUpgradeLevel + 1);
				} else
				{
					Reg.updateScore  .dispatch(250);	
				}
				cast(powerUp, misc.BasePowerUp).kill();
			case MissileWeapon:
				if (cast(player, player.Player).currentWeapon != PlayerWeapon.MISSILEWEAPON)
				{
					cast(player, player.Player).currentWeapon = PlayerWeapon.MISSILEWEAPON;
					this.setWeaponIcon(PlayerWeapon.MISSILEWEAPON);
					cast(player, player.Player).decreaseWeaponUpgradeLevel();
					Reg.updateScore  .dispatch(250);
					weaponPowerIcon.text = 'x' + Std.string(cast(player, player.Player).weaponUpgradeLevel + 1);
				} else
				{
					Reg.updateScore  .dispatch(250);
				}
				cast(powerUp, misc.BasePowerUp).kill();
			case LaserWeapon:
				if (cast(player, player.Player).currentWeapon != PlayerWeapon.LASERWEAPON)
				{
					cast(player, player.Player).currentWeapon = PlayerWeapon.LASERWEAPON;
					this.setWeaponIcon(PlayerWeapon.LASERWEAPON);
					cast(player, player.Player).decreaseWeaponUpgradeLevel();
					Reg.updateScore  .dispatch(250);
					weaponPowerIcon.text = 'x' + Std.string(cast(player, player.Player).weaponUpgradeLevel + 1);
				} else {
					Reg.updateScore  .dispatch(250);
				}
				cast(powerUp, misc.BasePowerUp).kill();
			case WeaponLevelUpgrade:
				cast(player, player.Player).increseWeaponUpgradeLevel();
				Reg.updateScore  .dispatch(250);
				cast(powerUp, misc.BasePowerUp).kill();
				weaponPowerIcon.text = 'x' + Std.string(cast(player, player.Player).weaponUpgradeLevel + 1);
			case Money:
				Reg.updateScore  .dispatch(1000);
				cast(powerUp, misc.BasePowerUp).kill();
			case Live:
				if (cast(player, player.Player).lives < 3)
				{
					cast(player, player.Player).lives ++;
					Reg.updateScore  .dispatch(250);
				} else
				{
					Reg.updateScore  .dispatch(1000);
				}
				cast(powerUp, misc.BasePowerUp).kill();
			case Shield:
				cast(player, player.Player).shield += 2;
				Reg.updateScore  .dispatch(250);
				cast(powerUp, misc.BasePowerUp).kill();
		}	
	}
	
	
	private function showStartText()
	{
		midScreenText =  new FlxText( -200, FlxG.height / 2 - 20, FlxG.width, "START", 20);
		midScreenText .alignment = "center";
		midScreenText .borderStyle = FlxTextBorderStyle.SHADOW;
		//midScreenText.blend = BlendMode.INVERT;
		Reg.GUIGroup.add(midScreenText);
			
		//Chain tweens, change to state = playing after done
		FlxTween.tween(midScreenText, { x: 0 } , 1.5, { ease: FlxEase.expoOut, onComplete: hideText  } );
	}
	
	
	/**
	 * Hides the center text message display on announceWave
	 */
	private function hideText(Tween:FlxTween):Void
	{
		FlxTween.tween(midScreenText, { x: FlxG.width }, 1.5, { ease: FlxEase.expoIn, onComplete:gameStart });
	}
	
	/**
	 * Hides the center text message display on announceWave
	 */
	private function gameStart(Tween:FlxTween):Void
	{
		set_levelState(LevelStates.Playing);
	}
	
	private function showDialogWindow(dialog:String)
	{
		dialogWindow.revive();
		text.revive();
		text.resetText(dialog);
				
		curretDialogFinished = false;
		text.start(0.02 , true, false, null, dialogFinished);
		
	}
	
	private function showMultiDialogWindow()
	{
		dialogWindow.revive();
		text.revive();
				
		text.resetText(currentMultiDialog[dialogToShow]);
		
		dialogToShow ++;
		curretDialogFinished = false;
		text.start(0.02 , true, false, null,  dialogFinished);
	}
	
		
	function dialogFinished()
	{
		curretDialogFinished = true;
		
	}
	
	function dialogWindowClick(sprite:FlxSprite) {
		
		if (curretDialogFinished == false)
		{
			text.skip();
			
		} else
		{
			if ( dialogToShow != dialogCounter)
			{
				showMultiDialogWindow();
			}else
			{
				dialogWindow.kill();
				text.kill();
				dialogCounter = 0;
				if (isStart )
				{
					showStartText();
					isStart = false;
				}
				if (isEnd)
				{
					dialogCounter = -1;
					FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
						FlxG.switchState(new levels.MenuState());
					});
				}
			}
			
		}
	}
	
	
	function set_levelState(value:LevelStates):LevelStates 
	{
		Reg.LEVELSTATE = value;
		return levelState = value;
	}
	
	private function checkWaves(Timer:FlxTimer):Void
	{
		
		for (w in enemyWaves)
		{
			if ( levelTmer >= w.timeToStart )
			{
				switch(w.type) {
					case Popcorn:
						new FlxTimer().start( 	w.delay ,
												function(_)
												{
													spawnPopcornEnemy(w.enter , w.exit);
												},
												w.quantity);
					case Shooter:
						new FlxTimer().start( 	w.delay ,
												function(_)
												{
													spawnShooterEnemy(w.enter , w.exit);
												},
												w.quantity);
					case Chaser:
						new FlxTimer().start( 	w.delay ,
												function(_)
												{
													spawnChaserEnemy(w.enter , w.exit);
												},
												w.quantity);
					case HardShooter:
						new FlxTimer().start( 	w.delay ,
												function(_)
												{
													spawnHardShooterEnemy(w.enter , w.exit , w.drop);
												},
												w.quantity);
						
				}
				
				enemyWaves.remove(w);
			}
		}
	}
	
	
	public function setWeaponIcon(weapon:player.Player.PlayerWeapon): Void
	{
		switch(weapon)
		{
			case(PlayerWeapon.BULLETWEAPON):
				bulletWeaponIcon.revive();
				missileWeaponIcon.kill();
				laserWeaponIcon.kill();
			case(PlayerWeapon.MISSILEWEAPON):
				bulletWeaponIcon.kill();
				missileWeaponIcon.revive();
				laserWeaponIcon.kill();
			case(PlayerWeapon.LASERWEAPON):
				bulletWeaponIcon.kill();
				missileWeaponIcon.kill();
				laserWeaponIcon.revive();
		}
		
	}
	
}

