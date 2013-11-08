package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import net.tileisle.SeedRnd;
	import org.flixel.plugin.photonstorm.FlxColor;
	
	/**
	 * ...
	 * @author SeiferTim Hely
	 */
	public class CloudPart extends FlxSprite 
	{
		
		private var _level:uint = 0;
		private var _created:Boolean = false;
		private var _ystart:Number;
		
		
		public function CloudPart(X:Number=0, Y:Number=0) 
		{
			super(X, Y);
		}
		
		public function create(Level:uint, Speed:uint):void
		{
			
			_ystart = y;
			_level = Level;
			var h:uint = 255;
			h -= (20 * (Level + 3)) * SeedRnd.float(0.99, 1.01);
			var c:uint = FlxColor.getColor32(255, h, h, h);
			
			var size:uint = (30  - (.25 * (Level))) * SeedRnd.float(0.8,1.2);
			makeGraphic(size, size, c);
			
			velocity.x = Speed;
			_created = true;
			
			
		}
		
		public function get created():Boolean
		{
			return _created;
		}
		
		override public function update():void 
		{
			if (_created)
			{
				y = _ystart + (Math.sin((x/(6-(_level/2)))*Math.PI*0.1) * 6);
				if (x > FlxG.width) kill();
			}
			super.update();
			
			
		}
		
	}

}