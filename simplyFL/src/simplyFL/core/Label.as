/**
 * Created by zhujiahe on 2015/7/27.
 */
package simplyFL.core {

    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    public class Label extends TextField {

        public static var DefaultTextFormat:TextFormat = new TextFormat("_sans", 12, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);

        public function Label() {
            super();

            type = TextFieldType.DYNAMIC;
            selectable = false;
            defaultTextFormat = DefaultTextFormat;
            setSize(88, 22);
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

        public function setSize(width:Number, height:Number):void {
            super.width = width;
            super.height = height;
        }

        public function set align(value:String):void {
            var textFormat:TextFormat = defaultTextFormat;
            textFormat.align = value;
            defaultTextFormat = textFormat;
            setTextFormat(defaultTextFormat);
        }

        public function get align():String {
            return defaultTextFormat.align;
        }

        public function set font(value:String):void {
            var textFormat:TextFormat = defaultTextFormat;
            textFormat.font = value;
            defaultTextFormat = textFormat;
            setTextFormat(defaultTextFormat);
        }

        public function get font():String {
            return defaultTextFormat.font;
        }

        public function set fontsize(value:int):void {
            var textFormat:TextFormat = defaultTextFormat;
            textFormat.size = value;
            defaultTextFormat = textFormat;
            setTextFormat(defaultTextFormat);
        }

        public function get fontsize():int {
            return int(defaultTextFormat.size);
        }

        /**
         * @example: labelField.setFormat({font:"sans", bold:true});
         */
        public function setFormat(formats:Object):void {
            if (formats == null) {
                return;
            }

            var textFormat:TextFormat = defaultTextFormat;
            setTextFormatbyObject(textFormat, formats);
            defaultTextFormat = textFormat;
            setTextFormat(defaultTextFormat);
        }

        protected function setTextFormatbyObject(textFormat:TextFormat, formats:Object):void {
            for (var formatName:String in formats) {
                if (textFormat.hasOwnProperty(formatName)) {
                    textFormat[formatName] = formats[formatName];
                }
            }
        }

    }
}
