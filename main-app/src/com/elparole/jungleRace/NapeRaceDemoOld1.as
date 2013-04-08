
/**
 * User: Elparole
 * Date: 11.02.13
 * Time: 00:37
 */
package com.elparole.jungleRace
{
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.getTimer;

import nape.geom.AABB;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.space.Space;
import nape.util.BitmapDebug;

import net.hires.Stats;


[SWF(width='640', height='960', frameRate='60', backgroundColor='#ffffff')]
public class NapeRaceDemoOld1 extends Sprite
{
	private var cbc:CubicBezierConverter;
	private var cd:CurveDrawer;
	private var trackBD1:BitmapData = new BitmapData(640,960,true,0);
	private var trackBD2:BitmapData = new BitmapData(640,960,true,0);

	private var terrain1:Terrain;
	private var terrain2:Terrain;
	private var bomb:Sprite;
	private var space:Space;
	private var debug:BitmapDebug;
	private var skinSprite1:Sprite = new Sprite();
	private var skinSprite2:Sprite = new Sprite();
	private var ballSprite:Sprite = new Sprite();
	private var speedUp:Boolean = false;
	private var terrainPos:int= 0;

	private var currentImpulse:Vec2= Vec2.weak(0,-1000);
	private var _lastLeft:Point;
	private var _lastRight:Point;

	private var _rect:Rectangle;


	public function NapeRaceDemoOld1() {
		addEventListener(Event.ADDED_TO_STAGE, init)
	}

	private var _ball:Body = new Body(BodyType.DYNAMIC);
	private var ballPos:Point = new Point();
	private var invalidated:int = 0;
	private var gravity:int = 0;
	private var amp:int=14;
	var mat:Matrix
	private var scale:Number = 0.25;

	private var _bs:Sprite = new Sprite();
	private var th:Number = 160*9600;

	private function init(event:Event):void {


		addChild(_bs);
		stage.addChild(new Stats());
		_bs.y = -th;

		cd = new CurveDrawer();
		cd.density = th*5/960;
		cd.delta = 14;
		cd._w = 640;// stage.stageWidth;
		cd._h = th;// stage.stageHeight;

		cd.setFirstPoint(_lastLeft);
//		skinSprite1.scaleX = skinSprite1.scaleY = 1;
		cd.draw(_bs.graphics, 100, th,0,0);
		_lastLeft = cd.getLastPoint();

//		getDetailedCurve(100,960);
//		curvedPoints.reverse();
//
//		texturedLineRenderer.draw(this.graphics, boardBD, curvedPoints,136);

		cd.setFirstPoint(_lastRight);

		cd.draw(_bs.graphics, 540, th,0,0,false);

//		stage.addEventListener(Event.ENTER_FRAME, function(evt:Event){
//			_bs.y+=20;
//		})
//
//
//		return;

		_rect = new Rectangle(0,0,640*scale,960*scale);

		mat = new Matrix(1,0,0,1,0,0);
		mat.scale(scale, scale);

//		drawTrack(5,amp,0,1);

		addChild(skinSprite1);
		addChild(skinSprite2);
		addChild(ballSprite);
		drawTrack(5,amp,0,2);
		trackBD1.draw(skinSprite1,mat );


//		trackBD.fillRect(new Rectangle(400,0,200,960*2),0xff000000);//draw(skinSprite,mat);

		trackBD2.draw(skinSprite2,mat);
		skinSprite1.y = 0;
		skinSprite2.y = -960*scale;
		skinSprite1.alpha = 0.3;
		skinSprite2.alpha = 0.3;
		buidPhys();

		var circ:Circle = new Circle(32*scale);
		circ.material.rollingFriction = 0;
		circ.material.dynamicFriction= 0;
		circ.material.staticFriction= 0;

		_ball.shapes.add(circ);


		_ball.position.setxy(320*scale, 900*scale);

//		_ball.allowRotation = false;
		_ball.space = space;

		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUP);

	}

	private function onKeyUP(event:KeyboardEvent):void {
		speedUp = false;
		gravity= 0;
	}

	private function onKeyDown(event:KeyboardEvent):void {
		speedUp = true;
		switch(event.keyCode){
			case Keyboard.A:
				gravity=-1;
				break;
			case Keyboard.D:
				gravity=1;
				break;
		}
	}


	protected function buidPhys():void {
		var w:uint = 640*scale;
		var h:uint = stage.stageHeight;

//		createBorder();

		var gravityVec:Vec2 = Vec2.weak(600, 0);
		space = new Space(gravityVec);


		// Create a new BitmapDebug screen matching stage dimensions and
		// background colour.
		//   The Debug object itself is not a DisplayObject, we add its
		//   display property to the display list.
		debug = new BitmapDebug(stage.stageWidth, stage.stageHeight*2, stage.color);

//		addChild(debug.display);
		addChild(skinSprite1);
		addChild(skinSprite2);
		addChild(ballSprite);
		this.stage.frameRate = 60;

		// Initialise terrain bitmap.

		// Create initial terrain state, invalidating the whole screen.
		terrain1 = new Terrain(trackBD2, 90*scale, 15*scale);
		terrain1.invalidate(new AABB(0, 0, w, 960*scale), space,0);
		terrain2 = new Terrain(trackBD1, 90*scale, 15*scale);
		terrain2.invalidate(new AABB(0, 960*scale, w, 960*scale), space,0);

//		debug.clear();
//		debug.draw(space);
//		debug.flush();

		stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}

	private function enterFrameHandler(ev:Event):void {
		// Step forward in simulation by the required number of seconds.
		space.step(1 / stage.frameRate);
		if(_ball.velocity.y>-75){
//			trace('_ball.velocity.y',_ball.velocity.y);
			currentImpulse = Vec2.weak(0,-40*scale);
			_ball.applyImpulse(currentImpulse);
//			_ball.applyAngularImpulse(1500);
		}else if(_ball.velocity.y<-100){
			currentImpulse = Vec2.weak(0,-0.0005*scale*_ball.velocity.y);
			_ball.applyImpulse(currentImpulse);
		}

		if(gravity==-1){
			space.gravity.x =-1000*0.75-0.5*Math.abs(_ball.velocity.y);
		}else if(gravity == 0){
			space.gravity.x =0;
		}else if(gravity == 1){
			space.gravity.x =1000*0.75+0.5*Math.abs(_ball.velocity.y);
		}
		if(!debug.display.getBounds(debug.display).containsPoint(_ball.position.toPoint(ballPos))){
//			_ball.position.x = 320;
//			_ball.position.y = 480+960;
//			_ball.velocity.x = 0;
//			_ball.velocity.y = 0;
//			_ball.angularVel = 0;
//			terrain.invalidate(new AABB(0, 960, 640, 960), space);

		}
		if(_ball.position.y<960*scale*(-terrainPos)){
			trace('tp',terrainPos);
			if(terrainPos%2==1){
				terrain1.invalidate(new AABB(0, 0, 640*scale, 960*scale), space,_ball.position.y-960*scale);
				skinSprite1.graphics.clear();
				drawTrack(5,amp,0,1);
//				drawTrack(5,amp);
				trackBD1.fillRect(_rect,0);
//
				trackBD1.draw(skinSprite1,mat);
			}else{
				terrain2.invalidate(new AABB(0, 0, 640*scale, 960*scale), space,_ball.position.y-960*scale);
				skinSprite2.graphics.clear();
				drawTrack(5,amp,0,2);
//				drawTrack(5,amp);
				trackBD2.fillRect(_rect,0);
//
				trackBD2.draw(skinSprite2,mat);
//				drawTrack(7,5);
//				skinSprite1.graphics.clear();
//				drawTrack(5,amp,-960);
//				drawTrack(5,amp);
//				trackBD2.fillRect(_rect,0);
//
//				trackBD2.draw(skinSprite1,mat);


//				skinSprite.graphics.beginFill(0xffffff,1);
//				skinSprite.graphics.drawRect(0,-960,640,960*2);
//				skinSprite.graphics.endFill();
			}

			terrainPos++;

//			_ball.position.x = 320;
//			_ball.position.y = 480+960;
//			_ball.velocity.x = 0;
//			_ball.velocity.y = 0;
//			_ball.angularVel = 0;

//			addChild(skinSprite);
//			trackBD.draw(skinSprite);
		}

//		debug.display.y = 0;//480 -_ball.position.y;//-960;
		ballSprite.graphics.clear();
		ballSprite.graphics.beginFill(0xff0000);
		ballSprite.graphics.drawCircle(_ball.position.x/scale,780, 32);
		ballSprite.graphics.endFill();
		skinSprite1.y = (300-420-_ball.position.y/scale+900-Math.floor(terrainPos+((terrainPos+1)%2))*960);
		skinSprite2.y = (300-420-_ball.position.y/scale+900-Math.floor(terrainPos+((terrainPos)%2))*960);

//		skinSprite.y = debug.display.y-960;

//		_ball.velocity.y = Math.max(_ball.velocity.y,-25);
//		_ball.velocity.y = Math.max(_ball.velocity.y,-25);
//		_ball.velocity = _ball.velocity;
//		debug.clear();
//		debug.draw(space);
//		debug.flush();
	}

	private function drawTrack(den:int = 7, delta:int = 12, offsety:int = 0, spriteId:int= 1):void {
		trace('draw track');
		var t:int = getTimer();
//		cbc = new CubicBezierConverter();
		cd = new CurveDrawer();
		cd.density = den;
		cd.delta = delta;
		cd._w = 640;// stage.stageWidth;
		cd._h = 960;// stage.stageHeight;

		cd.setFirstPoint(_lastLeft);
//		skinSprite1.scaleX = skinSprite1.scaleY = 1;
		cd.draw(spriteId==1? skinSprite1.graphics:skinSprite2.graphics, 100, 960,0,offsety);
		_lastLeft = cd.getLastPoint();

//		getDetailedCurve(100,960);
//		curvedPoints.reverse();
//
//		texturedLineRenderer.draw(this.graphics, boardBD, curvedPoints,136);

		cd.setFirstPoint(_lastRight);
		cd.draw(spriteId==1? skinSprite1.graphics:skinSprite2.graphics, 540, 960,0,offsety, false);
		_lastRight = cd.getLastPoint();
//		skinSprite1.scaleX = skinSprite1.scaleY = scale;
		trace('draw track time',getTimer()-t);

	}
}
}
