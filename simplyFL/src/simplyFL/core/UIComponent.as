// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.core {

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    import simplyFL.managers.StyleManager;

    //--------------------------------------
    //  Styles
    //--------------------------------------

    [Style(name="width", type="Number")]
    [Style(name="height", type="Number")]

    //--------------------------------------
    //  Class description
    //--------------------------------------
    public class UIComponent extends Sprite {

        protected var invalidHash:Object;
        protected var inCallLater:Boolean;

        protected var instanceStyles:Object;
        protected var sharedStyles:Object; // Holds a reference to the class-level styles.

        protected var _uiStyle:String;
        protected var _width:Number;
        protected var _height:Number;

        public function UIComponent(uiStyleName:String = null) {
            super();

            tabEnabled = false;
            tabChildren = false;

            invalidHash = {};
            inCallLater = false;
            instanceStyles = {};
            sharedStyles = {};

            StyleManager.registerInstance(this);
            if (uiStyleName == null) {
                uiStyleName = StyleManager.getComponentUiStyle(this);
            }
            uiStyle = uiStyleName;

            configUI();
            invalidate(InvalidationType.ALL);
        }

        protected function configUI():void {
        }

        public function set uiStyle(value:String):void {
            if (value == _uiStyle) {
                return;
            }
            _uiStyle = value;
            var styleObj:Object = StyleManager.getStyles(this, _uiStyle);
            if (styleObj == null) {
                throw new Error(this + ".uiStyle " + uiStyle + "doesn't exist.");
            }
            sharedStyles = styleObj;
            var w:Number = getStyle("width") as Number;
            var h:Number = getStyle("height") as Number;
            setSize(w, h);
            invalidate(InvalidationType.STYLES);
        }

        public function get uiStyle():String {
            return _uiStyle;
        }

        public function setUiStyle(value:String, clear:Boolean = false):void {
            uiStyle = value;
            if (clear) {
                instanceStyles = {};
            }
        }

        public function setStyles(styleObj:Object):void {
            for (var style:String in styleObj)
                setStyle(style, styleObj[style]);
        }

        public function setStyle(style:String, value:Object):void {
            //Use strict equality so we can set a style to null ... so if the instanceStyles[style] == undefined, null is still set.
            //We also need to work around the specific use case of TextFormats
            if (instanceStyles[style] === value && !(value is TextFormat)) {
                return;
            }
            instanceStyles[style] = value;
            invalidate(InvalidationType.STYLES);
        }

        public function clearStyles(styles:Array):void {
            for each(var style:String in styles)
                setStyle(style, null);
        }

        public function clearStyle(style:String):void {
            setStyle(style, null);
        }

        public function getStyle(style:String):Object {
            return (instanceStyles[style] == null) ? sharedStyles[style] : instanceStyles[style];
        }

        protected function copyStylesToChild(child:UIComponent, styleObj:Object):void {
            for (var style:String in styleObj) {
                child.setStyle(style, getStyle(styleObj[style]));
            }
        }

        public function setSize(width:Number, height:Number):void {
            _width = width;
            _height = height;
            invalidate(InvalidationType.SIZE);
        }

        override public function get width():Number {
            return _width;
        }

        override public function set width(value:Number):void {
            if (_width == value) {
                return;
            }
            setSize(value, height);
        }

        override public function get height():Number {
            return _height;
        }

        override public function set height(value:Number):void {
            if (_height == value) {
                return;
            }
            setSize(width, value);
        }

        public function move(x:Number, y:Number):void {
            super.x = Math.round(x);
            super.y = Math.round(y);
        }

        override public function set x(value:Number):void {
            super.x = Math.round(value);
        }

        override public function set y(value:Number):void {
            super.y = Math.round(value);
        }

        public function validateNow():void {
            invalidate(InvalidationType.ALL, false);
            draw();
        }

        public function invalidate(property:String = InvalidationType.ALL, callLater:Boolean = true):void {
            invalidHash[property] = true;
            if (callLater) {
                this.callLater();
            }
        }

        protected function validate():void {
            invalidHash = {};
        }

        // Included the first property as a proper param to enable *some* type checking, and also because it is a required param.
        protected function isInvalid(property:String, ...properties:Array):Boolean {
            if (invalidHash[property] || invalidHash[InvalidationType.ALL]) {
                return true;
            }
            while (properties.length > 0) {
                if (invalidHash[properties.pop()]) {
                    return true;
                }
            }
            return false;
        }

        public function drawNow():void {
            draw();
        }

        protected function draw():void {
            // classes that extend UIComponent should deal with each possible invalidated property
            // common values include all, size, enabled, styles, state
            // draw should call super or validate when finished updating
            validate();
        }

        protected function callLater():void {
            if (inCallLater) {
                return;
            }
            inCallLater = true;

            if (stage != null) {
                try {
                    stage.addEventListener(Event.RENDER, callLaterDispatcher, false, 0, true);
                    stage.invalidate();
                } catch (se:SecurityError) {
                    addEventListener(Event.ENTER_FRAME, callLaterDispatcher, false, 0, true);
                }
            } else {
                addEventListener(Event.ADDED_TO_STAGE, callLaterDispatcher, false, 0, true);
            }
        }

        private function callLaterDispatcher(event:Event):void {
            if (event.type == Event.ADDED_TO_STAGE) {
                removeEventListener(Event.ADDED_TO_STAGE, callLaterDispatcher);
                try {
                    // now we can listen for render event:
                    stage.addEventListener(Event.RENDER, callLaterDispatcher, false, 0, true);
                    stage.invalidate();
                } catch (se1:SecurityError) {
                    addEventListener(Event.ENTER_FRAME, callLaterDispatcher, false, 0, true);
                }
                return;
            } else {
                stage.removeEventListener(Event.RENDER, callLaterDispatcher);
                removeEventListener(Event.ENTER_FRAME, callLaterDispatcher);
                try {
                    if (stage == null) {
                        // received render, but the stage is not available, so we will listen for addedToStage again:
                        addEventListener(Event.ADDED_TO_STAGE, callLaterDispatcher, false, 0, true);
                        return;
                    }
                } catch (se2:SecurityError) {
                }
            }

            draw();
            inCallLater = false;
        }

        private static var bitmapDataCache:Dictionary = new Dictionary();

        protected function getDisplayObjectInstance(skin:Object):DisplayObject {
            var obj:Object = null;
            var classDef:Object = null;
            if (skin is Class) {
                obj = new skin();
                if (obj is BitmapData) {
                    return new Bitmap(obj as BitmapData);
                }
                return (obj as DisplayObject);
            } else if (skin is DisplayObject) {
                (skin as DisplayObject).x = 0;
                (skin as DisplayObject).y = 0;
                return skin as DisplayObject;
            } else if (skin is BitmapData) {
                return new Bitmap(skin as BitmapData);
            }

            var bitmapData:BitmapData = bitmapDataCache[skin.toString()];
            if (bitmapData) {
                return new Bitmap(bitmapData);
            }
            try {
                classDef = getDefinitionByName(skin.toString());
            } catch (e:Error) {
                try {
                    classDef = loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object;
                } catch (e:Error) {
                    // Nothing
                }
            }

            if (classDef == null) {
                throw new Error(skin + " class is null.");
                return null;
            }
            obj = new classDef();
            if (obj is BitmapData) {
                bitmapDataCache[skin.toString()] = obj;
                return new Bitmap(obj as BitmapData);
            }
            return obj as DisplayObject;
        }

    }

}