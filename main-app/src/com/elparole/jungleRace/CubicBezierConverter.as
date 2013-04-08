/**
 * User: Elparole
 * Date: 23.01.13
 * Time: 00:23
 */
package com.elparole.jungleRace{

import flash.display.Sprite;
import flash.geom.Point;


public class CubicBezierConverter extends Sprite {

	private var cx:Number = 150;
	private var cy:Number = 100;
	private var ax:Number = 200;
	private var ay:Number = 0;
	private var sx:Number = 0;
	private var sy:Number = 0;


	//private var cx:Number = 350;
	//private var cy:Number = 100;
	//private var ax:Number = 400;
	//private var ay:Number = 0;
	//private var sx:Number = 200;
	//private var sy:Number = 0;

	public var iterations = 20;

	public function CubicBezierConverter() {

		drawFlPoints();
		drawCalcPoints();
		drawPoints();
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

		for (var i:int = 1; i < arr1.length; i++) {
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
		for (var i:int = 0; i < iterations; i++) {
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
			//graphics.beginFill(0x0000ff, 0.5);
			//graphics.drawCircle(bx, by, 2);
			//graphics.endFill();
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

	public function convertToDouble(arr:Array, delta:int):Array {
		var arr2:Array = convertToSingle(arr);
		var arr3:Array = [];

		for (var i:int = 0;i<arr2.length-2;i++) {

			var xd:Number = arr2[i + 2].x - arr2[i].x;
			var yd:Number = arr2[i + 2].y - arr2[i].y;

			var l:Number = Math.sqrt(Math.pow(xd, 2) + Math.pow(yd, 2));

			var xa:Number = arr2[i + 1].x;
			var ya:Number = arr2[i + 1].y;

			var y2:Number = ya + delta*xd / l;
			var x2:Number = xa - delta*yd / l;

			arr3.push(new Point((x2), (y2)));
			arr3.push(new Point((arr2[i+1].x), (arr2[i+1].y)));
		}
		return arr3;
	}


	public function convertToSingle(arr:Array):Array {
		var arr2:Array = [];
		var j = 0;
//		((arr.length-1)/2)
		for (var j:int = 0;j<((arr.length-1)/2);j++) {
			sx = arr[j * 2].x;
			sy = arr[j * 2].y;
			cx = arr[j * 2+1].x;
			cy = arr[j * 2+1].y;
			ax = arr[j * 2+2].x;
			ay = arr[j * 2+2].y;

			for (var i:int = 1; i < iterations+1; i++) {
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
				arr2.push(new Point(bx, by));
				//graphics.beginFill(0x0000ff, 0.5);
				//graphics.drawCircle(bx, by, 2);
				//graphics.endFill();
			}

			//cx = 350;
			//cy = 100;
			//ax = 400;
			//ay = 0;
			//sx = 200;
			//sy = 0;
			//j = 1;

			//sx = arr[3].x;
			//sy = arr[3].y;			
			//cx = arr[4].x;
			//cy = arr[4].y;
			//ax = arr[5].x;
			//ay = arr[5].y;

			//for(i in 0...iterations+1){
			//var c1x = sx + (cx - sx) / iterations * i;
			//var c1y = sy + (cy - sy) / iterations * i;
			//graphics.beginFill(0x00ff00, 0.5);
			//graphics.drawCircle(c1x, c1y, 2);
			//graphics.endFill();
			//
			//var a1x = cx + (ax - cx) / iterations * i;
			//var a1y = cy + (ay - cy) / iterations * i;
			//graphics.beginFill(0x000ff0, 0.5);
			//graphics.drawCircle(a1x, a1y, 2);
			//graphics.endFill();
			//
			//var bx = c1x + (a1x - c1x) / iterations * i;
			//var by = c1y + (a1y - c1y) / iterations * i;
			//arr2.push(new Point(bx, by));
			//graphics.beginFill(0x0000ff, 0.5);
			//graphics.drawCircle(bx, by, 2);
			//graphics.endFill();
			//}
		}
		return arr2;
	}


}
}