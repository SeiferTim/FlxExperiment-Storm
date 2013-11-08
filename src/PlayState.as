package  
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	import net.tileisle.*;
	
	/**
	 * ...
	 * @author SeiferTim Hely
	 */
	public class PlayState extends FlxState
	{
		
		private var clouds:Vector.<CloudSection>;
		private var skylines:FlxGroup;
		private var ltngSections:Vector.<FlxGroup>;
		
		private var allRods:Vector.<FlxPoint>;
		
		
		public function PlayState() 
		{
			
			
		}
		
		override public function create():void
		{
			clouds = new Vector.<CloudSection>;
			ltngSections = new Vector.<FlxGroup>;
			allRods = new Vector.<FlxPoint>;
			
			var skl:Skyline;
			
			clouds.push(add(new CloudSection(9)));
			clouds.push(add(new CloudSection(8)));
			clouds.push(add(new CloudSection(7)));
			clouds.push(add(new CloudSection(6)));
			clouds.push(add(new CloudSection(5)));
			clouds.push(add(new CloudSection(4)));
			clouds.push(add(new CloudSection(3)));
			
			ltngSections.push(add(new FlxGroup()));
			clouds.push(add(new CloudSection(2)));
			
			skl = add(new Skyline(0)) as Skyline;
			for each(var rl:RodLight in skl.rods.members)
			{
				allRods.push(new FlxPoint(rl.x + 1, rl.y + 1));
			}
			ltngSections.push(add(new FlxGroup()));
			clouds.push(add(new CloudSection(1)));
			
			skl = add(new Skyline(1)) as Skyline;
			for each(rl in skl.rods.members)
			{
				allRods.push(new FlxPoint(rl.x + 1, rl.y + 1));
			}
			ltngSections.push(add(new FlxGroup()));
			clouds.push(add(new CloudSection(0)));
			
			skl = add(new Skyline(2)) as Skyline;
			for each(rl in skl.rods.members)
			{
				allRods.push(new FlxPoint(rl.x + 1, rl.y + 1));
			}
			
			skl = add(new Skyline(3)) as Skyline;
			for each(rl in skl.rods.members)
			{
				allRods.push(new FlxPoint(rl.x + 1, rl.y + 1));
			}
			
			skl = add(new Skyline(4)) as Skyline;
			for each(rl in skl.rods.members)
			{
				allRods.push(new FlxPoint(rl.x + 1, rl.y + 1));
			}
			
			skl = add(new Skyline(5)) as Skyline;
			for each(rl in skl.rods.members)
			{
				allRods.push(new FlxPoint(rl.x + 1, rl.y + 1));
			}
			ltngSections.push(add(new FlxGroup()));
			
			
			
			FlxG.flash(0xffffffff, FlxG.elapsed * 4);
			
			
			//var b:Bolt = ltngSections[0].recycle(Bolt) as Bolt;
			//b.launch(20, 20);
			//var b:Bolt = add(new Bolt()) as Bolt;
			//b.launch(allRods,SeedRnd.integer(-10,FlxG.width+10), -20);
			
		}
		
		override public function update():void
		{
			if (FlxG.keys.justReleased("ESCAPE"))
			{
				FlxG.switchState(new PlayState);
			}
			
			if (SeedRnd.boolean(0.02))
			{
				var whichLayer:uint = SeedRnd.integer(0, ltngSections.length);
				var bl:Bolt = ltngSections[whichLayer].recycle(Bolt) as Bolt;
				bl.launch(allRods, SeedRnd.integer( -10, FlxG.width + 10), clouds[whichLayer +6].ystart);
				FlxG.flash(0xffffffff, 0.33);
			}
			
			super.update();
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
	}

}