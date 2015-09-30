/**
 * Created by zhujiahe on 2015/9/28.
 */
package simplyFL.containers {

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.Rectangle;

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

        protected var _contentClip:Sprite;

        protected var _content:DisplayObject;

        public function SimplePanel(uiStyleObj:Object = null) {
            super(uiStyleObj);
        }

        override protected function configUI():void {
            super.configUI();

            _contentClip = new Sprite();
            _contentClip.scrollRect = new Rectangle();
            addChild(_contentClip);
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

        public function set content(value:DisplayObject):void {
            if(value != _content) {
                if(_content) {
                    _contentClip.removeChild(_content);
                }
                _contentClip.addChild(value);
                _content = value;
            }
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

            var marginLeft:int = int(getStyle("marginLeft"));
            var marginRight:int = int(getStyle("marginRight"));
            var marginTop:int = int(getStyle("marginTop"));
            var marginBottom:int = int(getStyle("marginBottom"));
            _contentClip.x = marginLeft;
            _contentClip.y = marginTop;
            var rect:Rectangle = _contentClip.scrollRect;
            rect.width = width-marginLeft-marginRight;
            rect.height = height-marginTop-marginBottom;
            _contentClip.scrollRect = rect;

            titleLabel.width = width-marginLeft;
            titleLabel.x = marginLeft;
            titleLabel.y = 2;
        }
    }
}
