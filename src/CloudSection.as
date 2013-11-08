package  
{
	import org.flixel.*;
	import net.tileisle.SeedRnd;
	
	/**
	 * ...
	 * @author SeiferTim Hely
	 */
	public class CloudSection extends FlxGroup 
	{
		
		private var _tmr:Number = 0;
		private var _layer:uint = 0;
		
		private var _speed:uint = 0;
		private var _ystart:Number = 0;
		
		public function CloudSection(Layer:uint = 0) 
		{
			super();
			_layer = Layer;
			
			_speed = 40;
			_speed -= (Math.pow(_layer, 2) * 0.11);
			_ystart =  ((_layer - 1) * 18) - 2;
			
			var cp:CloudPart;
			for (var x:int = -10; x < FlxG.width; x+=6)
			{
				cp = recycle(CloudPart) as CloudPart;
				cp.reset( x, _ystart + SeedRnd.integer(0, 10));
				cp.create(_layer, _speed);
			}
			
		}
		
		override public function update():void 
		{
			
			if  (_tmr >= 1)
			{
				_tmr = 0				
				var cp:CloudPart = recycle(CloudPart) as CloudPart;
				cp.reset( -10, _ystart + SeedRnd.integer(0, 10));
				cp.create(_layer, _speed);
			}
			else
				_tmr += FlxG.elapsed * 12;
				
			super.update();
			
		}
		
		public function get ystart():uint
		{
			return _ystart;
		}
		
	}

}