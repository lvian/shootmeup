package levels;



import enemies.BaseEnemy;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.*;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import levels.BaseState;
import misc.BasePowerUp;
import player.Player;
import util.BackgroundController;
import util.EnemyWaves;
import util.LevelManager;



/**
 * A FlxState which can be used for the actual gameplay.
 */
class LevelOne extends levels.BaseState
{
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_xml_id = "play_state"; 
		
		Reg.clearStateVariables();
		
		
		backgroundController = new BackgroundController("assets/images/background.png" , Reg.BACKGROUNDSCROLLVELOCITY);
		backgroundController.backgroundSpeed(BackgroundSpeed.Double);
		
		//foreground clouds
		var emitter = new FlxEmitter(0, - 150, 10);
		emitter.width = FlxG.width;
		emitter.acceleration.set(20,20);
		//emitter. setRotation(0, 0);
		//emitter.setXSpeed(0,0);
		//emitter.setXSpeed( -20, 20);
		//emitter.setYSpeed( -75, -25);
		
		
		var particle:FlxParticle;
		
		for (i in 0...10)
		{
			particle = new FlxParticle();
			particle.loadGraphic(Reg.CLOUDLARGE, true, 128, 128);
			
			// Add the particle to the trail area so it has a trail
			emitter.add(particle);
			
		}
		
		
		Reg.backgroundGroup.add(emitter);
		Reg.playerGroup.add(player = new player.Player(this));
		// Start the emitter
		emitter.start(false, 1 , 0);
		
		//Register to scoreupdate
		Reg.updateScore.add(updateScore);
		player.immovable = true;
		
		
		healthBar = new FlxBar(10, FlxG.height / 3,  FlxBarFillDirection.BOTTOM_TO_TOP, 25, 150, player, "hitPoints", 0 , 10, true);
		Reg.GUIGroup.add(healthBar);
		shieldBar = new FlxBar(5, FlxG.height / 3 - 5,  FlxBarFillDirection.BOTTOM_TO_TOP, 35, 160, player, "shield", 0 , 10, true);
		shieldBar.createFilledBar(0x00FFFFFF, 0x55333399, false);
		Reg.GUIGroup.add(shieldBar);
		
		
		//Pre level dialogs
		var preDialogs = new Array();
		preDialogs.push("If they wanted to scare me by kidnapping her, they don't really know me ... they only managed to make me angrier!");
		preDialogs.push("They want my ship and its technology? Oh I will give it to them ...");
		preDialogs.push("... all guns included !!!");
		
		//Post boss dialogs
		var postDialogs = new Array();
		postDialogs.push("Dammit she wasn't here, just a quick stop to refuel and rearm and I'll hit another of their bases!");
		postDialogs.push("Hang on GIRLNAME  I'll save you!");
			
		
		super.create();
		loadEnemyWaves();
		add(levelManager = new util.LevelManager(this, player, enemyWaves , preDialogs  ,  postDialogs ));
		
		score = _ui.getFlxText("scoretext");
		backButton = cast _ui.getAsset("back_button");
		
		// Sign to weapon change event listener and asign the callback function
		
		Reg.GUIGroup.add(cast _ui.getAsset("weapon_bullet_icon"));
		
		Reg.GUIGroup.add(cast _ui.getAsset("weapon_missile_icon"));
		
		Reg.GUIGroup.add( cast _ui.getAsset("weapon_laser_icon"));
		
		Reg.GUIGroup.add( cast _ui.getAsset("weaponpower"));
		
		Reg.GUIGroup.add( cast _ui.getAsset("lives"));
		
		Reg.GUIGroup.add( cast _ui.getAsset("lives_icon"));
		
		
		score.text = Std.string(Reg.SCORE);
		Reg.GUIGroup.add(score);
		Reg.GUIGroup.add(backButton);
		
		add(Reg.backgroundGroup);
		add(Reg.enemiesGroup);
		add(Reg.playerBulletsGroup);
		add(Reg.playerGroup);
		add(Reg.GUIGroup);
	}
	
	override public function getUI(): FlxUI
	{
		return _ui;
	}
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed(["SHIFT"]))
		{
			openSubState(new levels.OptionsState());
			FlxTween.globalManager.active = false;
		}
	}	
	
		
	public function updateScore(points:Int):Void
	{
		Reg.SCORE += points;
		score.text = Std.string(Reg.SCORE);
	}
	
	public override function getEvent(name:String, target:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void 
	{
		if (name == "click_button")
		{
			if (params != null && params.length > 0) {
					switch(cast(params[0],String)) {
						case "back":FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
										FlxG.switchState(new levels.MenuState());
									});
						}
				}
		
		}
	}
	
	
	
	function loadEnemyWaves() {
		
		
		enemyWaves = new FlxTypedGroup();
		
		// first minute
		
		enemyWaves.add(new util.EnemyWaves(5, 2, util.EnemyWaves.EnemyType.Popcorn, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW ));
		enemyWaves.add(new util.EnemyWaves(15, 2, util.EnemyWaves.EnemyType.Popcorn, 0.5, enemies.BaseEnemy.EnemyPositions.NW, enemies.BaseEnemy.EnemyPositions.NE));
		//Enable random chasers enabled
		enemyWaves.add(new util.EnemyWaves(25, 2, util.EnemyWaves.EnemyType.Popcorn, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
		enemyWaves.add(new util.EnemyWaves(30, 1, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW, misc.BasePowerUp.PowerUpType.WeaponLevelUpgrade));
		enemyWaves.add(new util.EnemyWaves(35, 2, util.EnemyWaves.EnemyType.Popcorn, 0.5, enemies.BaseEnemy.EnemyPositions.NW, enemies.BaseEnemy.EnemyPositions.NE));
		enemyWaves.add(new util.EnemyWaves(45, 2, util.EnemyWaves.EnemyType.Popcorn, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.SE));
		enemyWaves.add(new util.EnemyWaves(55, 2, util.EnemyWaves.EnemyType.Popcorn, 0.5, enemies.BaseEnemy.EnemyPositions.NW, enemies.BaseEnemy.EnemyPositions.SW));
		enemyWaves.add(new util.EnemyWaves(60, 1, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NW, enemies.BaseEnemy.EnemyPositions.NW));
				
		
		// second minute
		enemyWaves.add(new util.EnemyWaves(65, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW ));
		enemyWaves.add(new util.EnemyWaves(75, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NW, enemies.BaseEnemy.EnemyPositions.NE));
		enemyWaves.add(new util.EnemyWaves(85, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
		enemyWaves.add(new util.EnemyWaves(90, 1, util.EnemyWaves.EnemyType.HardShooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW, misc.BasePowerUp.PowerUpType.WeaponLevelUpgrade));
		enemyWaves.add(new util.EnemyWaves(95, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NW, enemies.BaseEnemy.EnemyPositions.NE));
		enemyWaves.add(new util.EnemyWaves(105, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.SE));
		enemyWaves.add(new util.EnemyWaves(115, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NW, enemies.BaseEnemy.EnemyPositions.SW));
		enemyWaves.add(new util.EnemyWaves(120, 1, util.EnemyWaves.EnemyType.HardShooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
				
		
		// thirdth minute
		enemyWaves.add(new util.EnemyWaves(125, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NW, enemies.BaseEnemy.EnemyPositions.SE ));
		enemyWaves.add(new util.EnemyWaves(135, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.SW));
		//Enable random chasers enabled
		enemyWaves.add(new util.EnemyWaves(145, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NW, enemies.BaseEnemy.EnemyPositions.NW));
		enemyWaves.add(new util.EnemyWaves(150, 1, util.EnemyWaves.EnemyType.HardShooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW, misc.BasePowerUp.PowerUpType.WeaponLevelUpgrade));
		enemyWaves.add(new util.EnemyWaves(155, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NE));
		enemyWaves.add(new util.EnemyWaves(165, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.SW));
		enemyWaves.add(new util.EnemyWaves(175, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NW, enemies.BaseEnemy.EnemyPositions.SE));
		enemyWaves.add(new util.EnemyWaves(180, 1, util.EnemyWaves.EnemyType.HardShooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
				
		
		// fourth minute
		enemyWaves.add(new util.EnemyWaves(185, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW ));
		enemyWaves.add(new util.EnemyWaves(195, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
		//Enable random chasers enabled
		enemyWaves.add(new util.EnemyWaves(205, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
		enemyWaves.add(new util.EnemyWaves(210, 1, util.EnemyWaves.EnemyType.HardShooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW, misc.BasePowerUp.PowerUpType.WeaponLevelUpgrade));
		enemyWaves.add(new util.EnemyWaves(215, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
		enemyWaves.add(new util.EnemyWaves(225, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
		enemyWaves.add(new util.EnemyWaves(235, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
		enemyWaves.add(new util.EnemyWaves(240, 1, util.EnemyWaves.EnemyType.HardShooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
				
		
		// fifth minute
		enemyWaves.add(new util.EnemyWaves(245, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW ));
		enemyWaves.add(new util.EnemyWaves(255, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
		//Enable random chasers enabled
		enemyWaves.add(new util.EnemyWaves(265, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
		enemyWaves.add(new util.EnemyWaves(270, 1, util.EnemyWaves.EnemyType.HardShooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW, misc.BasePowerUp.PowerUpType.WeaponLevelUpgrade));
		enemyWaves.add(new util.EnemyWaves(275, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
		enemyWaves.add(new util.EnemyWaves(285, 3, util.EnemyWaves.EnemyType.Shooter, 0.5, enemies.BaseEnemy.EnemyPositions.NE, enemies.BaseEnemy.EnemyPositions.NW));
		
		
		
		
	}
	
	
}