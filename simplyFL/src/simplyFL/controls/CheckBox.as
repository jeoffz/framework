// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.controls {

    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Shape;

    import simplyFL.defines.ButtonLabelPlacement;

    //--------------------------------------
    //  Events
    //--------------------------------------

    [Event(name="change", type="flash.events.Event")]

    //--------------------------------------
    //  Styles
    //--------------------------------------

    [Style(name="icon", type="Class")]

    [Style(name="upIcon", type="Class")]
    [Style(name="overIcon", type="Class")]
    [Style(name="downIcon", type="Class")]
    [Style(name="disabledIcon", type="Class")]

    [Style(name="selectedUpIcon", type="Class")]
    [Style(name="selectedOverIcon", type="Class")]
    [Style(name="selectedDownIcon", type="Class")]
    [Style(name="selectedDisabledIcon", type="Class")]

    [Style(name="textPadding", type="Number")]
    [Style(name="embedFonts", type="Boolean")]
    [Style(name="textFormat", type="flash.text.TextFormat")]
    [Style(name="disabledTextFormat", type="flash.text.TextFormat")]

    //--------------------------------------
    //  Class description
    //--------------------------------------

    public class CheckBox extends Button {

        public function CheckBox(uiStyleObj:Object = null) {
            super(uiStyleObj);
        }

        override protected function configUI():void {
            super.configUI();
            super.toggle = true;

            var bg:Shape = new Shape();
            var g:Graphics = bg.graphics;
            g.beginFill(0, 0);
            g.drawRect(0, 0, 100, 100);
            g.endFill();
            _background = bg as DisplayObject;
            addChildAt(_background, 0);
        }

        override public function get toggle():Boolean {
            return true;
        }

        override public function set toggle(value:Boolean):void {
            throw new Error("Warning: You cannot change a CheckBox's toggle.");
        }

        override public function get autoRepeat():Boolean {
            return false;
        }

        override public function set autoRepeat(value:Boolean):void {
            return;
        }

        override protected function drawLayout():void {
            super.drawLayout();

            var textPadding:Number = Number(getStyle("textPadding"));
            switch (_labelPlacement) {
                case ButtonLabelPlacement.RIGHT:
                    _icon.x = textPadding;
                    labelField.x = _icon.x + (_icon.width + textPadding);
                    _background.width = labelField.x + labelField.width + textPadding;
                    _background.height = Math.max(labelField.height, _icon.height) + textPadding * 2;
                    break;
                case ButtonLabelPlacement.LEFT:
                    _icon.x = width - _icon.width - textPadding;
                    labelField.x = width - _icon.width - textPadding * 2 - labelField.width;
                    _background.width = labelField.width + _icon.width + textPadding * 3;
                    _background.height = Math.max(labelField.height, _icon.height) + textPadding * 2;
                    break;
                case ButtonLabelPlacement.TOP:
                case ButtonLabelPlacement.BOTTOM:
                    _background.width = Math.max(labelField.width, _icon.width) + textPadding * 2;
                    _background.height = labelField.height + _icon.height + textPadding * 3;
                    break;
            }
            _background.x = Math.min(_icon.x - textPadding, labelField.x - textPadding);
            _background.y = Math.min(_icon.y - textPadding, labelField.y - textPadding);
        }

        override protected function drawBackground():void {
            // do nothing. Checkbox always uses the same empty background.
        }
    }
}