﻿package motion.actuators;

#if openfl
import openfl.display.DisplayObject;
import openfl.filters.BitmapFilter;

class FilterActuator extends SimpleActuator<DisplayObject, BitmapFilter> {
	private var filter:BitmapFilter;
	private var filterClass:Class<BitmapFilter>;
	private var filterIndex:Int;

	public function new(target:DisplayObject, duration:Float, properties:Dynamic) {
		filterIndex = -1;

		super(target, duration, properties);

		if (Std.isOfType(properties.filter, Class)) {
			filterClass = properties.filter;

			if (target.filters.length == 0) {
				target.filters = [Type.createInstance(filterClass, [])];
			}

			for (filter in target.filters) {
				if (Std.isOfType(filter, filterClass)) {
					this.filter = filter;
				}
			}
		} else {
			filterIndex = properties.filter;
			this.filter = target.filters[filterIndex];
		}
	}

	private override function apply() {
		for (propertyName in Reflect.fields(properties)) {
			if (propertyName != "filter") {
				Reflect.setProperty(filter, propertyName, Reflect.field(properties, propertyName));
			}
		}

		setFilter();
	}

	private override function initialize() {
		var details:PropertyDetails<BitmapFilter>;
		var start:Float;

		for (propertyName in Reflect.fields(properties)) {
			if (propertyName != "filter") {
				start = getField(filter, propertyName);
				details = new PropertyDetails(filter, propertyName, start, Reflect.field(properties, propertyName) - start,
					Reflect.hasField(filter, "set_" + propertyName));
				propertyDetails.push(details);
			}
		}

		detailsLength = propertyDetails.length;
		initialized = true;
	}

	private function setFilter() {
		var filters = target.filters;

		if (filterIndex > -1) {
			filters[filterIndex] = filter;
		} else {
			for (i in 0...filters.length) {
				if (Std.isOfType(filters[i], filterClass)) {
					filters[i] = filter;
				}
			}
		}

		setField(target, "filters", filters);
	}

	private override function update(currentTime:Float) {
		super.update(currentTime);
		setFilter();
	}
}
#end
