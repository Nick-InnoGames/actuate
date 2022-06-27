package motion.easing;

/**
 * @author Joshua Granick
 * @author Philippe / http://philippe.elsass.me
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */
class Quart {
	public static final easeIn:IEasing = new QuartEaseIn();
	public static final easeInOut:IEasing = new QuartEaseInOut();
	public static final easeOut:IEasing = new QuartEaseOut();
}

private class QuartEaseIn implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return k * k * k * k;
	}
}

private class QuartEaseInOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		if ((k *= 2) < 1) return 0.5 * k * k * k * k;
		return -0.5 * ((k -= 2) * k * k * k - 2);
	}
}

private class QuartEaseOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return -(--k * k * k * k - 1);
	}
}
