package org.flixel
{
	import flash.geom.Point;
	
	/**
	 * Stores a 2D floating point coordinate.
	 * 
	 * @author	Adam Atomic
	 */
	public class FlxPoint
	{
		/**
		 * @default 0
		 */
		protected var _x:Number;
		/**
		 * @default 0
		 */
		protected var _y:Number;
		
		/**
		 * Instantiate a new point object.
		 * 
		 * @param	X		The X-coordinate of the point in space.
		 * @param	Y		The Y-coordinate of the point in space.
		 */
		public function FlxPoint(X:Number=0, Y:Number=0)
		{
			_x = X;
			_y = Y;
		}
		
		/**
		 * Instantiate a new point object.
		 * 
		 * @param	X		The X-coordinate of the point in space.
		 * @param	Y		The Y-coordinate of the point in space.
		 */
		public function make(X:Number=0, Y:Number=0):FlxPoint
		{
			_x = X;
			_y = Y;
			return this;
		}
		
		/**
		 * Helper function, just copies the values from the specified point.
		 * 
		 * @param	Point	Any <code>FlxPoint</code>.
		 * 
		 * @return	A reference to itself.
		 */
		public function copyFrom(Point:FlxPoint):FlxPoint
		{
			_x = Point.x;
			_y = Point.y;
			return this;
		}
		
		/**
		 * Helper function, just copies the values from this point to the specified point.
		 * 
		 * @param	Point	Any <code>FlxPoint</code>.
		 * 
		 * @return	A reference to the altered point parameter.
		 */
		public function copyTo(Point:FlxPoint):FlxPoint
		{
			Point.x = _x;
			Point.y = _y;
			return Point;
		}
		
		/**
		 * Helper function, just copies the values from the specified Flash point.
		 * 
		 * @param	Point	Any <code>Point</code>.
		 * 
		 * @return	A reference to itself.
		 */
		public function copyFromFlash(FlashPoint:Point):FlxPoint
		{
			_x = FlashPoint.x;
			_y = FlashPoint.y;
			return this;
		}
		
		/**
		 * Helper function, just copies the values from this point to the specified Flash point.
		 * 
		 * @param	Point	Any <code>Point</code>.
		 * 
		 * @return	A reference to the altered point parameter.
		 */
		public function copyToFlash(FlashPoint:Point):Point
		{
			FlashPoint.x = _x;
			FlashPoint.y = _y;
			return FlashPoint;
		}
		
		public function length():Number
		{
			return Math.sqrt(  Math.pow(_x , 2) +   Math.pow(_y  , 2));
		}
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function set x(value:Number):void 
		{
			_x = value;
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			_y = value;
		}
		
	}
}
