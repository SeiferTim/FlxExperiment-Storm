/**
 * Bullet
 * -- Part of the Flixel Power Tools set
 * 
 * v1.2 Removed "id" and used the FlxSprite ID value instead
 * v1.1 Updated to support fire callbacks, sounds, random variances and lifespan
 * v1.0 First release
 * 
 * @version 1.2 - October 10th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm.BaseTypes 
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import flash.utils.getTimer;

	public class Bullet extends FlxSprite
	{
		protected var weapon:FlxWeapon;
		
		protected var bulletSpeed:int;
		
		//	Acceleration or Velocity?
		public var accelerates:Boolean;
		public var xAcceleration:int;
		public var yAcceleration:int;
		
		public var rndFactorAngle:uint;
		public var rndFactorSpeed:uint;
		public var rndFactorLifeSpan:uint;
		public var lifespan:uint;
		public var launchTime:uint;
		public var expiresTime:uint;
		
		protected var animated:Boolean;
		
		public function Bullet(weapon:FlxWeapon, id:uint)
		{
			super(0, 0);
			
			this.weapon = weapon;
			this.ID = id;
			
			//	Safe defaults
			accelerates = false;
			animated = false;
			bulletSpeed = 0;
			
			exists = false;
			alive = false;
		}
		
		public function get weaponName():String
		{
			return weapon.name;
		}
		
		/**
		 * Adds a new animation to the sprite.
		 * 
		 * @param	Name		What this animation should be called (e.g. "run").
		 * @param	Frames		An array of numbers indicating what frames to play in what order (e.g. 1, 2, 3).
		 * @param	FrameRate	The speed in frames per second that the animation should play at (e.g. 40 fps).
		 * @param	Looped		Whether or not the animation is looped or just plays once.
		 */
		override public function addAnimation(Name:String, Frames:Array, FrameRate:Number = 0, Looped:Boolean = true):void
		{
			super.addAnimation(Name, Frames, FrameRate, Looped);
			
			animated = true;
		}
		
		public function fire(fromX:Number, fromY:Number, velX:Number, velY:Number):void
		{
			
			last.x = x = fromX + FlxMath.rand( -weapon.rndFactorPosition.x, weapon.rndFactorPosition.x);
			last.y = y = fromY + FlxMath.rand( -weapon.rndFactorPosition.y, weapon.rndFactorPosition.y);
			
			if (accelerates)
			{
				acceleration.x = xAcceleration + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed);
				acceleration.y = yAcceleration + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed);
			}
			else
			{
				velocity.x = velX + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed);
				velocity.y = velY + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed);
			}
			
			postFire();
		}
		
		public function fireAtMouse(fromX:Number, fromY:Number, speed:int):void
		{
			last.x = x = fromX + FlxMath.rand( -weapon.rndFactorPosition.x, weapon.rndFactorPosition.x);
			last.y = y = fromY + FlxMath.rand( -weapon.rndFactorPosition.y, weapon.rndFactorPosition.y);
			
			if (accelerates)
			{
				FlxVelocity.accelerateTowardsMouse(this, speed + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed), maxVelocity.x, maxVelocity.y);
			}
			else
			{
				FlxVelocity.moveTowardsMouse(this, speed + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed));
			}
			
			postFire();
		}
		
		public function fireAtPosition(fromX:Number, fromY:Number, toX:Number, toY:Number, speed:int):void
		{
			last.x = x = fromX + FlxMath.rand( -weapon.rndFactorPosition.x, weapon.rndFactorPosition.x);
			last.y = y = fromY + FlxMath.rand( -weapon.rndFactorPosition.y, weapon.rndFactorPosition.y);
			
			if (accelerates)
			{
				FlxVelocity.accelerateTowardsPoint(this, new FlxPoint(toX, toY), speed + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed), maxVelocity.x, maxVelocity.y);
			}
			else
			{
				FlxVelocity.moveTowardsPoint(this, new FlxPoint(toX, toY), speed + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed));
			}
			
			postFire();
		}
		
		public function fireAtTarget(fromX:Number, fromY:Number, target:FlxSprite, speed:int):void
		{
			last.x = x = fromX + FlxMath.rand( -weapon.rndFactorPosition.x, weapon.rndFactorPosition.x);
			last.y = y = fromY + FlxMath.rand( -weapon.rndFactorPosition.y, weapon.rndFactorPosition.y);
			
			if (accelerates)
			{
				FlxVelocity.accelerateTowardsObject(this, target, speed + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed), maxVelocity.x, maxVelocity.y);
			}
			else
			{
				FlxVelocity.moveTowardsObject(this, target, speed + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed));
			}
			
			postFire();
		}
		
		public function fireFromAngle(fromX:Number, fromY:Number, fireAngle:int, speed:int):void
		{
			last.x = x = fromX + FlxMath.rand( -weapon.rndFactorPosition.x, weapon.rndFactorPosition.x);
			last.y = y = fromY + FlxMath.rand( -weapon.rndFactorPosition.y, weapon.rndFactorPosition.y);
			touching = FlxObject.NONE;
			var newVelocity:FlxPoint = FlxVelocity.velocityFromAngle(fireAngle + FlxMath.rand( -weapon.rndFactorAngle, weapon.rndFactorAngle), speed + FlxMath.rand( -weapon.rndFactorSpeed, weapon.rndFactorSpeed));
			if (weapon.rotateToAngle)
				angle = fireAngle;
			if (accelerates)
			{
				acceleration.x = newVelocity.x;
				acceleration.y = newVelocity.y;
			}
			else
			{
				velocity.x = newVelocity.x;
				velocity.y = newVelocity.y;
			}
			
			postFire();
		}
		
		private function postFire():void
		{
			if (animated)
			{
				play("fire");
			}
			
			if (weapon.bulletElasticity > 0)
			{
				elasticity = weapon.bulletElasticity;
			}
			
			exists = true;
			alive = true;
			
			launchTime = getTimer();
			
			if (weapon.bulletLifeSpan > 0)
			{
				lifespan = weapon.bulletLifeSpan + FlxMath.rand( -weapon.rndFactorLifeSpan, weapon.rndFactorLifeSpan);
				expiresTime = getTimer() + lifespan;
				
			}
			
			if (weapon.onFireCallback is Function)
			{
				weapon.onFireCallback.apply(null, [this]);
			}
			
			if (weapon.onFireSound)
			{
				weapon.onFireSound.play();
			}
		}
		
		public function set xGravity(gx:int):void
		{
			acceleration.x = gx;
		}
		
		public function set yGravity(gy:int):void
		{
			acceleration.y = gy;
		}
		
		public function set maxVelocityX(mx:Number):void
		{
			maxVelocity.x = mx;
		}
		
		public function set maxVelocityY(my:Number):void
		{
			maxVelocity.y = my;
		}
		
		override public function update():void
		{
			if (lifespan > 0 && getTimer() > expiresTime)
			{
				kill();
			}
			
			if (FlxMath.pointInFlxRect(x, y, weapon.bounds) == false)
			{
				kill();
			}
		}
		
		override public function kill():void
		{
			if (weapon.onDeathCallback is Function && FlxMath.pointInFlxRect(x, y, weapon.bounds) && exists && visible)
				weapon.onDeathCallback.apply(null, [this, weapon.name]);
			super.kill();
		}
		
	}

}