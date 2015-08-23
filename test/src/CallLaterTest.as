/**
 * Created by zhujiahe on 2015/8/23.
 */
package {
    import flash.display.Sprite;
    import flash.utils.getTimer;

    import jas3lib.core.CallLater;

    public class CallLaterTest extends Sprite {
        public function CallLaterTest() {
            super();

            CallLater.init(stage);
//            CallLater.delayCall(heihei,["1",1],5000,true);
//            CallLater.delayCall(heihei,["5",5],2000);
            CallLater.nextframeCall(hehe);
            trace(getTimer());
            trace("init");
        }

        private function hehe():void {
            trace("hehe");
            trace(getTimer());
//            CallLater.nextframeCall(hehe);
        }

        private function heihei(str:String,value:int):void {
            trace("heihei",str,value);
            trace(getTimer());
            CallLater.delayCall(heihei,["2",2],2000,true);
//            CallLater.delayCall(heihei,["4",4],5000);
//            CallLater.delayCall(heihei,["3",3],4000);
        }
    }
}
