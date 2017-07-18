package levels;

import enemies.BaseEnemy;
import flixel.FlxBasic;
import flixel.addons.ui.*;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import flixel.FlxG;
import enemies.BaseEnemy.*;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import util.BackgroundController;


/**
 * A FlxState which can be used for the game's menu.
 */
class BaseState extends FlxUIState
{
	public var levelManager:util.LevelManager;
	public var backgroundController:BackgroundController;
	public var player:player.Player;
	public var backGround:FlxBackdrop;
	public var foreGround:FlxBackdrop;
	public var healthBar:FlxBar;
	public var shieldBar:FlxBar;
	public var score:FlxText;
	public var backButton:FlxBasic;
	
	public var middleGroup:FlxGroup;
	public var playerGroup:FlxGroup;
	public var foregroundGroup:FlxGroup;
	
	var enemyWaves:FlxTypedGroup<util.EnemyWaves>;
	
	public function getUI():FlxUI
	{
		return null;
	};
	
}