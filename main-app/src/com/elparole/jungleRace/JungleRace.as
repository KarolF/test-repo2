package com.elparole.jungleRace{


import flash.display.BitmapData;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import net.hires.Stats;


/**
 * @author lol
 */

[SWF(width='640', height='960', frameRate='60', backgroundColor='#A29A77')]
public class JungleRace extends MovieClip {

	private var cd:CurveDrawer;
	private var pointsFactory:CornerPointsFactory;
	private var cb:CubicBezierTest;
	private var cbc:CubicBezierConverter;
	private var texturedLineRenderer:TexturedLineRenderer;
	private var curvedPoints:Array;
	private var boardBD:BitmapData;

	[Embed(source='../../../decha1.png')]
	private var board1:Class;
	private var iterations:int = 16;

	public function JungleRace() {

	
		//testPhys();
		//testBezier();
		//testBezierConverter();		
		testDrawBoard();
		//initialize ();
	
//	#if (flash9 || flash10)
//			haxe.Log.trace = function(v,?pos) { untyped __global__["trace"](pos.className+"#"+pos.methodName+"("+pos.lineNumber+"):",v); }
//	        #elseif flash
//		haxe.Log.trace = function(v,?pos) { flash.Lib.trace(pos.className+"#"+pos.methodName+"("+pos.lineNumber+"): "+v); }
//	        #end
//		trace( "YEAH!" );
	
	}

	public function testDrawBoard() {
//		boardBD = new BitmapData(100,100,true,0xffff0000);//Assets.getBitmapData("assets/decha1.png");
		boardBD = (new board1()).bitmapData;
		//this.graphics.beginBitmapFill(boardBD);
		//this.graphics.drawRect(0, 0, boardBD.width, boardBD.height);
		//this.graphics.endFill();

		texturedLineRenderer = new TexturedLineRenderer();
		var delt:Number = 200;
		getSamplePoints();

		//curvedPoints = curvedPoints.slice(0, 16);

		stage.addEventListener(MouseEvent.CLICK, onRedrawLine);

		//texturedLineRenderer.draw(this.graphics, boardBD, [	new Point(delt,delt),
		//new Point(delt+boardBD.width, delt),
		//new Point(delt, delt+boardBD.height),
		//new Point(delt+boardBD.width, delt+boardBD.height)]);


	}

	private function onRedrawLine(e:Event):void
	{

//		boardBD = Assets.getBitmapData("assets/decha2.png");
//		boardBD = new BitmapData(100,100,true,0xffff0000);//

		this.graphics.clear();

		getSamplePoints();

		//curvedPoints = curvedPoints.slice(0, 16);
		curvedPoints.reverse();

//		iterations+=4;

//		texturedLineRenderer.draw(this.graphics, boardBD, curvedPoints, 136);
	}

	public function testBezier()
	{
		cb = new CubicBezierTest();
		this.addChild(cb);
		cb.x = 100;
		cb.y = 100;
	}

	public function testBezierConverter()
	{

		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.addEventListener(MouseEvent.CLICK, onClick);

		getSamplePoints();
		//curvedPoints.length = 4;
		//curvedPoints = curvedPoints.slice(0, 16);
		//curvedPoints.reverse();

		drawCurvedPoints();

		//var curvedPoints:Array<Point> = cbc.convertToSingle([
		//new Point(0, 0),
		//new Point(150, 100), 
		//new Point(200, 0),
		//new Point(200, 0),
		//new Point(350, 100), 
		//new Point(400, 0) 
		//]);
		//trace(curvedPoints);

		//this.addChild(cb);
		//cb.x = 100;
		//cb.y = 100;
	}

	private function getSamplePoints(den:int = 7, delta:int = 12):void {
		cbc = new CubicBezierConverter();
		cd = new CurveDrawer();
		cd.density = den;
		cd.delta = delta;
		cd._w = 640;// stage.stageWidth;
		cd._h = 960;// stage.stageHeight;
		cd.draw(this.graphics, 100, 960,0,0);
		getDetailedCurve(100,960);
		curvedPoints.reverse();

		texturedLineRenderer.draw(this.graphics, boardBD, curvedPoints,136);

		cd.draw(this.graphics, 540, 960, 0,0,false);
		getDetailedCurve(540,960);
		curvedPoints.reverse();

		texturedLineRenderer.draw(this.graphics, boardBD, curvedPoints,136);


	}

	private function getDetailedCurve(px:int,py:int):void {
		curvedPoints = [];
		curvedPoints.push(new Point(px, py));
		//cd.controlPts.push(new Point(400, 0));

		for (var i:int = 0; i < cd.controlPts.length - 1; i++) {
			curvedPoints.push(cd.controlPts[i]);// cpt1.x, cpt1.y, (cpt2.x + cpt1.x) / 2, (cpt2.y + cpt1.y) / 2
			curvedPoints.push(new Point((cd.controlPts[i + 1].x + cd.controlPts[i].x) / 2,
					(cd.controlPts[i + 1].y + cd.controlPts[i].y) / 2));
		}

		curvedPoints.push(new Point(cd.controlPts[cd.controlPts.length - 1].x, cd.controlPts[cd.controlPts.length - 1].y));
		curvedPoints.push(new Point(px, 0));

		curvedPoints = cbc.convertToDouble(curvedPoints, 40);
	}

	private function drawCurvedPoints():void {
		for (var i:int = 0; i < curvedPoints.length; i++) {
			graphics.beginFill(0x0000ff, 0.5);
			graphics.drawCircle(curvedPoints[i].x, curvedPoints[i].y, 2);
			graphics.endFill();
			//haxe.Log.trace(Std.string(i) + Std.string(curvedPoints[i]));
		}
	}

	private function initialize ():void {

		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.addEventListener(MouseEvent.CLICK, onClick);
		cd = new CurveDrawer();
		cd.density = 10;
		cd.delta = 15;
		cd._w = 640;// stage.stageWidth;
		cd._h = 960;// stage.stageHeight;
		cd.draw(this.graphics, 100, 800,0,0);
		cd.draw(this.graphics, 400, 800,0,0, false);

		//var cornerPts:Array<Point> = ;

	}

	private function onClick(e:MouseEvent):void
	{
		//cd.density++;
		//cd.delta *= 0.75;
		this.graphics.clear();
		cd.draw(this.graphics, 100, 800);
		cd.draw(this.graphics, 400, 800,0,0,false);
	}

}
}