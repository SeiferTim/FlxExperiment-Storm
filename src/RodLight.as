package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import net.tileisle.SeedRnd;
	
	/**
	 * ...
	 * @author SeiferTim Hely
	 */
	public class RodLight extends FlxGroup 
	{
		private var light_on:FlxSprite;
		private var light_off:FlxSprite;
		private var _x:Number;
		private var _y:Number;
		
		private const light_color:uint = 0xFFFF1919;
		
		private var dir:int = 1;
		
		public function RodLight(X:Number,Y:Number,Color:uint) 
		{
			super();
			_x = X;
			_y = Y;
			light_off = new FlxSprite(X, Y).makeGraphic(4, 4, Color);
			light_on = new FlxSprite(X, Y).makeGraphic(4, 4, light_color);
			add(light_off);
			add(light_on);
			
			if (SeedRnd.boolean(0.66))
			{
				if (SeedRnd.boolean(0.66))
				{
					light_on.alpha = SeedRnd.float(0, 1);
					dir = -1;
				}
				else
				{
					light_on.alpha = SeedRnd.float(0.66, 1);
					dir = 1;
				}
			}
			else
			{
				light_on.alpha = 0;
			}
			
			
		}
		
		public function get x():Number
		{
			return _x;
			
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		override public function update():void 
		{
			if (light_on.alpha == 1)
			{
				dir = -1;
			}
			else if (light_on.alpha == 0)
			{
				dir = 1;
				light_on.alpha = .66;
			}
			
			if (dir == 1)
			{
				light_on.alpha += FlxG.elapsed * 2;
			}
			else if (dir == -1)
			{
				light_on.alpha -= FlxG.elapsed;
			}
			
			super.update();
		}
		
	}

}