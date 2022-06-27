package motion.easing;

/**
 * @author Joshua Granick
 * @author Philippe / http://philippe.elsass.me
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */
class Cubic {
	public static final easeIn:IEasing = new CubicEaseIn();
	public static final easeInOut:IEasing = new CubicEaseInOut();
	public static final easeOut:IEasing = new CubicEaseOut();
}

private class CubicEaseIn implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return k * k * k;
	}
}

private class CubicEaseInOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return ((k /= 1 / 2) < 1) ? 0.5 * k * k * k : 0.5 * ((k -= 2) * k * k + 2);
	}
}

private class CubicEaseOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return --k * k * k + 1;
	}
}
