// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.controls {

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import simplyFL.events.ComponentEvent;

    import simplyFL.core.InvalidationType;
	import simplyFL.core.UIComponent;

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

    [Style(name="repeatDelay", type="Number", format="Time")]
    [Style(name="repeatInterval", type="Number", format="Time")]

    [Style(name="width", type="Number")]
    [Style(name="height", type="Number")]

    //--------------------------------------
    //  Class description
    //--------------------------------------

	public class BaseButton extends UIComponent {

		protected var _background:DisplayObject;

		protected var _mouseState:String;

		protected var _toggle:Boolean = false;

		protected var _selected:Boolean = false;

		protected var _enabled:Boolean = true;

        protected var _autoRepeat:Boolean = false;

        protected var pressTimer:Timer;

        private var _mouseStateLocked:Boolean = false;

        private var unlockedMouseState:String;

		public function BaseButton() {
			super();

			buttonMode = true;
			mouseChildren = false;
			useHandCursor = false;

			setupMouseEvents();
            setMouseState("up");
		}

		[Inspectable(defaultValue=false)]
		public function get toggle():Boolean { return _toggle; }
		public function set toggle(value:Boolean):void {
			if(_toggle == value) { return; }
			if (!value && selected) { selected = false; }
			_toggle = value;
			if (_toggle) { addEventListener(MouseEvent.CLICK,toggleSelected,false,0,true); }
			else { removeEventListener(MouseEvent.CLICK,toggleSelected); }
			invalidate(InvalidationType.STATE);
		}

		protected function toggleSelected(event:MouseEvent):void {
			selected = !selected;
			dispatchEvent(new Event(Event.CHANGE, true));
		}

		[Inspectable(defaultValue=true)]
		public function get selected():Boolean {
			return (_toggle) ? _selected : false;
		}
		public function set selected(value:Boolean):void {
            if(value == _selected) {return ;}
			_selected = value;
			if (_toggle) {
				invalidate(InvalidationType.STATE);
			}
		}

		[Inspectable(defaultValue=true)]
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void {
			if (_enabled == value) { return; }
			_enabled = value;
			invalidate(InvalidationType.STATE);
			mouseEnabled = value;
		}

        public function get autoRepeat():Boolean { return _autoRepeat; }
        public function set autoRepeat(value:Boolean):void {
            _autoRepeat = value;
        }

        protected function startPress():void {
            if (_autoRepeat) {
                if(pressTimer == null) {
                    pressTimer = new Timer(1,0);
                    pressTimer.addEventListener(TimerEvent.TIMER,buttonDown,false,0,true);
                }
                pressTimer.delay = Number(getStyle("repeatDelay"));
                pressTimer.start();
            }
            dispatchEvent(new ComponentEvent(ComponentEvent.BUTTON_DOWN, true));
        }

        protected function endPress():void {
            if(pressTimer) { pressTimer.reset(); }
        }

        protected function buttonDown(event:TimerEvent):void {
            if (!_autoRepeat) { endPress(); return; }
            if (pressTimer.currentCount == 1) { pressTimer.delay = Number(getStyle("repeatInterval")); }
            dispatchEvent(new ComponentEvent(ComponentEvent.BUTTON_DOWN, true));
        }

        public function set mouseStateLocked(value:Boolean):void {
            _mouseStateLocked = value;
            if (value == false) { setMouseState(unlockedMouseState); }
            else { unlockedMouseState = _mouseState; }
        }

        public function setMouseState(state:String):void {
            if (_mouseStateLocked) { unlockedMouseState = state; return; }
            if (_mouseState == state) { return; }
            _mouseState = state;
            invalidate(InvalidationType.STATE);
        }

		protected function setupMouseEvents():void {
			addEventListener(MouseEvent.ROLL_OVER,mouseEventHandler,false,0,true);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseEventHandler,false,0,true);
			addEventListener(MouseEvent.MOUSE_UP,mouseEventHandler,false,0,true);
			addEventListener(MouseEvent.ROLL_OUT,mouseEventHandler,false,0,true);
		}

		protected function mouseEventHandler(event:MouseEvent):void {
			if (event.type == MouseEvent.MOUSE_DOWN) {
				setMouseState("down");
                startPress();
			} else if (event.type == MouseEvent.ROLL_OVER || event.type == MouseEvent.MOUSE_UP) {
                setMouseState("over");
                endPress();
			} else if (event.type == MouseEvent.ROLL_OUT) {
                setMouseState("up");
                endPress();
			}
		}

		override protected function draw():void {
			if (isInvalid(InvalidationType.STYLES,InvalidationType.STATE)) {
				drawBackground();
				invalidate(InvalidationType.SIZE,false); // invalidates size without calling draw next frame.
			}
			if (isInvalid(InvalidationType.SIZE)) {
				drawLayout();
			}
			super.draw();
		}

		protected function drawBackground():void {
			var styleName:String = (enabled) ? _mouseState : "disabled";
			if (selected) { styleName = "selected"+styleName.substr(0,1).toUpperCase()+styleName.substr(1); }
			styleName += "Skin";
			var bg:DisplayObject = _background;
			_background = getDisplayObjectInstance(getStyle(styleName));
			addChildAt(_background, 0);
			if (bg != null && bg != _background) { removeChild(bg); }
		}

		protected function drawLayout():void {
			_background.width = width;
			_background.height = height;
		}
	}
}