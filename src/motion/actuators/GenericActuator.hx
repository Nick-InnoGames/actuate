package motion.actuators;

import motion.easing.IEasing;
import motion.Actuate;

@:keepSub
class GenericActuator<T> implements IGenericActuator {
	private var duration:Float;
	private var id:String;
	private var properties:Dynamic;
	private var target:T;
	private var _autoVisible:Bool;
	private var _delay:Float;
	private var _ease:IEasing;
	private var _onComplete:Dynamic;
	private var _onCompleteParams:Array<Dynamic>;
	private var _onPause:Dynamic;
	private var _onPauseParams:Array<Dynamic>;
	private var _onRepeat:Dynamic;
	private var _onRepeatParams:Array<Dynamic>;
	private var _onResume:Dynamic;
	private var _onResumeParams:Array<Dynamic>;
	private var _onReverseComplete:Dynamic;
	private var _onReverseCompleteParams:Array<Dynamic>;
	private var _onStart:Dynamic;
	private var _onStartParams:Array<Dynamic>;
	private var _onUpdate:Dynamic;
	private var _onUpdateParams:Array<Dynamic>;
	private var _reflect:Bool;
	private var _repeat:Int;
	private var _repeatTimes:Int;
	private var _reverse:Bool;
	private var _smartRotation:Bool;
	private var _snapping:Bool;
	private var special:Bool;

	public function new(target:T, duration:Float, properties:Dynamic) {
		_autoVisible = true;
		_delay = 0;
		_reflect = false;
		_repeatTimes = 0;
		_repeat = 0;
		_reverse = false;
		_smartRotation = false;
		_snapping = false;
		special = false;

		this.target = target;
		this.properties = properties;
		this.duration = duration;

		_ease = Actuate.defaultEase;
	}

	private function apply() {
		for (i in Reflect.fields(properties)) {
			if (Reflect.hasField(target, i)) {
				Reflect.setField(target, i, Reflect.field(properties, i));
			} else {
				Reflect.setProperty(target, i, Reflect.field(properties, i));
			}
		}
	}

	/**
	 * Flash performs faster when objects are set to visible = false rather than only alpha = 0. autoVisible toggles automatically based on alpha values
	 * @param	value		Whether autoVisible should be enabled (Default is true)
	 * @return		The current actuator instance
	 */
	public function autoVisible(?value:Null<Bool>):GenericActuator<T> {
		if (value == null) {
			value = true;
		}

		_autoVisible = value;

		return this;
	}

	private inline function callMethod(method:Dynamic, params:Array<Dynamic> = null):Dynamic {
		if (params == null) {
			params = [];
		}

		return Reflect.callMethod(method, method, params);
	}

	private function change() {
		if (_onUpdate != null) {
			callMethod(_onUpdate, _onUpdateParams);
		}
	}

	private function complete(sendEvent:Bool = true) {
		Actuate.unload(this);

		if (sendEvent) {
			change();

			if (_onComplete != null) {
				callMethod(_onComplete, _onCompleteParams);
			}
		}
	}

	/**
	 * Increases the delay before a tween is executed
	 * @param	duration		The amount of seconds to delay
	 * @return		The current actuator instance
	 */
	public function delay(duration:Float):GenericActuator<T> {
		_delay = duration;

		return this;
	}

	/**
	 * Starts the tween from the begining
	 * @param	includeDelay	if the tween has delay this flag determines if the delay should be applied on restart or not
	 * @return		The current actuator instance
	 */
	public function restart(includeDelay:Bool = false):GenericActuator<T> {
		_reverse = false;
		_repeat = _repeatTimes;

		return this;
	}

	/**
	 * Sets the easing which is used when running the tween
	 * @param	easing		An easing equation, like Elastic.easeIn or Quad.easeOut
	 * @return		The current actuator instance
	 */
	public function ease(easing:IEasing):GenericActuator<T> {
		_ease = easing;

		return this;
	}

	private function move() {}

	/**
	 * Defines a function which will be called when the tween finishes
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onComplete(handler:Dynamic, parameters:Array<Dynamic> = null):GenericActuator<T> {
		_onComplete = handler;
		_onCompleteParams = parameters;

		if (duration == 0) {
			complete(true);
		}

		return this;
	}

	/**
	 * Defines a function which will be called when the tween is paused
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onPause(handler:Dynamic, parameters:Array<Dynamic> = null):GenericActuator<T> {
		_onPause = handler;
		_onPauseParams = parameters;

		return this;
	}

	/**
	 * Defines a function which will be called when the tween repeats
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onRepeat(handler:Dynamic, parameters:Array<Dynamic> = null):GenericActuator<T> {
		_onRepeat = handler;
		_onRepeatParams = parameters;

		return this;
	}

	/**
	 * Defines a function which will be called when the tween resumed after pause
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onResume(handler:Dynamic, parameters:Array<Dynamic> = null):GenericActuator<T> {
		_onResume = handler;
		_onResumeParams = parameters;

		return this;
	}

	/**
	 * Defines a function which will be called when the tween finishes playing reversed
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onReverseComplete(handler:Dynamic, parameters:Array<Dynamic> = null):GenericActuator<T> {
		_onReverseComplete = handler;
		_onReverseCompleteParams = parameters;

		if (_reverse && duration == 0) {
			complete(true);
		}

		return this;
	}

	/**
	 * Defines a function which will be called when the tween starts
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onStart(handler:Dynamic, parameters:Array<Dynamic> = null):GenericActuator<T> {
		_onStart = handler;
		_onStartParams = parameters;

		return this;
	}

	/**
	 * Defines a function which will be called when the tween updates
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onUpdate(handler:Dynamic, parameters:Array<Dynamic> = null):GenericActuator<T> {
		_onUpdate = handler;
		_onUpdateParams = parameters;

		return this;
	}

	private function pause() {
		if (_onPause != null)
			callMethod(_onPause, _onPauseParams);
	}

	/**
	 * Automatically changes the reverse value when the tween repeats. Repeat must be enabled for this to have any effect
	 * @param	value		Whether reflect should be enabled (Default is true)
	 * @return		The current actuator instance
	 */
	public function reflect(?value:Null<Bool>):GenericActuator<T> {
		if (value == null) {
			value = true;
		}

		_reflect = value;
		special = true;

		return this;
	}

	/**
	 * Repeats the tween after it finishes
	 * @param	times		The number of times you would like the tween to repeat, or -1 if you would like to repeat the tween indefinitely (Default is -1)
	 * @return		The current actuator instance
	 */
	public function repeat(?times:Null<Int>):GenericActuator<T> {
		if (times == null) {
			times = -1;
		}
		_repeatTimes = times;
		_repeat = times;

		return this;
	}

	private function resume() {
		if (_onResume != null)
			callMethod(_onResume, _onResumeParams);
	}

	/**
	 * Sets if the tween should be handled in reverse
	 * @param	value		Whether the tween should be reversed (Default is true)
	 * @return		The current actuator instance
	 */
	public function reverse(?value:Null<Bool>):GenericActuator<T> {
		if (value == null) {
			value = true;
		}

		_reverse = value;
		special = true;

		return this;
	}

	private function reveseComplete() {
		Actuate.unload(this);

		change();

		if (_onReverseComplete != null) {
			callMethod(_onReverseComplete, _onReverseCompleteParams);
		}
	}

	/**
	 * Enabling smartRotation can prevent undesired results when tweening rotation values
	 * @param	value		Whether smart rotation should be enabled (Default is true)
	 * @return		The current actuator instance
	 */
	public function smartRotation(?value:Null<Bool>):GenericActuator<T> {
		if (value == null) {
			value = true;
		}

		_smartRotation = value;
		special = true;

		return this;
	}

	/**
	 * Snapping causes tween values to be rounded automatically
	 * @param	value		Whether tween values should be rounded (Default is true)
	 * @return		The current actuator instance
	 */
	public function snapping(?value:Null<Bool>):GenericActuator<T> {
		if (value == null) {
			value = true;
		}

		_snapping = value;
		special = true;

		return this;
	}

	private function start() {
		if (_onStart != null) {
			callMethod(_onStart, _onStartParams);
		}
	}

	private function stop(properties:Dynamic, complete:Bool, sendEvent:Bool) {}
}
