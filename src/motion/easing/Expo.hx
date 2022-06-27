package motion.easing;

/**
 * @author Joshua Granick
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */
class Expo {
	public static final easeIn:IEasing = new ExpoEaseIn();
	public static final easeInOut:IEasing = new ExpoEaseInOut();
	public static final easeOut:IEasing = new ExpoEaseOut();
}

private class ExpoEaseIn implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return k == 0 ? 0 : Math.exp(6.931471805599453 * (k - 1));
	}
}

private class ExpoEaseInOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		if (k == 0) {
			return 0;
		}
		if (k == 1) {
			return 1;
		}
		if ((k /= 1 / 2.0) < 1.0) {
			return 0.5 * Math.exp(6.931471805599453 * (k - 1));
		}
		return 0.5 * (2 - Math.exp(-6.931471805599453 * --k));
	}
}

private class ExpoEaseOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return k == 1 ? 1 : (1 - Math.exp(-6.931471805599453 * k));
	}
}
