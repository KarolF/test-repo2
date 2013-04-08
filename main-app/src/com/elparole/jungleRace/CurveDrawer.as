package com.elparole.jungleRace{
import flash.display.Graphics;
import flash.geom.Point;


/**
 * ...
 * @author lol
 */

class CurveDrawer
{

	public var density:int;
	public var delta:Number;
	public var _w:Number;
	public var _h:Number;

	public var isNegative:Boolean = false;

	private var startX:Number;
	private var startY:Number;
	public var controlPts:Array;
	private var startPoint:Point;

	public function draw(graphics:Graphics,
	                     sx:Number,
	                     sy:Number,
	                     ex:Number = 0,
	                     ey:Number = 0,
	                     randDelta = 0,
	                     isLeft:Boolean = true):void {

		startX = sx;
		startY = sy;

		controlPts = [];

		graphics.beginFill(0, 1);
		graphics.moveTo(sx, sy+ey);
		for (var i:int = 0; i < density; i++) {
			controlPts.push(
					new Point(
							sx + (isNegative? -1:1)*randelta(),
							sy - i * sy / density+Math.random()*randDelta-randDelta/2+ey));
			if(i == 0 && startPoint){
				controlPts[controlPts.length-1].x = startPoint.x;
				isNegative = startPoint.x>sx? 1:-1;
			}else
			isNegative = !isNegative;
		}

		var cpt1:Point = null;
		var cpt2:Point = null;

		for (var i:int = 0; i < controlPts.length-1; i++) {
			cpt1 = controlPts[i];
			cpt2 = controlPts[i+1];
			graphics.curveTo(cpt1.x, cpt1.y, (cpt2.x + cpt1.x) / 2, (cpt2.y + cpt1.y) / 2);
		}

		graphics.curveTo(cpt2.x, cpt2.y, sx,ey);
		graphics.lineTo(isLeft? 0:_w,ey);
		graphics.lineTo(isLeft? 0:_w, startY+ey);
		graphics.endFill();
	}

	private function randelta():int
	{
		return Math.round(Math.random() * delta*10);
	}

	public function getLastPoint():Point {
		return controlPts[controlPts.length-1];
	}

	public function setFirstPoint(sp:Point):void {
		startPoint = sp;
	}
}
}