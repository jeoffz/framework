/**
 * Created by zhujiahe on 2015/8/22.
 */
package {
    import flash.display.Sprite;

    import jas3lib.debug.StatsDisplay;

    public class Test extends Sprite {

        public function Test() {
            super();

            if (name != "root1") {
                trace("fail");
            } else {
                trace("success")
            }

            addChild(new StatsDisplay());
        }
    }
}
