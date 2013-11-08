package  
{
	import net.tileisle.*;
	import org.flixel.*;
	
	[SWF(width = "400", height = "320", backgroundColor = "#000000")]
	
	public class storm extends FlxGame
	{
		
		public function storm() 
		{
			super(400, 320, PlayState, 1, 30, 30);
			FlxG.bgColor = 0x000000;
			FlxG.debug = true;
			canPause = false;
		}
		
	}

}