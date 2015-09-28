/**
 * Created by zhujiahe on 2015/9/28.
 */
package simplyFL.containers {

    import flash.display.DisplayObject;

    import simplyFL.core.InvalidationType;
    import simplyFL.core.Label;
    import simplyFL.core.UIComponent;

    //--------------------------------------
    //  Styles
    //--------------------------------------

    [Style(name="upSkin", type="Class")]

    [Style(name="marginLeft", type="Number")]
    [Style(name="marginRight", type="Number")]
    [Style(name="marginTop", type="Number")]
    [Style(name="marginBottom", type="Number")]

    //--------------------------------------
    //  Class description
    //--------------------------------------

    public class SimplePanel extends UIComponent {

        public var titleLabel:Label;

        protected var _background:DisplayObject;

        protected var _content:DisplayObject;

        public function SimplePanel(uiStyleName:String = null) {
            super(uiStyleName);
        }

        override protected function configUI():void {
            super.configUI();

            titleLabel = new Label();
            titleLabel.text = "Label";
            addChild(titleLabel);
        }

        public function get title():String {
            return titleLabel.text;
        }

        public function set title(value:String):void {
            if (value != titleLabel.text) {
                titleLabel.text = value;
            }
        }

        public function get content():DisplayObject {
            return _content;
        }

        public function set content(value:DisplayObject) {

        }

        override protected function draw():void {
            if (isInvalid(InvalidationType.STYLES)) {
                drawBackground();
                invalidate(InvalidationType.SIZE, false); // invalidates size without calling draw next frame.
            }
            if (isInvalid(InvalidationType.SIZE)) {
                drawLayout();
            }
            super.draw();
        }

        protected function drawBackground():void {
            var bg:DisplayObject = _background;
            _background = getDisplayObjectInstance(getStyle("upSkin"));
            addChildAt(_background, 0);
            if (bg != null && bg != _background) {
                removeChild(bg);
            }
        }

        protected function drawLayout():void {
            _background.width = width;
            _background.height = height;
        }
    }
}
