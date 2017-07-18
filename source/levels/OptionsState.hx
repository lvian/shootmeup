package levels;
import flixel.addons.ui.FlxUIPopup;
import flixel.addons.ui.FlxUIState;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author 
 */
class OptionsState extends FlxUIPopup
{

	public override function create():Void
	{		
		_xml_id = "options_state";
		super.create();
		//_ui.setMode("demo_0");
		trace("teste");
	}
	
	public override function getEvent(id:String, target:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void 
	{
		if (params != null && params.length > 0) {
			if (id == "click_button") {
				var i:Int = cast(params[0]);
				if (i == 0)
				{
					FlxTween.globalManager.active = true;
					close();					
				}
				
				
			}
		}
	}
	
}