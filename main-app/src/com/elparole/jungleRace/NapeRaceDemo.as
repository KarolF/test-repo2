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
public class NapeRaceDemo extends Sprite
{
	private var cbc:CubicBezierConverter;
	private var cd:CurveDrawer;
	private var trackBDs:Array = [];
	private var trackBD1:BitmapData;
	private var trackBD2:BitmapData;

	private var terrains:Array = [];
	private var terrain1:Terrain;
	private var terrain2:Terrain;
	private var bomb:Sprite;
	private var space:Space;
	private var debug:BitmapDebug;
	private var ballSprite:Sprite = new Sprite();
	private var speedUp:Boolean = false;
	private var terrainPos:int= 0;
	private var terrainSubPos:int= -1;

	private var currentImpulse:Vec2= Vec2.weak(0,-1000);
	private var _lastLeft:Point;
	private var _lastRight:Point;

	private var _rect:Rectangle;
	private const screenHeight:int = 960/10;


	public function NapeRaceDemo() {
		addEventListener(Event.ADDED_TO_STAGE, init)
	}

	private var _ball:Body = new Body(BodyType.DYNAMIC);
	private var ballPos:Point = new Point();
	private var invalidated:int = 0;
	private var gravity:int = 0;
	private var amp:int=14;
	var mat:Matrix
	private var scale:Number = 0.25;

	private var bs:Sprite = new Sprite();
	private var th:Number = 160*960;
	private var startBallPos:Number;
	private var queueParts:int = 3;

	private function init(event:Event):void {


		cd = new CurveDrawer();
		cd.density = th*5/960;
		cd.delta = 14;
		cd._w = 640;// stage.stageWidth;
		cd._h = th;// stage.stageHeight;

		cd.setFirstPoint(_lastLeft);
//		skinSprite1.scaleX = skinSprite1.scaleY = 1;
		cd.draw(bs.graphics, 100, th,0,0,150);
		_lastLeft = cd.getLastPoint();

		cd.setFirstPoint(_lastRight);

		cd.draw(bs.graphics, 540, th,0,0,150,false);

		stage.addChild(new Stats());
		bs.y = -th;

		for (var i:int = 0; i < queueParts; i++) {
			trackBDs.push(new BitmapData(640*scale,screenHeight*scale,true,0));
		}
//		trackBD1 = new BitmapData(640*scale,screenHeight*scale,true,0);
//		trackBD2 = new BitmapData(640*scale,screenHeight*scale,true,0);

		_rect = new Rectangle(0,0,640*scale,screenHeight*scale);

		mat = new Matrix(1,0,0,1,0,0);
		mat.ty = -th+screenHeight*2;
//		mat.ty = (-th+screenHeight)*scale;
//		mat.ty = 0;
		mat.scale(scale, scale);

//		drawTrack(5,amp,0,1);

		addChild(ballSprite);
//		drawTrack(5,amp,0,2);
//		trackBD1.draw(bs,mat );

//		trackBD.fillRect(new Rectangle(400,0,200,screenHeight*2),0xff000000);//draw(skinSprite,mat);

//		mat.ty = 0;
//		mat.ty = (-th+screenHeight*2)*scale;
		mat = new Matrix(1,0,0,1,0,0);
		mat.ty = -th+screenHeight;
		mat.scale(scale, scale);
//		trackBD2.draw(bs,mat);

		for (var i:int = 0; i < trackBDs.length; i++) {
			mat = new Matrix(1,0,0,1,0,0);
			mat.ty = -th+screenHeight*(i+1);
			mat.scale(scale, scale);
			trackBDs[i].draw(bs, mat);
		}

//		this.graphics.beginBitmapFill(trackBD1);
//		this.graphics.beginFill(0xff0000)
//		this.graphics.drawRect(0,0,640*scale, screenHeight*scale)
//		this.graphics.endFill();
//		this.graphics.beginBitmapFill(trackBD2);
//		this.graphics.drawRect(0,screenHeight*scale,640*scale, screenHeight*scale)
//		this.graphics.endFill();
//		return;

		bs.y = -th+960;
		bs.alpha = 0.3;
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
		addChild(bs);
		addChild(ballSprite);
		this.stage.frameRate = 60;

		// Initialise terrain bitmap.

		// Create initial terrain state, invalidating the whole screen.
//		terrain1 = new Terrain(trackBD2, 90*scale, 15*scale);
//		terrain1.invalidate(new AABB(0, 0, w, screenHeight*scale), space,0);
//		terrain2 = new Terrain(trackBD1, 90*scale, 15*scale);
//		terrain2.invalidate(new AABB(0, screenHeight*scale, w, screenHeight*scale), space,0);


//		for (var i:int = trackBDs.length-1; i >= 0; i--) {
//			var terrain:Terrain = new Terrain(trackBDs[i], 90*scale, 15*scale);
//			terrain.invalidate(new AABB(0, screenHeight*scale, w, screenHeight*scale), space,0);
//			terrains.unshift(terrain);
//		}
		for (var i:int = 0; i < trackBDs.length; i++) {
			var terrain:Terrain = new Terrain(trackBDs[i], 90*scale, 15*scale);
			terrain.invalidate(new AABB(0, screenHeight*scale, w, screenHeight*scale), space,0);
			terrains.push(terrain);
		}



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

		}
		if(_ball.position.y<screenHeight*scale*(-terrainPos)){
			trace('tp',terrainPos);

//			if(terrainPos%2==0){
				terrains[0].invalidate(new AABB(0, 0, 640*scale, screenHeight*scale), space,_ball.position.y-screenHeight*scale);
				trackBDs[0].fillRect(_rect,0);
				mat = new Matrix();
				mat.ty=-th+(terrainPos+3)*screenHeight;
				mat.scale(scale, scale);
//
//				trace('draw t1');
				trackBDs[0].draw(bs,mat);
//			}
//			}else if(terrainPos%3==2){
//				terrains[1].invalidate(new AABB(0, 0, 640*scale, screenHeight*scale), space,_ball.position.y-screenHeight*2*scale);
//				trackBDs[1].fillRect(_rect,0);
//				mat = new Matrix();
//				mat.ty=-th+(terrainPos+4)*screenHeight;
//				mat.scale(scale, scale);
//				trace('draw t2');
//				trackBDs[1].draw(bs,mat);
//			}
////			}else {
//				terrains[2].invalidate(new AABB(0, 0, 640*scale, screenHeight*scale), space,_ball.position.y-screenHeight*3*scale);
//				trackBDs[2].fillRect(_rect,0);
//				mat = new Matrix();
//				mat.ty=-th+(terrainPos+5)*screenHeight;
//				mat.scale(scale, scale);
//
//				trace('draw t0');
//				trackBDs[2].draw(bs,mat);
//			}

			terrainPos++;
		}
		ballSprite.graphics.clear();
		ballSprite.graphics.beginFill(0xff0000);
		ballSprite.graphics.drawCircle(_ball.position.x/scale,780, 32);
		ballSprite.graphics.endFill();
		bs.y = (300-420-_ball.position.y/scale+900)-th+screenHeight;
//		debug.clear();
//		debug.draw(space);
//		debug.flush();
	}
}
}
