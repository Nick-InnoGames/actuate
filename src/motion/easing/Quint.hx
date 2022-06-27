package motion.easing;

/**
 * @author Joshua Granick
 * @author Philippe / http://philippe.elsass.me
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */
class Quint {
	public static final easeIn:IEasing = new QuintEaseIn();
	public static final easeInOut:IEasing = new QuintEaseInOut();
	public static final easeOut:IEasing = new QuintEaseOut();
}

private class QuintEaseIn implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return k * k * k * k * k;
	}
}

private class QuintEaseInOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		if ((k *= 2) < 1) return 0.5 * k * k * k * k * k;
		return 0.5 * ((k -= 2) * k * k * k * k + 2);
	}
}

private class QuintEaseOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return --k * k * k * k * k + 1;
	}
}
