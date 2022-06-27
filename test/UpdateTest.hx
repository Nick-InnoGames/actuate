import utest.Assert;
import motion.actuators.SimpleActuator;
import motion.easing.Linear;
import motion.Actuate;

class UpdateTest extends utest.Test {
	function testCallbacks():Void {
		var x = 0.0;

		var callback = function(value:Float) {
			x = value;
		}

		var calledUpdate = 0;
		var calledComplete = 0;

		var onUpdate = function() {
			calledUpdate++;
		}

		var onComplete = function() {
			calledComplete++;
		}

		update(0);

		Actuate.update(callback, 2, [100], [300])
			.ease(Linear.easeNone)
			.onUpdate(onUpdate)
			.onComplete(onComplete);

		Assert.equals(0, calledUpdate);
		Assert.equals(0, calledComplete);

		update(0);

		Assert.equals(1, calledUpdate);
		Assert.equals(0, calledComplete);

		update(0.5);

		Assert.equals(2, calledUpdate);
		Assert.equals(0, calledComplete);

		update(1);

		Assert.equals(3, calledUpdate);
		Assert.equals(0, calledComplete);

		update(2);

		Assert.equals(4, calledUpdate);
		Assert.equals(1, calledComplete);
	}

	function testDynamic():Void {
		var x = 0.0;

		var callback = function(value:Float) {
			x = value;
		}

		update(0);

		Actuate.update(callback, 2, [100], [300]).ease(Linear.easeNone);

		update(0);

		Assert.equals(100, x);

		update(0.5);

		Assert.equals(150, x);

		update(1);

		Assert.equals(200, x);

		Actuate.stop(callback);

		update(2);

		Assert.equals(200, x);
	}

	function testClass():Void {
		var objectClass = new ObjectClass(0);

		update(0);

		Actuate.update(objectClass.update, 2, [100], [300]).ease(Linear.easeNone);

		update(0);

		Assert.equals(100, objectClass.x);

		update(0.5);

		Assert.equals(150, objectClass.x);

		update(1);

		Assert.equals(200, objectClass.x);

		Actuate.stop(objectClass.update);

		update(2);

		Assert.equals(200, objectClass.x);
	}

	private function update(time:Float):Void {
		SimpleActuator.getTime = function() return time;
		#if js
		SimpleActuator.stage_onEnterFrame(0);
		#else
		SimpleActuator.stage_onEnterFrame();
		#end
	}
}

private class ObjectClass {
	public var x:Float;

	public function new(x:Float) {
		this.x = x;
	}

	public function update(value:Float):Void {
		x = value;
	}
}
