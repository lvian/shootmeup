package levels;

import flixel.system.FlxSound;
import levels.BaseState;
import levels.LevelOne;
import flixel.addons.ui.*;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import flixel.FlxG;
import flixel.util.FlxColor;
/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends levels.BaseState
{
	/**   
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_xml_id = "menu_state"; //looks for "menu_state.xml"
		super.create();
			
			
			FlxG.sound.muted = false;
			
			//FlxG.sound.playMusic("assets/music/music_one.ogg" , 1 , true).fadeIn(1 , 0, 0.5) ;
			FlxG.sound.playMusic("assets/music/music_one.ogg", 0.5, true);
			FlxG.sound.music.fadeIn(1, 0, 0.5);
			
		
			
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
	}	
	public override function getEvent(name:String, sender:Dynamic, data:Dynamic,?params:Array<Dynamic>):Void {
		var str:String = "";
		
		if (name == "click_button")
		{
			
			if (params != null && params.length > 0) {
				switch(cast(params[0],String)) {
					case "start":	FlxG.sound.music.fadeOut(1, 0);
									FlxG.camera.fade(FlxColor.BLACK, 1 , false, function() {
										FlxG.switchState(new levels.LevelOne());
									});
					case "options":	openSubState(new levels.OptionsState());
								
					case "credits":	openSubState(new levels.OptionsState());
					
					case "mute":	FlxG.sound.toggleMuted();
								
				}
			}
		}		
	}	
}