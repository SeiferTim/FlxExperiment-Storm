package  
{
	import flash.display.BitmapData;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.ime.CompositionAttributeRange;
	import org.flixel.*;
	import net.tileisle.SeedRnd;
	import flash.display.GradientType;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author SeiferTim Hely
	 */
	public class Bolt extends FlxSprite 
	{
		
		private var _x:Number;
		private var _y:Number;
		private var _targetx:Number;
		private var _targety:Number;
		
		private var _bd:BitmapData;
		
		public function Bolt()
		{
			super(0,0);
		}
		
		public function launch(Lights:Vector.<FlxPoint>, X:Number = 0, Y:Number = 0):void
		{
			reset(0,0);
			_x = X;
			_y = Y;
			alpha = 1;
			
			_bd = new BitmapData(FlxG.width, FlxG.height, true, 0x00000000);
			var _bd2:BitmapData = new BitmapData(FlxG.width, FlxG.height, true, 0x00000000);
			
			
			// first, we need a flash of light in the origin... 
			
			
			var pos:FlxPoint;
			
			/// draw lines, pointed towards the target, +/- a few degrees...
			
			var s:Shape = new Shape();
			s.graphics.lineStyle(1, 0xffffff, 1);
			
			pos = new FlxPoint(_x, _y);
			s = drawThread(s,pos, Lights);
			
			_bd.draw(s);
			
			
			var gF:GlowFilter = new GlowFilter(0xffffff, 1, 6, 6, 4, 3);
			_bd.applyFilter(_bd, new Rectangle(0, 0, FlxG.width, FlxG.height), new Point(0, 0), gF);
			
			
			s = new Shape();
			
			var mtx:Matrix = new Matrix();
			mtx.createGradientBox(60, 60, 0, _x+-30, _y+-30);
			s.graphics.beginGradientFill(GradientType.RADIAL, [0xffffff, 0xffffff, 0xffffff], [.9,.9,0], [0,66,255], mtx);
			s.graphics.drawCircle(_x, _y, 30);
			
			
			_bd2.copyPixels(_bd, new Rectangle(0, 0, FlxG.width, FlxG.height), new Point(0, 0),_bd,new Point(0,0),true);

			_bd2.draw(s);
			
			pixels = _bd2;
			dirty = true;
			
			
		}
		
		private function drawThread(s:Shape, pos:FlxPoint, Lights:Vector.<FlxPoint>, jumpCount:uint = 0):Shape
		{
			
			var jump_to:FlxPoint;
			var jump_count:uint = 0;
			var struckLight:Boolean = false;
			var done:Boolean = false;
			var length:Number;
			
			jump_count = jumpCount;
		
			do 
			{
				s.graphics.moveTo(pos.x, pos.y);
				
				/// check around the current pos, see if there are any lights.
				
				for each (var rl:FlxPoint in Lights)
				{
					if (FlxU.getDistance(rl, pos) <= 30)
					{
						// strike that light!
						jump_to = rl;
						s.graphics.lineTo(jump_to.x, jump_to.y);
						struckLight = true;
						done = true;
						break;
					}
				}
				if(!struckLight)
				{
					length = SeedRnd.integer(6, 12);
				
					jump_to = new FlxPoint(pos.x, pos.y + length);
					FlxU.rotatePoint(jump_to.x, jump_to.y, pos.x, pos.y, SeedRnd.integer(-30,30), jump_to);
					
					jump_count++;
					
					s.graphics.lineTo(jump_to.x, jump_to.y);
					pos = new FlxPoint(jump_to.x, jump_to.y);
					
					if (SeedRnd.integer(FlxG.height * .7,FlxG.height * .4) < pos.y || SeedRnd.boolean(jump_count * 0.01))
						done = true;
					else
					{
						if (SeedRnd.boolean(.2 - jump_count * 0.02))
						{
							s = drawThread(s, pos, Lights, jump_count*2);
						}
					}
					
					
				}
				
				
				
			} while (!done);
			return s;
		}
		
		override public function update():void 
		{
			if (!alive || !exists) return;
			if (alpha > 0) alpha -= FlxG.elapsed * 2;
			else kill();
			super.update();
		}
		
	}

}