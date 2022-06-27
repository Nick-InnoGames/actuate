package motion.easing;

/**
 * @author Joshua Granick
 * @author Philippe / http://philippe.elsass.me
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */
class Linear {
	public static final easeNone:IEasing = new LinearEaseNone();
}

class LinearEaseNone implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return k;
	}
}
