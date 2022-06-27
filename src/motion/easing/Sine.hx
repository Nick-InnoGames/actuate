package motion.easing;

/**
 * @author Joshua Granick
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */
class Sine {
	public static final easeIn:IEasing = new SineEaseIn();
	public static final easeInOut:IEasing = new SineEaseInOut();
	public static final easeOut:IEasing = new SineEaseOut();
}

private class SineEaseIn implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return 1 - Math.cos(k * (Math.PI / 2));
	}
}

private class SineEaseInOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return -(Math.cos(Math.PI * k) - 1) / 2;
	}
}

private class SineEaseOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return Math.sin(k * (Math.PI / 2));
	}
}
