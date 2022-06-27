package motion.easing;

/**
 * @author Joshua Granick
 * @author Philippe / http://philippe.elsass.me
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */
class Elastic {
	public static final easeIn:IEasing = new ElasticEaseIn(1, 0.4);
	public static final easeInOut:IEasing = new ElasticEaseInOut(1, 0.3 * 1.5);
	public static final easeOut:IEasing = new ElasticEaseOut(1, 0.4);

	public static function easeInWith(a:Float, p:Float):IEasing {
		return new ElasticEaseIn(a, p);
	}

	public static function easeInOutWith(a:Float, p:Float):IEasing {
		return new ElasticEaseInOut(a, p);
	}

	public static function easeOutWith(a:Float, p:Float):IEasing {
		return new ElasticEaseOut(a, p);
	}
}

private class ElasticEaseIn implements IEasing {
	final a:Float;
	final p:Float;

	public function new(a:Float, p:Float) {
		this.a = a;
		this.p = p;
	}

	public function calculate(k:Float):Float {
		if (k == 0 || k == 1) return k;
		var s = p / (2 * Math.PI) * Math.asin(1 / a);
		return -(a * Math.exp(6.931471805599453 * (k -= 1)) * Math.sin((k - s) * (2 * Math.PI) / p));
	}
}

private class ElasticEaseInOut implements IEasing {
	final a:Float;
	final p:Float;

	public function new(a:Float, p:Float) {
		this.a = a;
		this.p = p;
	}

	public function calculate(k:Float):Float {
		if (k == 0) return 0;
		if ((k *= 2) == 2) return 1;

		var s = p / (2 * Math.PI) * Math.asin(1 / a);

		if (k < 1) {
			return -0.5 * (a * Math.exp(6.931471805599453 * (k -= 1)) * Math.sin((k - s) * (2 * Math.PI) / p));
		}
		return a * Math.exp(-6.931471805599453 * (k -= 1)) * Math.sin((k - s) * (2 * Math.PI) / p) * 0.5 + 1;
	}
}

private class ElasticEaseOut implements IEasing {
	final a:Float;
	final p:Float;

	public function new(a:Float, p:Float) {
		this.a = a;
		this.p = p;
	}

	public function calculate(k:Float):Float {
		if (k == 0 || k == 1) return k;
		var s = p / (2 * Math.PI) * Math.asin(1 / a);
		return (a * Math.exp(-6.931471805599453 * k) * Math.sin((k - s) * (2 * Math.PI) / p) + 1);
	}
}
