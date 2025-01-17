﻿package motion.actuators;

import motion.actuators.GenericActuator;
#if openfl
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.Lib;
#elseif js
import js.Browser;
#else
import haxe.Timer;
#end

@:access(motion.Actuate)
class SimpleActuator<T, U> extends GenericActuator<T> {
	#if actuate_manual_time
	public static var getTime:Void->Float;
	#end

	private var timeOffset:Float;

	private static var actuators = new Array<SimpleActuator<Dynamic, Dynamic>>();
	private static var actuatorsLength = 0;
	private static var addedEvent = false;

	#if (!openfl && !js)
	private static var timer:Timer;
	#end

	private var active:Bool;
	private var cacheVisible:Bool;
	private var detailsLength:Int;
	private var initialized:Bool;
	private var paused:Bool;
	private var pauseTime:Float;
	private var propertyDetails:Array<PropertyDetails<U>>;
	private var sendChange:Bool;
	private var setVisible:Bool;
	private var startTime:Float;
	private var toggleVisible:Bool;
	private var tweenPosition:Float;

	public function new(target:T, duration:Float, properties:Dynamic) {
		active = true;
		propertyDetails = new Array();
		sendChange = false;
		paused = false;
		cacheVisible = false;
		initialized = false;
		setVisible = false;
		toggleVisible = false;
		tweenPosition = 0;

		startTime = __getPlatformTime();

		super(target, duration, properties);

		if (!addedEvent) {
			addedEvent = true;
			#if !actuate_manual_update
			#if openfl
			Lib.current.stage.addEventListener(Event.ENTER_FRAME, stage_onEnterFrame);
			#elseif js
			Browser.window.requestAnimationFrame(stage_onEnterFrame);
			#else
			timer = new Timer(Std.int(1000 / 30));
			timer.run = stage_onEnterFrame;
			#end
			#end
		}
	}

	private static function __getPlatformTime():Float {
		#if !actuate_manual_time
		#if openfl
		return Lib.getTimer() / 1000;
		#elseif js
		return Browser.window.performance.now() / 1000;
		#else
		return Timer.stamp();
		#end
		#else
		return getTime();
		#end
	}

	/**
	 * @inheritDoc
	 */
	private override function apply() {
		super.apply();

		if (toggleVisible && Reflect.hasField(properties, "alpha")) {
			if (getField(target, "visible") != null) {
				setField(target, "visible", Reflect.field(properties, "alpha") > 0);
			}
		}
	}

	/**
	 * @inheritDoc
	 */
	public override function autoVisible(?value:Null<Bool>):GenericActuator<T> {
		if (value == null) {
			value = true;
		}

		_autoVisible = value;

		if (!value) {
			toggleVisible = false;

			if (setVisible) {
				setField(target, "visible", cacheVisible);
			}
		}

		return this;
	}

	/**
	 * @inheritDoc
	 */
	public override function delay(duration:Float):GenericActuator<T> {
		_delay = duration;
		timeOffset = startTime + duration;

		return this;
	}

	/**
	 * @inheritDoc
	 */
	public override function restart(includeDelay:Bool = false):GenericActuator<T> {
		super.restart(includeDelay);

		startTime = __getPlatformTime();
		timeOffset = startTime + (includeDelay ? _delay : 0);
		for (i in 0...detailsLength) {
			var details = propertyDetails[i];
			setProperty(details, details.start);
		}

		if (!active && actuators.indexOf(this) == -1) {
			actuators.push(this);
			++actuatorsLength;
		}

		active = true;

		Actuate.load(this);

		return this;
	}

	/**
	 * @inheritDoc
	 */
	public override function reverse(?value:Null<Bool>):GenericActuator<T> {
		super.reverse(value);

		if (active) {
			timeOffset += (2 * tweenPosition - 1) * duration;
		} else {
			startTime = __getPlatformTime();
			timeOffset = startTime;

			if (actuators.indexOf(this) == -1) {
				actuators.push(this);
				++actuatorsLength;
			}

			active = true;

			Actuate.load(this);
		}

		return this;
	}

	private inline function getField<V>(target:V, propertyName:String):Dynamic {
		var value = null;

		if (Reflect.hasField(target, propertyName)) {
			value = Reflect.field(target, propertyName);
		} else {
			value = Reflect.getProperty(target, propertyName);
		}

		return value;
	}

	private function initialize() {
		var details:PropertyDetails<U>;
		var start:Dynamic;

		for (i in Reflect.fields(properties)) {
			var isField = true;

			if (Reflect.hasField(target, i) #if html5
				&& !(untyped (target).__properties__ && untyped (target).__properties__["set_" + i]) #end) {
				start = Reflect.field(target, i);
			} else {
				isField = false;
				start = Reflect.getProperty(target, i);
			}

			if (start is Float) {
				var value:Dynamic = getField(properties, i);

				#if js
				if (start == null)
					start = 0;
				if (value == null)
					value = 0;
				#end

				details = new PropertyDetails(cast target, i, start, value - start, isField);
				propertyDetails.push(details);
			}
		}

		detailsLength = propertyDetails.length;
		initialized = true;
	}

	private override function move() {
		#if openfl
		toggleVisible = (Reflect.hasField(properties, "alpha") && target is DisplayObject);
		#else
		toggleVisible = (Reflect.hasField(properties, "alpha") && Reflect.hasField(properties, "visible"));
		#end

		if (toggleVisible && properties.alpha != 0 && !getField(target, "visible")) {
			setVisible = true;
			cacheVisible = getField(target, "visible");
			setField(target, "visible", true);
		}

		timeOffset = startTime;
		actuators.push(this);
		++actuatorsLength;
	}

	/**
	 * @inheritDoc
	 */
	public override function onUpdate(handler:Dynamic, parameters:Array<Dynamic> = null):GenericActuator<T> {
		_onUpdate = handler;

		if (parameters == null) {
			_onUpdateParams = [];
		} else {
			_onUpdateParams = parameters;
		}

		sendChange = true;

		return this;
	}

	private override function pause() {
		if (!paused) {
			paused = true;

			super.pause();

			#if !actuate_manual_time
			#if openfl
			pauseTime = Lib.getTimer();
			#elseif js
			pauseTime = Browser.window.performance.now() / 1000;
			#else
			pauseTime = Timer.stamp();
			#end
			#else
			pauseTime = getTime();
			#end
		}
	}

	private override function resume() {
		if (paused) {
			paused = false;

			#if !actuate_manual_time
			#if openfl
			timeOffset += (Lib.getTimer() - pauseTime) / 1000;
			#elseif js
			timeOffset += (Browser.window.performance.now() - pauseTime) / 1000;
			#else
			timeOffset += (Timer.stamp() - pauseTime);
			#end
			#else
			timeOffset += (getTime() - pauseTime) / 1000;
			#end

			super.resume();
		}
	}

	#if !js @:generic #end private inline function setField<V>(target:V, propertyName:String, value:Dynamic) {
		if (Reflect.hasField(target,
			propertyName) #if html5 && !(untyped (target).__properties__ && untyped (target).__properties__["set_" + propertyName]) #end) {
			Reflect.setField(target, propertyName, value);
		} else {
			Reflect.setProperty(target, propertyName, value);
		}
	}

	private function setProperty(details:PropertyDetails<U>, value:Dynamic) {
		if (details.isField) {
			Reflect.setField(details.target, details.propertyName, value);
		} else {
			Reflect.setProperty(details.target, details.propertyName, value);
		}
	}

	private override function stop(properties:Dynamic, complete:Bool, sendEvent:Bool) {
		if (active) {
			if (properties == null) {
				active = false;

				if (complete) {
					apply();
				}

				this.complete(sendEvent);
				return;
			}

			for (i in Reflect.fields(properties)) {
				if (Reflect.hasField(this.properties, i)) {
					active = false;

					if (complete) {
						apply();
					}

					this.complete(sendEvent);
					return;
				}
			}
		}
	}

	private function update(currentTime:Float) {
		if (!paused) {
			var details:PropertyDetails<U>;
			var easing:Float;
			var i:Int;

			tweenPosition = (currentTime - timeOffset) / duration;

			if (tweenPosition > 1) {
				tweenPosition = 1;
			}

			if (!initialized) {
				initialize();
				start();
			}

			if (!special) {
				easing = _ease.calculate(tweenPosition);

				for (i in 0...detailsLength) {
					details = propertyDetails[i];
					setProperty(details, details.getValueByEasing(easing));
				}
			} else {
				if (!_reverse) {
					easing = _ease.calculate(tweenPosition);
				} else {
					easing = _ease.calculate(1 - tweenPosition);
				}

				var endValue:Float;

				for (i in 0...detailsLength) {
					details = propertyDetails[i];

					if (_smartRotation
						&& (details.propertyName == "rotation" || details.propertyName == "rotationX" || details.propertyName == "rotationY"
							|| details.propertyName == "rotationZ")) {
						var rotation:Float = details.change % 360;

						if (rotation > 180) {
							rotation -= 360;
						} else if (rotation < -180) {
							rotation += 360;
						}

						endValue = details.start + rotation * easing;
					} else {
						endValue = details.getValueByEasing(easing);
					}

					if (!_snapping) {
						setProperty(details, endValue);
					} else {
						setProperty(details, Math.round(endValue));
					}
				}
			}

			if (tweenPosition == 1) {
				if (_repeat == 0) {
					active = false;

					if (toggleVisible && getField(target, "alpha") == 0) {
						setField(target, "visible", false);
					}

					if (!_reflect && _reverse) {
						reveseComplete();
					} else {
						complete(true);
					}
					return;
				} else {
					if (_onRepeat != null) {
						callMethod(_onRepeat, _onRepeatParams);
					}

					if (_reflect) {
						_reverse = !_reverse;
					}

					startTime = currentTime;
					timeOffset = startTime + _delay;

					if (_repeat > 0) {
						_repeat--;
					}
				}
			}

			if (sendChange) {
				change();
			}
		}
	}

	// Event Handlers
	#if actuate_manual_update
	public
	#else
	private
	#end
	static function stage_onEnterFrame(#if openfl event:Event #elseif js deltaTime:Float #end) {
		#if !actuate_manual_time
		#if openfl
		var currentTime:Float = Lib.getTimer() / 1000;
		#elseif js
		var currentTime = deltaTime / 1000;
		#else
		var currentTime = Timer.stamp();
		#end
		#else
		var currentTime = getTime();
		#end

		var actuator:SimpleActuator<Dynamic, Dynamic>;

		var j:Int = 0;
		var cleanup = false;

		for (i in 0...actuatorsLength) {
			actuator = actuators[j];

			if (actuator != null && actuator.active) {
				if (currentTime >= actuator.timeOffset) {
					actuator.update(currentTime);
				}

				j++;
			} else {
				actuators.splice(j, 1);
				--actuatorsLength;
			}
		}

		#if (!openfl && !actuate_manual_time && js)
		Browser.window.requestAnimationFrame(stage_onEnterFrame);
		#end
	}
}

#if (cpp && !openfl)
// Custom haxe.Timer implementation for C++

typedef TimerList = Array<Timer>;

class Timer {
	static var sRunningTimers:TimerList = [];

	var mTime:Float;
	var mFireAt:Float;
	var mRunning:Bool;

	public function new(time:Float) {
		mTime = time;
		sRunningTimers.push(this);
		mFireAt = GetMS() + mTime;
		mRunning = true;
	}

	public static function measure<T>(f:Void->T, ?pos:haxe.PosInfos):T {
		var t0 = stamp();
		var r = f();
		haxe.Log.trace((stamp() - t0) + "s", pos);
		return r;
	}

	// Set this with "run=..."
	dynamic public function run() {}

	public function stop() {
		if (mRunning) {
			mRunning = false;
			sRunningTimers.remove(this);
		}
	}

	static function GetMS():Float {
		return stamp() * 1000.0;
	}

	// From std/haxe/Timer.hx
	public static function delay(f:Void->Void, time:Int) {
		var t = new Timer(time);

		t.run = function() {
			t.stop();
			f();
		};

		return t;
	}

	static public function stamp():Float {
		return Date.now().getTime();
	}
}
#end
