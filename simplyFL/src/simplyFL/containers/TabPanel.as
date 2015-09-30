/**
 * Created by zhujiahe on 2015/9/28.
 */
package simplyFL.containers {

    import simplyFL.core.UIComponent;

    //--------------------------------------
    //  Events
    //--------------------------------------

    [Event(name="change", type="flash.events.Event")]

    //--------------------------------------
    //  Styles
    //--------------------------------------

    [Style(name="tabBarUpSkin", type="Class")]
    [Style(name="tabBarOverSkin", type="Class")]
    [Style(name="tabBarDownSkin", type="Class")]
    [Style(name="tabBarDisabledSkin", type="Class")]

    [Style(name="tabBarWidth", type="Number")]
    [Style(name="tabBarHeight", type="Number")]

    [Style(name="upSkin", type="Class")]

    //--------------------------------------
    //  Class description
    //--------------------------------------

    public class TabPanel extends UIComponent {

        private var _curTabBarIndex:int;
        private var _tabBarArray:Array;

        public function TabPanel(uiStyleObj:Object = null) {
            super(uiStyleObj);
        }

        override protected function configUI():void {
            super.configUI();

            _curTabBarIndex = 0;
            _tabBarArray = new Array();
        }
    }
}
