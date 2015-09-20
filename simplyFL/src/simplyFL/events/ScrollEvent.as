// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.events {

    import flash.events.Event;

    /**
	 * The ScrollEvent class defines the scroll event that is associated with the ScrollBar component.
	 */
	public class ScrollEvent extends Event {

		public static const SCROLL:String = "scroll";

        private var _direction:String;

        private var _delta:Number;

		private var _position:Number;

		public function ScrollEvent(direction:String, delta:Number, position:Number) {
			super(ScrollEvent.SCROLL,false,false);
			_direction = direction;
			_delta = delta;
			_position = position;
		}

		public function get direction():String {
			return _direction;
		}

		public function get delta():Number {
			return _delta;
		}

		/**
         * Gets the current scroll position, in pixels.
		 */
		public function get position():Number {
			return _position;
		}

		override public function toString():String {
			return formatToString("ScrollEvent", "type", "bubbles", "cancelable", "direction", "delta", "position");
		}

		override public function clone():Event {
			return new ScrollEvent(_direction, _delta, _position);
		}
	}
}
