package motion.easing;

/**
 * @author Erik Escoffier
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */
class Bounce {
	public static final easeIn:IEasing = new BounceEaseIn();
	public static final easeInOut:IEasing = new BounceEaseInOut();
	public static final easeOut:IEasing = new BounceEaseOut();
}

private class BounceEaseIn implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return BounceEaseIn._calculate(k);
	}

	public static inline function _calculate(t:Float):Float {
		return 1 - BounceEaseOut._calculate(1 - t);
	}
}

private class BounceEaseInOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		if (k < .5) {
			return BounceEaseIn._calculate(k * 2) * .5;
		} else {
			return BounceEaseOut._calculate(k * 2 - 1) * .5 + .5;
		}
	}
}

private class BounceEaseOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return BounceEaseOut._calculate(k);
	}

	public static inline function _calculate(t:Float):Float {
		if (t < (1 / 2.75)) {
			return (7.5625 * t * t);
		} else if (t < (2 / 2.75)) {
			return (7.5625 * (t -= (1.5 / 2.75)) * t + .75);
		} else if (t < (2.5 / 2.75)) {
			return (7.5625 * (t -= (2.25 / 2.75)) * t + .9375);
		} else {
			return (7.5625 * (t -= (2.625 / 2.75)) * t + .984375);
		}
	}
}
