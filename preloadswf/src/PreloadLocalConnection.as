/**
 * Created by zhujiahe on 2015/9/20.
 */
package {
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.net.LocalConnection;

    public class PreloadLocalConnection extends Sprite {

        private var conn:LocalConnection;

        public function PreloadLocalConnection() {
            if (stage) start();
            else addEventListener(Event.ADDED_TO_STAGE, onAddtoStage);
        }

        private function onAddtoStage(event:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, onAddtoStage);
            start();
        }

        private function start():void {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            conn = new LocalConnection();
            conn.client = this;
            try {
                conn.connect("preload_LocalConnection");
            } catch (error:Error) {
                trace("Can't connect...the connection name is already being used by another SWF");
            }
        }

        public function log(msg:String):void {
            trace(msg);
        }
    }
}