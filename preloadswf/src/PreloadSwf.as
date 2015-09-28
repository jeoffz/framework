package {

    import com.demonsters.debugger.MonsterDebugger;

    import flash.display.LoaderInfo;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.StatusEvent;
    import flash.net.LocalConnection;

    public class PreloadSwf extends Sprite {

        private var conn:LocalConnection;

        public function PreloadSwf() {
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

            MonsterDebugger.initialize(this);
            MonsterDebugger.trace(this, "start");
            conn = new LocalConnection();
            conn.addEventListener(StatusEvent.STATUS, onStatus);

            addEventListener("allComplete", onAllComplete);
        }

        private function onAllComplete(event:Event):void {
            removeEventListener("allComplete", onAllComplete);

            var info:LoaderInfo = event.target as LoaderInfo;
            MonsterDebugger.inspect(info);
            MonsterDebugger.trace(this, "inspect");

            // now let the fun begin! try:
            // info.content
            // info.content.stage
            // info.parameters
            // info.applicationDomain
            // info.bytes
        }

        private function onStatus(event:StatusEvent):void {
            switch (event.level) {
                case "status":
                    trace("LocalConnection.send() succeeded");
                    break;
                case "error":
                    trace("LocalConnection.send() failed");
                    break;
            }
        }

        private function log(msg:String):void {
            try {
                conn.send("preload_LocalConnection", "log", msg);
            } catch (e:Error) {
                trace("send fail.");
            }
        }

        private function logObject(object:Object, name:String = "object"):void {
            log("log " + name + " start ---------------------------");
            for (var key:String in object) {
                log("key: " + key + " value: " + object["key"]);
            }
            log("log " + name + " end -----------------------------");
        }

    }

}
