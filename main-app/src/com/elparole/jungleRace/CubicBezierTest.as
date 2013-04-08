package com.elparole.jungleRace{

import flash.display.Sprite;
import flash.geom.Point;


class CubicBezierTest extends Sprite {

	private var cx = 150;
	private var cy = 100;
	private var ax = 200;
	private var ay = 0;
	private var sx = 0;
	private var sy = 0;

	public var iterations = 5;

	public function CubicBezierTest() {
		drawFlPoints();
		drawCalcPoints();
		drawPoints();
		//iterPath
	}

	/**
	 * draws flash bezier example
	 */
	public function drawFlPoints():void {
		graphics.lineStyle(1, 0, 1);
		graphics.curveTo(150, 100, 200, 0);
	}


	public function iterPath(sx, sy, arr1:Array):Array {
		var i:int = 0;
		var arr2:Array = [];

		arr2.concat(getIterPts(sx, sy,
				arr1[0].x, arr1[0].y,
				(arr1[1].x + arr1[0].x) / 2,
				(arr1[1].y + arr1[0].y) / 2 ));

		for (var i:int = 1; i < arr1.length-1; i++) {
			arr2.concat(getIterPts((arr1[i - 1].x + arr1[i].x) / 2,
					(arr1[i - 1].y + arr1[i].y) / 2,
					arr1[i].x, arr1[i].y,
					(arr1[i + 1].x + arr1[i].x) / 2,
					(arr1[i + 1].y + arr1[i].y) / 2 ));
		}

		arr2.concat(getIterPts(sx, sy,
				arr1[i].x, arr1[i].y,
				(arr1[i + 1].x + arr1[i].x) / 2,
				(arr1[i + 1].y + arr1[i].y) / 2 ));
		return arr2;
	}

	public function getIterPts(sx:Number,sy:Number,cx:Number, cy:Number, ax:Number, ay:Number):Array {
		var arr:Array = [];
		for (var i:int = 0; i < iterations; i++) {
			var c1x = sx + (cx - sx) / iterations * i;
			var c1y = sy + (cy - sy) / iterations * i;
			graphics.beginFill(0x00ff00, 0.5);
			//graphics.drawCircle(c1x, c1y, 2);
			graphics.endFill();

			var a1x = cx + (ax - cx) / iterations * i;
			var a1y = cy + (ay - cy) / iterations * i;
			graphics.beginFill(0x000ff0, 0.5);
			//graphics.drawCircle(a1x, a1y, 2);
			graphics.endFill();

			arr.push(new Point( c1x + (a1x - c1x) / iterations * i, c1y + (a1y - c1y) / iterations * i ));
		}
		return arr;
	}

	/**
	 *
	 */
	public function drawCalcPoints():void{//sx:Number,sy:Number,cx:Number, cy:Number, ax:Number, ay:Number):Array {
		for (var i:int = 0; i < iterations+1; i++) {
			var c1x = sx + (cx - sx) / iterations * i;
			var c1y = sy + (cy - sy) / iterations * i;
			//graphics.beginFill(0x00ff00, 0.5);
			//graphics.drawCircle(c1x, c1y, 2);
			//graphics.endFill();

			var a1x = cx + (ax - cx) / iterations * i;
			var a1y = cy + (ay - cy) / iterations * i;
			//graphics.beginFill(0x000ff0, 0.5);
			//graphics.drawCircle(a1x, a1y, 2);
			//graphics.endFill();

			var bx = c1x + (a1x - c1x) / iterations * i;
			var by = c1y + (a1y - c1y) / iterations * i;
			graphics.beginFill(0x0000ff, 0.5);
			graphics.drawCircle(bx, by, 2);
			graphics.endFill();
		}
	}

	/**
	 * draws control points
	 */
	public function drawPoints():void {
		graphics.beginFill(0xff0000, 0.8);
		graphics.drawCircle(0, 0, 10);
		graphics.drawCircle(150, 100, 3);
		graphics.drawCircle(200, 0, 3);
		graphics.endFill();
	}


}
}