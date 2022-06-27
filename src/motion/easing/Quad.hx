package motion.easing;

/**
 * @author Joshua Granick
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */
class Quad {
	public static final easeIn:IEasing = new QuadEaseIn();
	public static final easeInOut:IEasing = new QuadEaseInOut();
	public static final easeOut:IEasing = new QuadEaseOut();
}

private class QuadEaseIn implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return k * k;
	}
}

private class QuadEaseInOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		if ((k *= 2) < 1) return 0.5 * k * k;
		return -0.5 * ((k - 1) * (k - 3) - 1);
	}
}

private class QuadEaseOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return -k * (k - 2);
	}
}
