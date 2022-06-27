package motion.easing;

/**
 * @author Joshua Granick
 * @author Zeh Fernando, Nate Chatellier
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */
class Back {
	public static final easeIn:IEasing = new BackEaseIn(1.70158);
	public static final easeInOut:IEasing = new BackEaseInOut(1.70158);
	public static final easeOut:IEasing = new BackEaseOut(1.70158);

	public static function easeInWith(s:Float):IEasing {
		return new BackEaseIn(s);
	}

	public static function easeInOutWith(s:Float):IEasing {
		return new BackEaseInOut(s);
	}

	public static function easeOutWith(s:Float):IEasing {
		return new BackEaseOut(s);
	}
}

private class BackEaseIn implements IEasing {
	final s:Float;

	public function new(s:Float) {
		this.s = s;
	}

	public function calculate(k:Float):Float {
		return k * k * ((s + 1) * k - s);
	}
}

private class BackEaseInOut implements IEasing {
	final s:Float;

	public function new(s:Float) {
		this.s = s;
	}

	public function calculate(k:Float):Float {
		var c = s * 1.525;
		if ((k *= 2) < 1) return 0.5 * (k * k * ((c + 1) * k - c));
		return 0.5 * ((k -= 2) * k * ((c + 1) * k + c) + 2);
	}
}

private class BackEaseOut implements IEasing {
	final s:Float;

	public function new(s:Float) {
		this.s = s;
	}

	public function calculate(k:Float):Float {
		return ((k = k - 1) * k * ((s + 1) * k + s) + 1);
	}
}
