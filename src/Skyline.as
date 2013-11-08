package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import net.tileisle.SeedRnd;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxColor;
	
	/**
	 * ...
	 * @author SeiferTim Hely
	 */
	public class Skyline extends FlxGroup 
	{
		
		private var _level:uint;
		
		private var _lights:FlxGroup;
		private var _rods:FlxGroup;
		
		private const lColor:uint = 0xFFFFFFCC;
		private const types:Array = [0, 0, 0, 0, 1, 1, 1, 2];
		
		public function Skyline(Level:uint) 
		{
			super();
			
			_level = Level;
			
			var back:BitmapData;
			var curx:int = SeedRnd.integer( -10, -1);
			var newHeight:int;
			var newWidth:int;
			var h:int;
			var c:uint;
			
			var lx:int;
			var ly:int;
			
			var type:int = types[SeedRnd.integer(0,types.length)];
			var newType:int;
			
			var y:int = -100 + (_level * 22);
			
			var sprLight:FlxSprite;
			
			h = ( _level - 1) * 30;
			if (h < 0) h = 0;
			c = FlxColor.getColor32(255, h, h, h);
			
			back = new BitmapData(FlxG.width, FlxG.height, true, 0x00000000);
			
			_lights = new FlxGroup();
			_rods = new FlxGroup();
			
			while (curx < FlxG.width)
			{
				if (type == 0)
				{
					newHeight = SeedRnd.integer(FlxG.height * 0.07, FlxG.height * 0.15);
					newWidth = 8 * SeedRnd.integer(5, 8) + 2;
				}
				else if (type == 1)
				{
					newHeight = SeedRnd.integer(FlxG.height * 0.15, FlxG.height * 0.20);
					newWidth = 8 * SeedRnd.integer(4, 6) + 2;
				}
				else if (type == 2)
				{
					newHeight = SeedRnd.integer(FlxG.height * 0.3, FlxG.height * 0.45);
					newWidth = 8 * SeedRnd.integer(1, 4) + 2;
				}
				
				
				
				back.fillRect(new Rectangle(curx, FlxG.height - newHeight, newWidth, newHeight), c);
				
				for (lx = curx+1; lx < curx + newWidth-2; lx += 8)
				{
					for (ly = FlxG.height - newHeight+1; ly < FlxG.height; ly += 8)
					{
						sprLight = new FlxSprite(lx + 1, ly + 1 + y);
						if (SeedRnd.boolean(0.8))
						{
							sprLight.makeGraphic(6, 6, FlxColor.getColor32(255, h + 20, h + 20, h + 20));
						}
						else
						{
							sprLight.makeGraphic(6, 6, lColor);
						}
						
						_lights.add(sprLight);
					}
				}
				
				if ((SeedRnd.boolean(0.33) || type == 2) && type != 1)
				{
					back.fillRect(new Rectangle(curx + (newWidth / 2)-1, FlxG.height - newHeight - 30, 2, 30), c);
					_rods.add(new RodLight(curx + (newWidth / 2)-2, FlxG.height - newHeight - 30 + y, FlxColor.getColor32(255, h + 20, h + 20, h + 20)));
				}
				
				curx += newWidth;
				
				
				type = types[SeedRnd.integer(0,types.length)];
			}
			
			
			
			
			var sprSkyline:FlxSprite = new FlxSprite(0, y);
			sprSkyline.pixels = back;  //.copyPixels(back, new Rectangle(0, 0, back.width, back.height), new Point(0, 0));
			sprSkyline.dirty = true;
			
			add(sprSkyline);
			add(_lights);
			add(_rods);
		}
		
		public function get rods():FlxGroup
		{
			return _rods;
		}
		
		public function get lights():FlxGroup
		{
			return _lights;
		}
		
		public function set rods(Value:FlxGroup):void
		{
			_rods = Value;
		}
		
		public function set lights(Value:FlxGroup):void
		{
			_lights = Value;
		}
		
	}

}