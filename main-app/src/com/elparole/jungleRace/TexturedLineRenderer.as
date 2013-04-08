package com.elparole.jungleRace{
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;

/**
 * ...
 * @author lol
 */

public class TexturedLineRenderer
{

	private var _vertices:Vector.<Number>;

	private var _indices:Vector.<int>;

	private var _uvtData:Vector.<Number>;

	private var _image:BitmapData;
	private var partsNum:Number;
	private var dmat:Matrix;

	public function TexturedLineRenderer()
	{
		_vertices = new Vector.<Number>();

		_indices = new Vector.<int>();

		_uvtData = new Vector.<Number>();

		_image = new BitmapData(100,100,true,0xffff0000);

		dmat = new Matrix();
	}

	public function draw(graphics:Graphics, skin:BitmapData, points:Array, iterations:int = 0):void {
		_image = skin;

		_vertices = new Vector.<Number>();

		_indices = new Vector.<int>();

		_uvtData = new Vector.<Number>();
//		points = points.splice(200,300);
		//points = new Vector<Point>();

		//points = [];
		var i:int = 0;
		var n:int = 8;// Std.int(points.length / 2);

		var pts:Array = [];
		//for (j in 0...n * 2 - 1) {
//		for (var n:int = 1;n  < 3; n++) {
//			for (var j:int = 0; j < (points.length/2 - 4); j++) {
			for (var j:int = 0; j < iterations; j++) {
				i = j * 2;
				//top left
				pts.push(points[0]);
				pts.push(points[1]);
				pts.push(points[2]);
				pts.push(points[3]);
				points.shift();
				points.shift();
				//top right
				//points.push(new Point(skin.width,0));
				//bottom left
				//points.push(new Point(0,skin.height));
				//bottom right
				//points.push(new Point(skin.width,skin.height));

				var pl:int = pts.length;

				_vertices.push(pts[pl - 4].x);
				_vertices.push(pts[pl - 4].y);
				_vertices.push(pts[pl - 3].x);
				_vertices.push(pts[pl - 3].y);
				_vertices.push(pts[pl - 2].x);
				_vertices.push(pts[pl - 2].y);
				_vertices.push(pts[pl - 1].x);
				_vertices.push(pts[pl - 1].y);

				_indices.push(i * 2 + 1);
				_indices.push(i * 2);
				_indices.push(i * 2 + 2);
				_indices.push(i * 2 + 1);
				_indices.push(i * 2 + 2);
				_indices.push(i*2+3);

				//_uvtData = [0, i/n, 1, i/n, 0,(i+1)/n,1, (i + 1) / n];
				var k:int = j%n;
				_uvtData.push(0);
				_uvtData.push((k)/n);
				_uvtData.push(1);
				_uvtData.push((k)/n);
				_uvtData.push(0);
				_uvtData.push((k+1)/n);
				_uvtData.push(1);
				_uvtData.push( (k + 1) / n);
			}
//		}

			graphics.beginBitmapFill(_image);
			graphics.drawTriangles(_vertices, _indices, _uvtData);
			//graphics.drawRect(100, 100, 100, 100);
			graphics.endFill();



	}

	//private function initTriangles(n:Number, bd:BitmapData):void {
	//
	//this.partsNum = n;
	//points.length = 0;
	//_uvtData.length = 0;
	//_indices.length = 0;
	//_vertices.length = 0;
	//
	//for (var i:int = 0; i < n*2-1; i++) {
	//top left
	//points.push(new Point(0,bd.height/n*i));
	//top right
	//points.push(new Point(bd.width,bd.height/n*i));
	//bottom left
	//points.push(new Point(0,bd.height/n*(i+1)));
	//bottom right
	//points.push(new Point(bd.width,bd.height/n*(i+1)));
//
	//var pl:int = points.length;
//
	//_vertices.push(points[pl-4].x, points[pl-4].y);
	//_vertices.push(points[pl-3].x, points[pl-3].y);
	//_vertices.push(points[pl-2].x, points[pl-2].y);
	//_vertices.push(points[pl-1].x, points[pl-1].y);
//
	//_indices.push(i*2+1, i*2, i*2+2);
	//_indices.push(i*2+1, i*2+2, i*2+3);
//
	//_uvtData.push(0, i/n);
	//_uvtData.push(1, i/n);
	//_uvtData.push(0,(i+1)/n);
	//_uvtData.push(1,(i+1)/n);
	//}
	//}

	public function update():void {

//		_vertices[0]=startLT.x;_vertices[1]=startLT.y;
//		_vertices[2]=startRT.x;_vertices[3]=startRT.y;
//		_vertices[4]=startLB.x;_vertices[5]=startLB.y;
//		_vertices[6]=startRB.x;_vertices[7]=startRB.y;
//		_vertices[8]=startRB.x;_vertices[9]=startRB.y;
//		_vertices[10]=endLT.x;_vertices[11]=endLT.y;
//		_vertices[12]=endRT.x;_vertices[13]=endRT.y;
//		_vertices[14]=endLB.x;_vertices[15]=endLB.y;

		//graphics.clear();
//		graphics.lineStyle(1, 0xFF0000);
		//graphics.beginBitmapFill(_image);
		//graphics.drawTriangles(_vertices, _indices, _uvtData);
		//graphics.endFill();

	}


}
}