/**
 * User: Elparole
 * Date: 11.02.13
 * Time: 00:33
 */
package
{
import flash.display.BitmapData;
import flash.utils.getTimer;

import nape.geom.AABB;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;

import nape.geom.IsoFunction;
import nape.geom.MarchingSquares;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;

public class Terrain implements IsoFunction {
	public var bitmap:BitmapData;

	private var cellSize:Number;
	private var subSize:Number;

	private var width:int;
	private var height:int;
	private var cells:Array;

	private var isoBounds:AABB;
	public var isoGranularity:Vec2;
	public var isoQuality:int = 8;

	public function Terrain(bitmap:BitmapData, cellSize:Number, subSize:Number):void {
		this.bitmap = bitmap;
		this.cellSize = cellSize;
		this.subSize = subSize;

		cells = [];
		width = Math.ceil(bitmap.width / cellSize);
		height = Math.ceil(bitmap.height / cellSize);
		for (var i:int = 0; i < width*height; i++) {
			cells.push(null);
		}

		isoBounds = new AABB(0, 0, cellSize, cellSize);
		isoGranularity = Vec2.get(subSize, subSize);
	}

	public function  invalidate(region:AABB, space:Space, offsetY:int = 0):void {
		var t:int = getTimer();
		var t3:int = 0;
		// compute effected cells.
		var x0:int = int(region.min.x/cellSize); if(x0<0) x0 = 0;
		var y0:int = int(region.min.y/cellSize); if(y0<0) y0 = 0;
		var x1:int = int(region.max.x/cellSize); if(x1>= width) x1 = width-1;
		var y1:int = int(region.max.y/cellSize); if(y1>=height) y1 = height-1;

		trace('invalidate bounds',x0, y0, x1, y1);

		for each (var body:Body in cells) {
			if(body){
				body.space = null;
				body.shapes.clear();
			}
		}
		for (var i:int = 0; i < cells.length; i++) {
			cells[i]=null;

		}
		
		for (var y:int = y0; y <= y1; y++) {
			for (var x:int = x0; x <= x1; x++) {
				var b:Body = cells[y*width + x];
				if (b != null) {
					// If body exists, we'll simply re-use it.
					b.space = null;
					b.shapes.clear();
				}

				isoBounds.x = x*cellSize;
				isoBounds.y = y*cellSize;
				var polys:GeomPolyList = MarchingSquares.run(
						this,
						isoBounds,
						isoGranularity,
						isoQuality
				);
				if (polys.empty()) continue;

				if (b == null) {
					cells[y*width + x] = b = new Body(BodyType.STATIC,new Vec2(0,offsetY));
				}

				var t2:int=getTimer();
				for (var i:int = 0; i < polys.length; i++) {
					var p:GeomPoly = polys.at(i);
					var qolys:GeomPolyList = p.convexDecomposition(true);

					for (var j:int = 0; j < qolys.length; j++) {
						var q:GeomPoly = qolys.at(j);
						b.shapes.add(new Polygon(q));

						// Recycle GeomPoly and its vertices
						q.dispose();
					}

					// Recycle list nodes
					qolys.clear();

					// Recycle GeomPoly and its vertices
					p.dispose();
				}
				t3+=getTimer()-t2;

				// Recycle list nodes
				polys.clear();

				b.space = space;
//				b.position.y = offsetY;
			}
		}
		trace('invelidate time',getTimer()-t,'addshape time',t3);
	}

	//iso-function for terrain, computed as a linearly-interpolated
	//alpha threshold from bitmap.
	public function iso(x:Number,y:Number):Number {
		var ix:int = int(x); if(ix<0) ix = 0; else if(ix>=bitmap.width)  ix = bitmap.width -1;
		var iy:int = int(y); if(iy<0) iy = 0; else if(iy>=bitmap.height) iy = bitmap.height-1;
		var fx:Number = x - ix; if(fx<0) fx = 0; else if(fx>1) fx = 1;
		var fy:Number = y - iy; if(fy<0) fy = 0; else if(fy>1) fy = 1;
		var gx:Number = 1-fx;
		var gy:Number = 1-fy;

		var a00:int = bitmap.getPixel32(ix,iy)>>>24;
		var a01:int = bitmap.getPixel32(ix,iy+1)>>>24;
		var a10:int = bitmap.getPixel32(ix+1,iy)>>>24;
		var a11:int = bitmap.getPixel32(ix+1,iy+1)>>>24;

		var ret:Number = gx*gy*a00 + fx*gy*a10 + gx*fy*a01 + fx*fy*a11;
		return 0x80-ret;
	}
}
}
