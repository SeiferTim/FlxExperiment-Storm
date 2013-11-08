package org.flixel.plugin
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display3D.textures.RectangleTexture;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.flixel.FlxBasic;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxGradient;

	public class FlxReflect extends FlxBasic 
	{
		private static var members:Dictionary = new Dictionary(true);
		private var buffer:Sprite = new Sprite;
		private var buffer2:Sprite = new Sprite;
		
		public function FlxReflect() 
		{
			
		}
		
		public static function setup(Source:FlxSprite, SourceCamera:FlxCamera= null, UseMask:Boolean = false, MaskToHidden:Boolean = true):void
		{
			if (members[Source])
			{
				throw Error("FlxSprite already exists in FlxReflect, use addZone to add a new scrolling region to an already added FlxSprite");
			}
			
			var data:Object = new Object();
			data.source = Source;
			data.regions = new Vector.<Rectangle>;
			data.useMask = UseMask;
			data.highesty = -1;
			data.lowesty = -1;
			data.maskToHidden = MaskToHidden;
			data.tmpG = FlxGradient.createGradientBitmapData(data.source.width, 256, [0xff000000,0x0,0x0,0x0,0x0]);
			data.alpha = new BitmapData(data.source.width, data.source.height, true, 0x0);
			data.camera = SourceCamera;
			data.shade = new ColorTransform(1, 1, 1);

			members[Source] = data;
		}
		
		public static function addZone(Source:FlxSprite, Region:Rectangle):void
		{
			members[Source].regions.push(Region);
			
			//if (members[Source].useMask)
			//{
			
				(members[Source].alpha as BitmapData).fillRect(Region, 0xff000000);
			
				
				
				if (Region.y < members[Source].highesty || members[Source].highesty == -1)
					members[Source].highesty = Region.y;
					
				if (Region.y + Region.height > members[Source].lowesty || members[Source].lowesty == -1)
					members[Source].lowesty = Region.y + Region.height;
					
				var tmpB:BitmapData = new BitmapData(members[Source].source.width, members[Source].lowesty - members[Source].highesty, true, members[Source].maskToHidden == true ? 0x0 : 0xff000000);
				tmpB.fillRect(new Rectangle(0, 0, members[Source].source.width, 257), 0x0);
				tmpB.copyPixels(members[Source].tmpG, members[Source].tmpG.rect, new Point(0, 1));// , data.source.pixels, new Point(0, 0), false);
				(members[Source].alpha as BitmapData).copyChannel(tmpB, tmpB.rect, new Point(0, members[Source].highesty), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
				//(members[Source].alpha as BitmapData).fillRect(new Rectangle(0, members[Source].highesty, members[Source].width, 4), 0xff000000);
			//}
			
		}
		
		override public function draw():void
		{
			for each (var obj:Object in members)
			{
				if (obj.source.exists && obj.source.alive && obj.source.visible)
				{
					scroll(obj);
				}
			}
		}
		
		private function scroll(data:Object):void
		{
			
			if (data.camera != null)
			{
				var tmpR:BitmapData = new BitmapData(data.camera.buffer.width, data.camera.buffer.height, true, 0x0);
				tmpR.copyPixels(data.camera.buffer, data.camera.buffer.rect, new Point);
				
				//flipBitmapData(, "y");
				var tmpA:BitmapData = new BitmapData(data.source.width, data.lowesty - data.highesty, true, 0x0);
				
				tmpA.copyPixels(tmpR, new Rectangle(0, data.highesty -  (data.lowesty - data.highesty), tmpR.width, data.lowesty - data.highesty), new Point);
				tmpA = flipBitmapData(tmpA, data.shade, "y");
				
				if (data.useMask)
				{
					
					//data.alpha.copyPixels(tmpB,tmpB.rect,new Point(),data.
					//tmpA.copyChannel(tmpB, tmpB.rect, new Point(0,0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
					
				}
				
				(data.source.pixels as BitmapData).copyPixels(tmpA, tmpA.rect, new Point(0, data.highesty)) ; //data.camera.buffer;
				data.source.pixels.copyChannel(data.alpha, data.alpha.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
				data.source.dirty = true;
			}
			
		}
		
		public static function flipBitmapData(source:BitmapData, shade:ColorTransform, axis:String = "y"):BitmapData
		{
			var output:BitmapData = new BitmapData(source.width, source.height, true, 0);
			
			//	Default to a Y flip, but can also do an X flip too
			var matrix:Matrix = new Matrix( 1, 0, 0, -1, 0, source.height);

			if (axis == "x")
			{
				matrix = new Matrix( -1, 0, 0, 1, source.width, 0);
			}
			
			output.draw(source, matrix);// , shade);
     
			return output;
		}
		
		public static function clear():void
		{
			for each (var obj:Object in members)
			{
				delete members[obj.source];
			}
		}
		
		override public function destroy():void
		{
			clear();
		}
	}

}