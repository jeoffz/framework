/**
 * Created by zhujiahe on 2015/8/25.
 */
package jas3lib.debug {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.getTimer;

    public class StatsDisplay extends Sprite {

        private const UPDATE_INTERVAL:uint = 500;

        private var _textField:TextField;

        private var _timestamp:uint;
        private var _frameCount:uint;

        public function StatsDisplay() {
            super();

            mouseChildren = false;
            mouseEnabled = false;

            this.graphics.beginFill(0x7f7f7f,0.5);
            this.graphics.drawRect(0,0,80,40);
            this.graphics.endFill();

            _textField = new TextField();
            _textField.autoSize = TextFieldAutoSize.LEFT;
            _textField.x = _textField.y = 2;
            addChild(_textField);

            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }

        private function onAddedToStage(event:Event):void {
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            _timestamp = _frameCount = 0;
            update(0);
        }

        private function onRemovedFromStage(event:Event):void {
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:Event):void
        {
            var timestamp:uint = getTimer();
            if(_timestamp) {
                _frameCount++;
                if(timestamp-_timestamp>UPDATE_INTERVAL) {
                    update(timestamp-_timestamp);
                    _timestamp = timestamp;
                    _frameCount = 0;
                }
            } else {
                _timestamp = timestamp;
            }
        }

        public function update(elapseTime:uint):void
        {
            var fps:Number = elapseTime > 0 ? _frameCount/elapseTime * 1000.0 : 0;
            var memory:Number = System.totalMemory * 0.000000954; // 1.0 / (1024*1024) to convert to MB

            _textField.text = "FPS: " + fps.toFixed(fps < 100 ? 1 : 0) +
                    "\nMEM: " + memory.toFixed(memory < 100 ? 1 : 0);
        }

    }
}
