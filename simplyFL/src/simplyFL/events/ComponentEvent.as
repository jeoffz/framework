// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.events {

    import flash.events.Event;

    public class ComponentEvent extends Event {

        public static const BUTTON_DOWN:String = "buttonDown";

        public function ComponentEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
        }

        override public function toString():String {
            return formatToString("ComponentEvent", "type", "bubbles", "cancelable");
        }

        override public function clone():Event {
            return new ComponentEvent(type, bubbles, cancelable);
        }
    }
}