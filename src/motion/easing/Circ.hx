package motion.easing;

class Circ {
	public static final easeIn:IEasing = new CircEaseIn();
	public static final easeInOut:IEasing = new CircEaseInOut();
	public static final easeOut:IEasing = new CircEaseOut();
}

class CircEaseIn implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return -(Math.sqrt(1 - k * k) - 1);
	}
}

class CircEaseInOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		if ((k *= 2) < 1) return -0.5 * (Math.sqrt(1 - k * k) - 1);
		return 0.5 * (Math.sqrt(1 - (k -= 2) * k) + 1);
	}
}

class CircEaseOut implements IEasing {
	public function new() {}

	public function calculate(k:Float):Float {
		return Math.sqrt(1 - (k = k - 1) * k);
	}
}
