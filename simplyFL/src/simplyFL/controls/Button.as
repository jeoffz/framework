// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.controls {

    import flash.display.DisplayObject;
    import flash.text.TextFormat;

    import simplyFL.core.InvalidationType;
    import simplyFL.core.Label;
    import simplyFL.defines.ButtonLabelPlacement;

    //--------------------------------------
    //  Events
    //--------------------------------------

    [Event(name="change", type="flash.events.Event")]

    //--------------------------------------
    //  Styles
    //--------------------------------------

    [Style(name="upSkin", type="Class")]
    [Style(name="overSkin", type="Class")]
    [Style(name="downSkin", type="Class")]
    [Style(name="disabledSkin", type="Class")]

    [Style(name="selectedUpSkin", type="Class")]
    [Style(name="selectedOverSkin", type="Class")]
    [Style(name="selectedDownSkin", type="Class")]
    [Style(name="selectedDisabledSkin", type="Class")]

    [Style(name="icon", type="Class")]

    [Style(name="upIcon", type="Class")]
    [Style(name="downIcon", type="Class")]
    [Style(name="overIcon", type="Class")]
    [Style(name="disabledIcon", type="Class")]

    [Style(name="selectedDisabledIcon", type="Class")]
    [Style(name="selectedUpIcon", type="Class")]
    [Style(name="selectedDownIcon", type="Class")]
    [Style(name="selectedOverIcon", type="Class")]

    [Style(name="textPadding", type="Number")]
    [Style(name="embedFonts", type="Boolean")]
    [Style(name="textFormat", type="flash.text.TextFormat")]
    [Style(name="disabledTextFormat", type="flash.text.TextFormat")]

    [Style(name="repeatDelay", type="Number", format="Time")]
    [Style(name="repeatInterval", type="Number", format="Time")]

    //--------------------------------------
    //  Class description
    //--------------------------------------

    public class Button extends BaseButton {

        public var labelField:Label;

        protected var _labelPlacement:String = ButtonLabelPlacement.RIGHT;

        protected var _icon:DisplayObject;

        protected var _label:String = "Label";

        public function Button(uiStyleObj:Object = null) {
            super(uiStyleObj);
        }

        override protected function configUI():void {
            super.configUI();

            labelField = new Label();
            addChild(labelField);
        }

        public function get label():String {
            return _label;
        }

        public function set label(value:String):void {
            _label = value;
            labelField.text = _label;
            invalidate(InvalidationType.SIZE);
            invalidate(InvalidationType.STYLES);
        }

        public function get labelPlacement():String {
            return _labelPlacement;
        }

        public function set labelPlacement(value:String):void {
            _labelPlacement = value;
            invalidate(InvalidationType.SIZE);
        }

        override protected function draw():void {
            if (labelField.text != _label) {
                label = _label;
            }

            if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE)) {
                drawBackground();
                drawIcon();
                drawTextFormat();

                invalidate(InvalidationType.SIZE, false);
            }
            if (isInvalid(InvalidationType.SIZE)) {
                drawLayout();
            }
            validate(); // because we're not calling super.draw
        }

        protected function drawIcon():void {
            var oldIcon:DisplayObject = _icon;

            var styleName:String = (enabled) ? _mouseState : "disabled";
            if (selected) {
                styleName = "selected" + styleName.substr(0, 1).toUpperCase() + styleName.substr(1);
            }
            styleName += "Icon";

            var iconStyle:Object = getStyle(styleName);
            if (iconStyle == null) {
                // try the default icon:
                iconStyle = getStyle("icon");
            }
            if (iconStyle != null) {
                _icon = getDisplayObjectInstance(iconStyle);
            }
            if (_icon != null) {
                addChildAt(_icon, 1);
            }

            if (oldIcon != null && oldIcon != _icon) {
                removeChild(oldIcon);
            }
        }

        protected function drawTextFormat():void {
            var tf:TextFormat = getStyle(enabled ? "textFormat" : "disabledTextFormat") as TextFormat;
            labelField.setTextFormat(tf);
            labelField.defaultTextFormat = tf;
            setEmbedFont();
        }

        protected function setEmbedFont():void {
            var embed:Object = getStyle("embedFonts");
            if (embed != null) {
                labelField.embedFonts = embed;
            }
        }

        override protected function drawLayout():void {
            var txtPad:Number = Number(getStyle("textPadding"));
            var placement:String = (_icon == null) ? ButtonLabelPlacement.TOP : _labelPlacement;
            labelField.height = labelField.textHeight + 4;

            var txtW:Number = labelField.textWidth + 4;
            var txtH:Number = labelField.textHeight + 4;

            var paddedIconW:Number = (_icon == null) ? 0 : _icon.width + txtPad;
            var paddedIconH:Number = (_icon == null) ? 0 : _icon.height + txtPad;
            labelField.visible = (label.length > 0);

            if (_icon != null) {
                _icon.x = Math.round((width - _icon.width) / 2);
                _icon.y = Math.round((height - _icon.height) / 2);
            }

            var tmpWidth:Number;
            var tmpHeight:Number;

            if (labelField.visible == false) {
                labelField.width = 0;
                labelField.height = 0;
            } else if (placement == ButtonLabelPlacement.BOTTOM || placement == ButtonLabelPlacement.TOP) {
                tmpWidth = Math.max(0, Math.min(txtW, width - 2 * txtPad));
                if (height - 2 > txtH) {
                    tmpHeight = txtH;
                } else {
                    tmpHeight = height - 2;
                }

                labelField.width = txtW = tmpWidth;
                labelField.height = txtH = tmpHeight;

                labelField.x = Math.round((width - txtW) / 2);
                labelField.y = Math.round((height - labelField.height - paddedIconH) / 2 + ((placement == ButtonLabelPlacement.BOTTOM) ? paddedIconH : 0));
                if (_icon != null) {
                    _icon.y = Math.round((placement == ButtonLabelPlacement.BOTTOM) ? labelField.y - paddedIconH : labelField.y + labelField.height + txtPad);
                }
            } else {
                tmpWidth = Math.max(0, Math.min(txtW, width - paddedIconW - 2 * txtPad));
                labelField.width = txtW = tmpWidth;

                labelField.x = Math.round((width - txtW - paddedIconW) / 2 + ((placement != ButtonLabelPlacement.LEFT) ? paddedIconW : 0));
                labelField.y = Math.round((height - labelField.height) / 2);
                if (_icon != null) {
                    _icon.x = Math.round((placement != ButtonLabelPlacement.LEFT) ? labelField.x - paddedIconW : labelField.x + txtW + txtPad);
                }
            }
            super.drawLayout();
        }

    }
}