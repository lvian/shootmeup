package;

import flixel.group.FlxGroup;
import flixel.util.FlxSave;
import flixel.util.FlxSignal;
import util.LevelManager;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
	
	//Assets
	public static inline var BULLETS:String = "assets/images/enemybullet.png";
	public static inline var PLAYERBULLETS:String = "assets/images/playerbullet.png";
	public static inline var PLAYERBULLETEXPLOSION:String = "assets/images/playerbulletexplosion.png";
	public static inline var ENEMYBULLETEXPLOSION:String = "assets/images/enemybulletexplosion.png";
	public static inline var PLAYER:String = "assets/images/player.png";
	public static inline var CHASER:String = "assets/images/chaser.png";
	public static inline var SHOOTER:String = "assets/images/shooter.png";
	public static inline var HARDSHOOTER:String = "assets/images/hardshooter.png";
	public static inline var PLAYERMISSILE:String = "assets/images/missile.png";
	public static inline var MISSILESMOKE:String =  "assets/images/missilesmoke.png";
	public static inline var ENEMYEXPLOSION:String =  "assets/images/enemyexplosion.png";
	public static inline var MISSILEXPLOSION:String =  "assets/images/missileexplosion.png";
	public static inline var CLOUDLARGE:String = "assets/images/cloudlarge.png";
	
	//Music
	public static inline var MUSIC:String = "assets/music/music_one.ogg";
	
	//SFX
	public static inline var SOUNDBULLET:String = "assets/sounds/bullet.wav";
	
	// Groups for rendering order
	public static var backgroundGroup= new FlxGroup();
	public static var enemiesGroup = new FlxGroup();
	public static var playerBulletsGroup = new FlxGroup();
	public static var playerGroup = new FlxGroup();
	public static var GUIGroup = new FlxGroup();
	
	//Event listner for dead enemies
	public static var deadEnemies = new FlxSignal();
	
	//Event listner for weapon change used by UI
	//public static var weaponChange = new FlxTypedSignal<Player.PlayerWeapon->Void>();
	
	
	//Player Score and signal
	public static var SCORE:Int = 0;
	public static var updateScore = new FlxTypedSignal<Int->Void>();
	
	//Map settings
	public static inline var BACKGROUNDSCROLLVELOCITY:Int = 5;
	public static inline var FOREGROUNDSCROLLVELOCITY:Int = 150;
	
	//Current Level State
	public static  var LEVELSTATE:LevelStates = LevelStates.BeforeStart;
	
	//Event listner for dead enemies
	//public static var playerHealthChanged = new FlxTypedSignal<Int->Void>();
	
	public static function clearStateVariables()
	{
		backgroundGroup = new FlxGroup();
		enemiesGroup = new FlxGroup();
		playerBulletsGroup = new FlxGroup();
		playerGroup = new FlxGroup();
		GUIGroup = new FlxGroup();
		
		LEVELSTATE  = LevelStates.BeforeStart;
		
		deadEnemies = new FlxSignal();
		
	}
	


}