package net.tileisle 
{
	import flash.display.BitmapData;
	import flash.media.Camera;
	import org.flixel.*;
	import net.tileisle.SeedRnd;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import org.flixel.system.FlxTile;
	import org.flixel.system.FlxTilemapBuffer;
	
	/**
	 * ...
	 * @author SeiferTim Hely
	 */
	public class FlxTilemapExt extends FlxTilemap 
	{
		private var _tileSize:uint;
		private var _randomSets:uint = 1;
		
		protected var _snapping:uint = 2;
		protected var _slopePoint:FlxPoint = new FlxPoint();
		protected var _objPoint:FlxPoint = new FlxPoint();
		
		private var _slopeClasses:Array = new Array();

		public static const SLOPE_FLOOR_LEFT:uint = 0;
		public static const SLOPE_FLOOR_RIGHT:uint = 1;
		public static const SLOPE_CEIL_LEFT:uint = 2;
		public static const SLOPE_CEIL_RIGHT:uint = 3;


		protected var slopeFloorLeft:Array = new Array();
		protected var slopeFloorRight:Array = new Array();
		protected var slopeCeilLeft:Array = new Array();
		protected var slopeCeilRight:Array = new Array();
		
		public function FlxTilemapExt(RandomSets:uint = 1,TileSize:uint = 16) 
		{
			super();
			_randomSets = RandomSets;
			_tileSize = TileSize;
			
		}
		
		public function get tileSize():uint
		{
			return _tileSize;
		}
		
		public function getTiles():Array
		{
			return _data;
		}
		
		override public function destroy():void
		{
			if (_tileObjects == null) return;
			super.destroy();
		}
		
		
		override public function loadMap(MapData:String, TileGraphic:Class, TileWidth:uint=0, TileHeight:uint=0, AutoTile:uint=OFF, StartingIndex:uint=0, DrawIndex:uint=1, CollideIndex:uint=1):FlxTilemap
		{
			
			var re:RegExp = /-1/g;
			MapData = MapData.replace(re, "0");
			
			return super.loadMap(MapData, TileGraphic, TileWidth, TileHeight, AutoTile, StartingIndex, DrawIndex, CollideIndex);
		}
		
		//
		public function get buffer():BitmapData
		{
			var c:FlxCamera = new FlxCamera(x, y, width, height);
			var b:FlxTilemapBuffer = new FlxTilemapBuffer(_tileWidth, _tileHeight, widthInTiles, heightInTiles,c);
			drawTilemap(b,c);
			
			return b.pixels.clone();
		}
		
		override protected function autoTile(Index:uint):void
		{
			var NW:Boolean;
			var N:Boolean;
			var NE:Boolean;
			var W:Boolean;
			var E:Boolean;
			var SW:Boolean;
			var S:Boolean;
			var SE:Boolean;
			
			/* 0 = space, 1 = solid */
			
			
			if (_data[Index] != 0)
			{
				_data[Index] = 0;
				
				NW = (_data[Index - widthInTiles - 1] != 0);
				N = (_data[Index - widthInTiles] != 0);
				NE = (_data[Index - widthInTiles + 1] != 0);
				W = (_data[Index - 1] != 0);
				E = (_data[Index + 1] != 0);
				SW = (_data[Index + widthInTiles - 1] != 0);
				S = (_data[Index + widthInTiles] != 0);
				SE = (_data[Index + widthInTiles + 1] != 0);
				if (Index < widthInTiles) {
					NW = true;
					N = true;
					NE = true;
				}
				if (Index > _data.length - widthInTiles)
				{
					SW = true;
					S = true;
					SE = true;
				}
				if (Index % widthInTiles == 0)
				{
					W = true;
					NW = true;
					SW = true;
				}
				if (Index % widthInTiles == widthInTiles-1)
				{
					E = true;
					NE = true;
					SE = true;
				}
				
				if (E && SE && S && !W && !N) 								_data[Index] = 2;
				else if (E && SE && S && SW && W && !N) 					_data[Index] = 3;
				else if (S && SW && W && !N && !E) 							_data[Index] = 4;
				else if (!W && !N && !E && S) 								_data[Index] = 5;
				else if (!S && !W && !N && E) 								_data[Index] = 6;
				else if (!S && !N && E && W) 								_data[Index] = 7;
				else if (!N && !E && !S && W) 								_data[Index] = 8;
				else if (W && NW && N && NE && E && !SE && S && !SW) 		_data[Index] = 9;
				else if (!W && N && NE && E && SE && S) 					_data[Index] = 10;
				else if (N && NE && E && SE && S && SW && W && NW) 			_data[Index] = 11;
				else if (!E && S && SW && W && NW && N) 					_data[Index] = 12;
				else if (N && S && !E && !W) 								_data[Index] = 13;
				else if (!W && !N && E && !SE && S) 						_data[Index] = 14;
				else if (!N && E && !SE && S && !SW && W) 					_data[Index] = 15;
				else if (!N && !E && S && !SW && W) 						_data[Index] = 16;
				else if (N && !NE && E && SE && S && SW && W && !NW) 		_data[Index] = 17;
				else if (N && NE && E && !S && !W)  						_data[Index] = 18;
				else if (W && NW && N && NE && E && !S) 					_data[Index] = 19;
				else if (W && NW && N && !E && !S) 							_data[Index] = 20;
				else if (N && !E && !S && !W) 								_data[Index] = 21;
				else if (N && !NE && E && !SE && S && !W) 					_data[Index] = 22;
				else if (N && E && S && W && !NE && !SE && !SW && !NW) 		_data[Index] = 23;
				else if (N && !E && S && !SW && W && !NW) 					_data[Index] = 24;
				else if (!SE && S && SW && W && NW && N && NE && E)  		_data[Index] = 25;
				else if (!SW && W && NW && N && NE && E && SE && S)  		_data[Index] = 26;
				else if (E && SE && S && !SW && W && !NW && N && !NE) 		_data[Index] = 27;
				else if (!NW && N && !NE && E && !SE && S && SW && W)		_data[Index] = 28;
				else if (!NW && N && NE && E && !SE && S && SW && W)		_data[Index] = 29;
				else if (N && !NE && E && !S && !W)							_data[Index] = 30;
				else if (W && !NW && N && !NE && E && !S)					_data[Index] = 31;
				else if (N && !E && !S && W && !NW)							_data[Index] = 32;
				else if (!NE && E && SE && S && SW && W && NW && N)			_data[Index] = 33;
				else if (!NW && N && NE && E && SE && S && SW && W)			_data[Index] = 34;
				else if (N && NE && E && !SE && S && !SW && W && !NW)		_data[Index] = 35;
				else if (!NE && E && !SE && S && !SW && W && !NW && N)		_data[Index] = 36;
				else if (!NE && E && SE && S && !SW && W && NW && N)		_data[Index] = 37;
				else if (!NE && E && !SE && S && SW && W && NW && N)		_data[Index] = 38;
				else if (N && NE && E && SE && S && !SW && W && !NW)		_data[Index] = 39;
				else if (!N && !E && !S && !W)								_data[Index] = 40;
				else if (!N && E && !SE && S && SW && W)					_data[Index] = 41;
				else if (!N && E && SE && S && !SW && W)					_data[Index] = 42;
				else if (N && NE && E && !SE && S && !W)					_data[Index] = 43;
				else if (!E && S && !SW && W && NW && N)					_data[Index] = 44;
				else if (N && !NE && E && !S && W && NW)					_data[Index] = 45;
				else if (!NW && N && NE && E && !S && W)					_data[Index] = 46;
				else if (!W && N && !NE && E && SE && S)					_data[Index] = 47;
				else if (!NW && N && !E && S && SW && W)					_data[Index] = 48;
				
				//if (_data[Index] == 0)
				
				if (_randomSets > 0)
					_data[Index] += SeedRnd.integer(0, _randomSets) * 48;
			}
		}
		
		/**
		 * THIS IS A COPY FROM <code>FlxTilemap</code> BUT IT SOLVES SLOPE COLLISION TOO
		 * Checks if the Object overlaps any tiles with any collision flags set,
		 * and calls the specified callback function (if there is one).
		 * Also calls the tile's registered callback if the filter matches.
		 *
		 * @param Object The <code>FlxObject</code> you are checking for overlaps against.
		 * @param Callback An optional function that takes the form "myCallback(Object1:FlxObject,Object2:FlxObject)", where Object1 is a FlxTile object, and Object2 is the object passed in in the first parameter of this method.
		 * @param FlipCallbackParams Used to preserve A-B list ordering from FlxObject.separate() - returns the FlxTile object as the second parameter instead.
		 * @param Position Optional, specify a custom position for the tilemap (useful for overlapsAt()-type funcitonality).
		 *
		 * @return Whether there were overlaps, or if a callback was specified, whatever the return value of the callback was.
		 */
		override public function overlapsWithCallback(Object:FlxObject,Callback:Function=null,FlipCallbackParams:Boolean=false,Position:FlxPoint=null):Boolean
		{
			var results:Boolean = false;
			
			var X:Number = x;
			var Y:Number = y;
			if(Position != null)
			{
				X = Position.x;
				Y = Position.y;
			}
			
			//Figure out what tiles we need to check against
			var selectionX:int = FlxU.floor((Object.x - X)/_tileWidth);
			var selectionY:int = FlxU.floor((Object.y - Y)/_tileHeight);
			var selectionWidth:int = selectionX + (FlxU.ceil(Object.width/_tileWidth)) + 1;
			var selectionHeight:int = selectionY + FlxU.ceil(Object.height/_tileHeight) + 1;
			
			//Then bound these coordinates by the map edges
			if(selectionX < 0)
				selectionX = 0;
			if(selectionY < 0)
				selectionY = 0;
			if(selectionWidth > widthInTiles)
				selectionWidth = widthInTiles;
			if(selectionHeight > heightInTiles)
				selectionHeight = heightInTiles;
			
			//Then loop through this selection of tiles and call FlxObject.separate() accordingly
			var rowStart:uint = selectionY*widthInTiles;
			var row:uint = selectionY;
			var column:uint;
			var tile:FlxTile;
			var overlapFound:Boolean;
			var deltaX:Number = X - last.x;
			var deltaY:Number = Y - last.y;
			while(row < selectionHeight)
			{
				column = selectionX;
				while(column < selectionWidth)
				{
					overlapFound = false;
					tile = _tileObjects[_data[rowStart+column]] as FlxTile;
					if(tile.allowCollisions)
					{
						tile.x = X+column*_tileWidth;
						tile.y = Y+row*_tileHeight;
						tile.last.x = tile.x - deltaX;
						tile.last.y = tile.y - deltaY;
						
						if(Callback != null)
						{
							if(FlipCallbackParams)
								overlapFound = Callback(Object,tile);
							else
								overlapFound = Callback(tile,Object);
						}
						else
							overlapFound = (Object.x + Object.width > tile.x) && (Object.x < tile.x + tile.width) && (Object.y + Object.height > tile.y) && (Object.y < tile.y + tile.height);
						
						if (!overlapFound)
							overlapFound = checkArrays(tile.index);
						if(overlapFound)
						{
							
							if((tile.callback != null) && ((tile.filter == null) || (Object is tile.filter)))
							{
								tile.mapIndex = rowStart+column;
								tile.callback(tile,Object);
							}
							results = true;
						}
					}
					else if((tile.callback != null) && ((tile.filter == null) || (Object is tile.filter)))
					{
						tile.mapIndex = rowStart+column;
						tile.callback(tile,Object);
					}
					column++;
				}
				rowStart += widthInTiles;
				row++;
			}
			return results;
		}
		
		public function setSlopeClasses(Classes:Array):void
		{
			_slopeClasses = Classes;
		}
		
		/**
		 * bounds the slope point to the slope
		 * @param slope the slope to fix the slopePoint for
		 */
		final private function fixSlopePoint(slope:FlxTile):void
		{
			_slopePoint.x = FlxU.bound(_slopePoint.x, slope.x, slope.x + _tileWidth);
			_slopePoint.y = FlxU.bound(_slopePoint.y, slope.y, slope.y + _tileHeight);
		}

		/**
		 * is called if an object collides with a floor slope
		 * @param slope the floor slope
		 * @param obj the object that collides with that slope
		 */
		protected function onCollideFloorSlope(slope:FlxTile, obj:FlxObject):void
		{
			//set the object's touching flag
			obj.touching = FLOOR;

			//adjust the object's velocity
			obj.velocity.y = 0;

			//reposition the object
			obj.y = _slopePoint.y - obj.height;
			if (obj.y < slope.y - obj.height) { obj.y = slope.y - obj.height };
		}

		/**
		 * is called if an object collides with a ceiling slope
		 * @param slope the ceiling slope
		 * @param obj the object that collides with that slope
		 */
		protected function onCollideCeilSlope(slope:FlxTile, obj:FlxObject):void
		{
			//set the object's touching flag
			obj.touching = CEILING;

			//adjust the object's velocity
			obj.velocity.y = 0;

			//reposition the object
			obj.y = _slopePoint.y;
			if (obj.y > slope.y + _tileHeight) { obj.y = slope.y + _tileHeight };
		}

		/**
		 * solves collision against a left-sided floor slope
		 * @param slope the slope to check against
		 * @param obj the object that collides with the slope
		 */
		final private function solveCollisionSlopeFloorLeft(slope:FlxTile, obj:FlxObject):void
		{
			if (_slopeClasses.indexOf(FlxU.getClassName(obj, true)) != -1)
			{
				
				//calculate the corner point of the object
				_objPoint.x = FlxU.floor(obj.x + obj.width + _snapping);
				_objPoint.y = FlxU.floor(obj.y + obj.height);

				//calculate position of the point on the slope that the object might overlap
				//this would be one side of the object projected onto the slope's surface
				_slopePoint.x = _objPoint.x;
				_slopePoint.y = (slope.y + _tileHeight) - (_slopePoint.x - slope.x);

				//fix the slope point to the slope tile
				fixSlopePoint(slope);

				//check if the object is inside the slope
				if (_objPoint.x > slope.x + _snapping
					&& _objPoint.x < slope.x + _tileWidth + obj.width + _snapping
					&& _objPoint.y >= _slopePoint.y
					&& _objPoint.y <= slope.y + _tileHeight)
				{
					//call the collide function for the floor slope

					onCollideFloorSlope(slope, obj);
				}
			}
		}

		/**
		 * solves collision against a right-sided floor slope
		 * @param slope the slope to check against
		 * @param obj the object that collides with the slope
		 */
		final private function solveCollisionSlopeFloorRight(slope:FlxTile, obj:FlxObject):void
		{
			if (_slopeClasses.indexOf(FlxU.getClassName(obj, true)) != -1)
			{
				//calculate the corner point of the object
				_objPoint.x = FlxU.floor(obj.x - _snapping);
				_objPoint.y = FlxU.floor(obj.y + obj.height);

				//calculate position of the point on the slope that the object might overlap
				//this would be one side of the object projected onto the slope's surface
				_slopePoint.x = _objPoint.x;
				_slopePoint.y = (slope.y + _tileHeight) - (slope.x - _slopePoint.x + _tileWidth);

				//fix the slope point to the slope tile
				fixSlopePoint(slope);

				//check if the object is inside the slope
				if (_objPoint.x > slope.x - obj.width - _snapping
					&& _objPoint.x < slope.x + _tileWidth + _snapping
					&& _objPoint.y >= _slopePoint.y
					&& _objPoint.y <= slope.y + _tileHeight)
				{
					//call the collide function for the floor slope
					onCollideFloorSlope(slope, obj);
				}
			}
		}

		/**
		 * solves collision against a left-sided ceiling slope
		 * @param slope the slope to check against
		 * @param obj the object that collides with the slope
		 */
		final private function solveCollisionSlopeCeilLeft(slope:FlxTile, obj:FlxObject):void
		{
			//calculate the corner point of the object
			_objPoint.x = FlxU.floor(obj.x + obj.width + _snapping);
			_objPoint.y = FlxU.ceil(obj.y);

			//calculate position of the point on the slope that the object might overlap
			//this would be one side of the object projected onto the slope's surface
			_slopePoint.x = _objPoint.x;
			_slopePoint.y = (slope.y) + (_slopePoint.x - slope.x);

			//fix the slope point to the slope tile
			fixSlopePoint(slope);

			//check if the object is inside the slope
			if (_objPoint.x > slope.x + _snapping
				&& _objPoint.x < slope.x + _tileWidth + obj.width + _snapping
				&& _objPoint.y <= _slopePoint.y
				&& _objPoint.y >= slope.y)
			{
				//call the collide function for the floor slope
				onCollideCeilSlope(slope, obj);
			}
		}

		/**
		 * solves collision against a right-sided ceiling slope
		 * @param slope the slope to check against
		 * @param obj the object that collides with the slope
		 */
		final private function solveCollisionSlopeCeilRight(slope:FlxTile, obj:FlxObject):void
		{
			//calculate the corner point of the object
			_objPoint.x = FlxU.floor(obj.x - _snapping);
			_objPoint.y = FlxU.ceil(obj.y);

			//calculate position of the point on the slope that the object might overlap
			//this would be one side of the object projected onto the slope's surface
			_slopePoint.x = _objPoint.x;
			_slopePoint.y = (slope.y) + (slope.x - _slopePoint.x + _tileWidth);

			//fix the slope point to the slope tile
			fixSlopePoint(slope);

			//check if the object is inside the slope
			if (_objPoint.x > slope.x - obj.width - _snapping
				&& _objPoint.x < slope.x + _tileWidth + _snapping
				&& _objPoint.y <= _slopePoint.y
				&& _objPoint.y >= slope.y)
			{
				//call the collide function for the floor slope
				onCollideCeilSlope(slope, obj);
			}
		}

		/**
		 * Sets the tiles that are treated as "clouds" or blocks that are only solid from the top.
		 * @param An array containing the numbers of the tiles to be treated as clouds.
		 * 
		 */
		public function setClouds(clouds:Array = null):void
		{
			if (clouds)
			{
				var i:uint;

				for (i=0; i<clouds.length; i++)
					setTileProperties(clouds[i], CEILING);			

			}
		}



		/**
		 * Sets the slope arrays, which define which tiles are treated as slopes.
		 * @param An array containing the numbers of the tiles to be treated as left floor slopes.
		 * @param An array containing the numbers of the tiles to be treated as right floor slopes.
		 * @param An array containing the numbers of the tiles to be treated as left ceiling slopes.
		 * @param An array containing the numbers of the tiles to be treated as right ceiling slopes.
		 */
		public function setSlopes(leftFloorSlopes:Array = null, rightFloorSlopes:Array = null, leftCeilSlopes:Array = null, rightCeilSlopes:Array = null):void
		{
			if (leftFloorSlopes)
				slopeFloorLeft = leftFloorSlopes;
			if (rightFloorSlopes)
				slopeFloorRight = rightFloorSlopes;
			if (leftCeilSlopes)
				slopeCeilLeft = leftCeilSlopes;
			if (rightCeilSlopes)
				slopeCeilRight = rightCeilSlopes;

			setSlopeProperties();
		}

		/**
		 * internal helper function for setting the tiles currently held in the slope arrays to use slope collision.
		 * Note that if you remove items from a slope, this function will not unset the slope property.
		 */
		protected function setSlopeProperties():void
		{

			var i:uint;

			for (i=0; i<slopeFloorLeft.length; i++)
				setTileProperties(slopeFloorLeft[i], RIGHT | FLOOR, solveCollisionSlopeFloorLeft);			
			for (i=0; i<slopeFloorRight.length; i++)
				setTileProperties(slopeFloorRight[i], LEFT | FLOOR, solveCollisionSlopeFloorRight);
			for (i=0; i<slopeCeilLeft.length; i++)
				setTileProperties(slopeCeilLeft[i], RIGHT | CEILING, solveCollisionSlopeCeilLeft);			
			for (i=0; i<slopeCeilRight.length; i++)
				setTileProperties(slopeCeilRight[i], LEFT | CEILING, solveCollisionSlopeCeilRight);

			//Test Values
			/*
				setTileProperties(7, RIGHT | FLOOR, solveCollisionSlopeFloorLeft);			
				setTileProperties(6, LEFT | FLOOR, solveCollisionSlopeFloorRight);
				setTileProperties(4, RIGHT | CEILING, solveCollisionSlopeCeilLeft);					
				setTileProperties(5, LEFT | CEILING, solveCollisionSlopeCeilRight);
			*/

		}
		
		/**
		 * internal helper function for comparing a tile to the slope arrays to see if a tile should be treated as a slope.
		 * @param The Tile Index number of the Tile you want to check.
		 * 
		 * @return Returns true if the tile is listed in one of the slope arrays.  Otherwise returns false.
		 */
		protected function checkArrays(tileIndex:uint):Boolean
		{
			var i:uint;

			for (i=0; i<slopeFloorLeft.length; i++)
			{
				if (slopeFloorLeft[i] == tileIndex)
					return true;
			}	
			for (i=0; i<slopeFloorRight.length; i++)
			{
				if (slopeFloorRight[i] == tileIndex)
					return true;
			}	
			for (i=0; i<slopeCeilLeft.length; i++)
			{
				if (slopeCeilLeft[i] == tileIndex)
					return true;
			}	
			for (i=0; i<slopeCeilRight.length; i++)
			{
				if (slopeCeilRight[i] == tileIndex)
					return true;
			}	

			return false;
		}
		
	}

}