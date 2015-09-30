/**
 * Created by zhujiahe on 2015/9/28.
 */
package simplyFL.controls {

    import flash.events.Event;
    import flash.text.TextField;

    import simplyFL.defines.ScrollBarDirection;

    //--------------------------------------
    //  Class description
    //--------------------------------------    

    /**
     * The TextScrollBar class includes all of the scroll bar functionality, but
     * adds a <code>scrollTarget</code> property so it can be attached
     * to a TextField instance.
     *
     * <p><strong>Note:</strong> When you use ActionScript to update properties of
     * the TextField instance that affect the text layout, you must call the
     * <code>update()</code> method on the ScrollBar component instance to refresh its scroll
     * properties. Examples of text layout properties that belong to the TextField
     * instance include <code>width</code>, <code>height</code>, and <code>wordWrap</code>.</p>
     */
    public class TextScrollBar extends ScrollBar {

        protected var _scrollTarget:TextField;

        protected var inEdit:Boolean = false;

        protected var _targetScrollProperty:String;

        protected var _targetMaxScrollProperty:String;

        public function TextScrollBar(uiStyleObj:Object = null) {
            super(uiStyleObj);
            setTargetScrollProperties();
        }

        override public function set minScrollPosition(minScrollPosition:Number):void {
            super.minScrollPosition = (minScrollPosition < 0) ? 0 : minScrollPosition;
        }

        override public function set maxScrollPosition(maxScrollPosition:Number):void {
            var maxScrollPos:Number = maxScrollPosition;
            if (_scrollTarget != null) {
                maxScrollPos = Math.min(maxScrollPos, _scrollTarget[_targetMaxScrollProperty]);
            }
            super.maxScrollPosition = maxScrollPos;
        }

        /**
         * Registers a TextField instance with the TextScrollBar component instance.
         */
        public function get scrollTarget():TextField {
            return _scrollTarget;
        }

        public function set scrollTarget(target:TextField):void {
            if (_scrollTarget == target) return;

            if (_scrollTarget != null) {
                _scrollTarget.removeEventListener(Event.CHANGE, handleTargetChange, false);
                _scrollTarget.removeEventListener(Event.SCROLL, handleTargetScroll, false);
            }
            _scrollTarget = target;
            _scrollTarget.addEventListener(Event.CHANGE, handleTargetChange, false, 0, true);
            _scrollTarget.addEventListener(Event.SCROLL, handleTargetScroll, false, 0, true);
            updateScrollTargetProperties(false);
        }

        override public function get direction():String {
            return super.direction;
        }

        override public function set direction(value:String):void {
            if (direction == value) return;
            super.direction = value;
            setTargetScrollProperties();
            if (_scrollTarget != null) {
                updateScrollTargetProperties(false);
            }
        }

        /**
         * Forces the scroll bar to update its scroll properties immediately.
         * This is necessary after text in the specified <code>scrollTarget</code> TextField
         * is added using ActionScript, and the scroll bar needs to be refreshed.
         */
        public function update():void {
            updateScrollTargetProperties();
        }

        protected function updateScrollTargetProperties(fireEvent:Boolean = true):void {
            if (_scrollTarget != null) {
                var pagesize:Number;
                var minScrollPos:Number;
                if (_targetScrollProperty == "scrollH") {
                    pagesize = _scrollTarget.width;
                    minScrollPos = 0;
                } else {
                    pagesize = 10;
                    minScrollPos = 1;
                }
                inEdit = true;
                setScrollPosition(_scrollTarget[_targetScrollProperty], fireEvent);
                setScrollProperties(pagesize, minScrollPos, _scrollTarget[_targetMaxScrollProperty]);
                inEdit = false;
            }
        }

        override public function setScrollPosition(scrollPosition:Number, fireEvent:Boolean = true):void {
            super.setScrollPosition(scrollPosition, fireEvent);
            if (inEdit) {
                return;
            } // Update came from the user input. Ignore.
            _scrollTarget[_targetScrollProperty] = scrollPosition;
        }

        protected function handleTargetChange(event:Event):void {
            updateScrollTargetProperties();
        }

        protected function handleTargetScroll(event:Event):void {
            if (inDrag) {
                return;
            }
            if (!enabled) {
                return;
            }
            updateScrollTargetProperties(); // This needs to be done first!
        }

        private function setTargetScrollProperties():void {
            if (direction == ScrollBarDirection.HORIZONTAL) {
                _targetScrollProperty = "scrollH";
                _targetMaxScrollProperty = "maxScrollH";
            } else {
                _targetScrollProperty = "scrollV";
                _targetMaxScrollProperty = "maxScrollV"
            }
        }
    }
}