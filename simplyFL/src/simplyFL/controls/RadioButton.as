// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.controls {

    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.MouseEvent;

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

    public class RadioButton extends Button {

        protected var _data:Object;

        protected var _group:RadioButtonGroup;

        protected var defaultGroupName:String = "RadioButtonGroup";

        public function RadioButton(uiStyleObj:Object = null) {
            super(uiStyleObj);
            groupName = defaultGroupName;
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
            // can't turn toggle off in a radiobutton.
            throw new Error("Warning: You cannot change a RadioButtons toggle.");
        }

        override public function get autoRepeat():Boolean {
            return false;
        }

        override public function set autoRepeat(value:Boolean):void {
            return;
        }

        override public function get selected():Boolean {
            return super.selected;
        }

        override public function set selected(value:Boolean):void {
            // can only set to true in RadioButton:
            if (value == false || selected) {
                return;
            }
            if (_group != null) {
                _group.selection = this;
            }
            else {
                super.selected = value;
            }
        }

        override protected function toggleSelected(event:MouseEvent):void {
            selected = !selected;
        }

        public function get groupName():String {
            return (_group == null) ? null : _group.name;
        }

        public function set groupName(group:String):void {
            if (_group != null) {
                _group.removeRadioButton(this);
                _group.removeEventListener(Event.CHANGE, handleChange);
            }
            _group = (group == null) ? null : RadioButtonGroup.getGroup(group);
            if (_group != null) {
                // Default to the easiest option, which is to select a newly added selected rb.
                _group.addRadioButton(this);
                _group.addEventListener(Event.CHANGE, handleChange, false, 0, true);
            }
        }

        public function get group():RadioButtonGroup {
            return _group;
        }

        public function set group(name:RadioButtonGroup):void {
            groupName = name.name;
        }

        public function get data():Object {
            return _data;
        }

        public function set data(value:Object):void {
            _data = value;
        }

        protected function handleChange(event:Event):void {
            super.selected = (_group.selection == this);
            dispatchEvent(new Event(Event.CHANGE, true));
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
            // Do nothing, handled in BaseButton.drawLayout();
        }

    }
}
