// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.controls {

    import flash.events.Event;
    import flash.events.EventDispatcher;

    //--------------------------------------
    //  Events
    //--------------------------------------	

    [Event(name="change", type="flash.events.Event")]

    //--------------------------------------
    //  Class description
    //--------------------------------------

    public class RadioButtonGroup extends EventDispatcher {

        private static var groups:Object;

        private static var groupCount:uint = 0;

        public static function getGroup(name:String):RadioButtonGroup {
            if (groups == null) {
                groups = {};
            }
            var group:RadioButtonGroup = groups[name] as RadioButtonGroup;
            if (group == null) {
                group = new RadioButtonGroup(name);
                // every so often, we should clean up old groups:
                if ((++groupCount) % 20 == 0) {
                    cleanUpGroups();
                }
            }
            return group;
        }

        private static function registerGroup(group:RadioButtonGroup):void {
            if (groups == null) {
                groups = {}
            }
            groups[group.name] = group;
        }

        private static function cleanUpGroups():void {
            for (var n:String in groups) {
                var group:RadioButtonGroup = groups[n] as RadioButtonGroup;
                if (group.radioButtons.length == 0) {
                    delete(groups[n]);
                }
            }
        }

        protected var _name:String;

        protected var radioButtons:Array;

        protected var _selection:RadioButton;

        // Should be a private constructor, but not allowed in AS3,
        // so instead we'll make it work properly if you create a new
        // RadioButtonGroup manually.
        public function RadioButtonGroup(name:String) {
            _name = name;
            radioButtons = [];
            registerGroup(this);
        }

        public function get name():String {
            return _name;
        }

        public function addRadioButton(radioButton:RadioButton):void {
            if (radioButton.groupName != name) {
                radioButton.groupName = name;
                return;
            }
            radioButtons.push(radioButton);
            if (radioButton.selected) {
                selection = radioButton;
            }
        }

        public function removeRadioButton(radioButton:RadioButton):void {
            var i:int = getRadioButtonIndex(radioButton);
            if (i != -1) {
                radioButtons.splice(i, 1);
            }
            if (_selection == radioButton) {
                _selection = null;
            }
        }

        public function get selection():RadioButton {
            return _selection;
        }

        public function set selection(value:RadioButton):void {
            if (_selection == value || value == null || getRadioButtonIndex(value) == -1) {
                return;
            }
            _selection = value;
            dispatchEvent(new Event(Event.CHANGE, true));
        }

        public function get selectedData():Object {
            var s:RadioButton = _selection;
            return (s == null) ? null : s.data;
        }

        public function set selectedData(value:Object):void {
            for (var i:int = 0; i < radioButtons.length; i++) {
                var rb:RadioButton = radioButtons[i] as RadioButton;
                if (rb.data == value) {
                    selection = rb;
                    return;
                }
            }
        }

        public function getRadioButtonIndex(radioButton:RadioButton):int {
            for (var i:int = 0; i < radioButtons.length; i++) {
                var rb:RadioButton = radioButtons[i] as RadioButton;
                if (rb == radioButton) {
                    return i;
                }
            }
            return -1;
        }

        public function getRadioButtonAt(index:int):RadioButton {
            return RadioButton(radioButtons[index]);
        }

        public function get numRadioButtons():int {
            return radioButtons.length;
        }
    }
}
