// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.controls {

    import flash.events.Event;
    import flash.events.MouseEvent;

    import simplyFL.core.InvalidationType;
    import simplyFL.core.UIComponent;
    import simplyFL.defines.ScrollBarDirection;
    import simplyFL.events.ComponentEvent;
    import simplyFL.events.ScrollEvent;

    //--------------------------------------
    //  Events
    //--------------------------------------

	[Event(name="scroll", type="simplyFL.events.ScrollEvent") ]
	
    //--------------------------------------
    //  Styles
    //--------------------------------------	

    [Style(name="downArrowDisabledSkin", type="Class")]
    [Style(name="downArrowDownSkin", type="Class")]
    [Style(name="downArrowOverSkin", type="Class")]
    [Style(name="downArrowUpSkin", type="Class")]

    [Style(name="thumbDisabledSkin", type="Class")]
    [Style(name="thumbDownSkin", type="Class")]
    [Style(name="thumbOverSkin", type="Class")]
    [Style(name="thumbUpSkin", type="Class")]

    [Style(name="trackDisabledSkin", type="Class")]
    [Style(name="trackDownSkin", type="Class")]
    [Style(name="trackOverSkin", type="Class")]
    [Style(name="trackUpSkin", type="Class")]

    [Style(name="upArrowDisabledSkin", type="Class")]
    [Style(name="upArrowDownSkin", type="Class")]
    [Style(name="upArrowOverSkin", type="Class")]
    [Style(name="upArrowUpSkin", type="Class")]

    [Style(name="thumbIcon", type="Class")]

    [Style(name="repeatDelay", type="Number")]
    [Style(name="repeatInterval", type="Number")]

    [Style(name="width", type="Number")]
    [Style(name="height", type="Number")]
    [Style(name="arrowHeight", type="Number")]

    //--------------------------------------
    //  Class description
    //--------------------------------------

	public class ScrollBar extends UIComponent {

        private var _pageSize:Number = 10;
        private var _pageScrollSize:Number = 0;
        private var _lineScrollSize:Number = 1;
        private var _minScrollPosition:Number = 0;
        private var _maxScrollPosition:Number = 0;
        private var _scrollPosition:Number = 0;
        private var _direction:String = ScrollBarDirection.VERTICAL;

        private var thumbScrollOffset:Number;

        protected var _enabled:Boolean = true;
		protected var inDrag:Boolean = false;

		protected var upArrow:BaseButton;
		protected var downArrow:BaseButton;
		protected var thumb:Button;
		protected var track:BaseButton;

        protected static const DOWN_ARROW_STYLES:Object = {
            disabledSkin: "downArrowDisabledSkin",
            downSkin: "downArrowDownSkin",
            overSkin: "downArrowOverSkin",
            upSkin: "downArrowUpSkin",
            repeatDelay: "repeatDelay",
            repeatInterval: "repeatInterval"
        };

		protected static const THUMB_STYLES:Object = {
            disabledSkin:"thumbDisabledSkin",
            downSkin:"thumbDownSkin",
            overSkin:"thumbOverSkin",
            upSkin:"thumbUpSkin",
            icon:"thumbIcon",
            textPadding: 0
        };

		protected static const TRACK_STYLES:Object = {
            disabledSkin:"trackDisabledSkin",
            downSkin:"trackDownSkin",
            overSkin:"trackOverSkin",
            upSkin:"trackUpSkin",
            repeatDelay:"repeatDelay",
            repeatInterval:"repeatInterval"
        };

        protected static const UP_ARROW_STYLES:Object = {
            disabledSkin: "upArrowDisabledSkin",
            downSkin: "upArrowDownSkin",
            overSkin: "upArrowOverSkin",
            upSkin: "upArrowUpSkin",
            repeatDelay: "repeatDelay",
            repeatInterval: "repeatInterval"
        };

		public function ScrollBar() {
			super();
			setChildStyles();
		}

        protected function setChildStyles():void {
            copyStylesToChild(downArrow,DOWN_ARROW_STYLES);
            copyStylesToChild(thumb,THUMB_STYLES);
            copyStylesToChild(track,TRACK_STYLES);
            copyStylesToChild(upArrow,UP_ARROW_STYLES);
        }

		override public function setSize(width:Number, height:Number):void {
			if (_direction == ScrollBarDirection.HORIZONTAL) {
				super.setSize(height,width);
			} else {
				super.setSize(width,height);
			}
		}

		override public function get width():Number {
			return (_direction == ScrollBarDirection.HORIZONTAL) ? super.height : super.width;
		}

		override public function get height():Number {
			return (_direction == ScrollBarDirection.HORIZONTAL) ? super.width : super.height;
		}

		public function get enabled():Boolean {
            return _enabled;
		}

		public function set enabled(value:Boolean):void {
            if (value == _enabled) { return; }
            _enabled = value;
			downArrow.enabled = track.enabled = thumb.enabled = upArrow.enabled = enabled;
            thumb.visible = enabled;
            invalidate(InvalidationType.STATE);
		}

		public function get scrollPosition():Number { return _scrollPosition; }
		public function set scrollPosition(newScrollPosition:Number):void {
			setScrollPosition(newScrollPosition, true);
		}

		public function get minScrollPosition():Number {
			return _minScrollPosition;
		}		
		public function set minScrollPosition(value:Number):void {
            if(value == _minScrollPosition) { return; }
            _minScrollPosition = value;
            setScrollPosition(_scrollPosition, false);
            updateThumb();
		}

		public function get maxScrollPosition():Number {
			return _maxScrollPosition;
		}		
		public function set maxScrollPosition(value:Number):void {
            if(value == _maxScrollPosition) { return; }
            _maxScrollPosition = value;
            setScrollPosition(_scrollPosition, false);
            updateThumb();
		}

		public function get pageSize():Number {
			return _pageSize;
		}

		public function set pageSize(value:Number):void {
			if (value > 0 && value != _pageSize) {
				_pageSize = value;
                updateThumb();
			}
		}

		public function get pageScrollSize():Number {
			return (_pageScrollSize == 0) ? _pageSize : _pageScrollSize;
		}

		public function set pageScrollSize(value:Number):void {
			if (value>=0) { _pageScrollSize = value; }
		}

		public function get lineScrollSize():Number {
			return _lineScrollSize;
		}		

		public function set lineScrollSize(value:Number):void {
			if (value>0) {_lineScrollSize = value; }
		}

		public function get direction():String {
			return _direction;
		}

		public function set direction(value:String):void {
			if (_direction == value) { return; }
			_direction = value;
			if (isLivePreview) { return; } // Rotation and scaling happens automatically in LivePreview.
			//
			setScaleY(1);			
			
			var horizontal:Boolean = _direction == ScrollBarDirection.HORIZONTAL;
            if (horizontal && rotation == 0) {
                rotation = -90;
                setScaleX(-1);
            } else if (!horizontal && rotation == -90 ) {
                rotation = 0;
                setScaleX(1);
            }
			invalidate(InvalidationType.SIZE);
		}

		override protected function configUI():void {
			super.configUI();
			
			track = new BaseButton();
			track.autoRepeat = true;
			addChild(track);
			
			thumb = new Button();
			thumb.label = "";
			addChild(thumb);
			
			downArrow = new BaseButton();
			downArrow.autoRepeat = true;
			addChild(downArrow);
			
			upArrow = new BaseButton();
			upArrow.autoRepeat = true;
			addChild(upArrow);
			
			upArrow.addEventListener(ComponentEvent.BUTTON_DOWN,scrollPressHandler,false,0,true);
			downArrow.addEventListener(ComponentEvent.BUTTON_DOWN,scrollPressHandler,false,0,true);
			track.addEventListener(ComponentEvent.BUTTON_DOWN,scrollPressHandler,false,0,true);
			thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbPressHandler,false,0,true);
		}

		override protected function draw():void {	
			if (isInvalid(InvalidationType.SIZE)) {
                drawBackground();
				updateThumb();
			}
			if (isInvalid(InvalidationType.STYLES)) {
                setChildStyles();
			}
			// Call drawNow on nested components to get around problems with nested render events:
			downArrow.drawNow();
			upArrow.drawNow();
			track.drawNow();
			thumb.drawNow();
			validate();
		}

		protected function scrollPressHandler(event:ComponentEvent):void {
			event.stopImmediatePropagation();
			if (event.currentTarget == upArrow) {
				setScrollPosition(_scrollPosition-_lineScrollSize); 
			} else if (event.currentTarget == downArrow) {
				setScrollPosition(_scrollPosition+_lineScrollSize);
			} else {
				var mousePosition:Number = (track.mouseY)/track.height * (_maxScrollPosition-_minScrollPosition) + _minScrollPosition;
				var pgScroll:Number = (pageScrollSize == 0)?pageSize:pageScrollSize;
				if (_scrollPosition < mousePosition) {
					setScrollPosition(Math.min(mousePosition,_scrollPosition+pgScroll));
				} else if (_scrollPosition > mousePosition) {
					setScrollPosition(Math.max(mousePosition,_scrollPosition-pgScroll));
				}
			}
		}

		protected function thumbPressHandler(event:MouseEvent):void {
			inDrag = true;
			thumbScrollOffset = mouseY-thumb.y;
			thumb.mouseStateLocked = true;
			mouseChildren = false; // Should be able to do stage.mouseChildren, but doesn't seem to work.

            stage.addEventListener(MouseEvent.MOUSE_MOVE,handleThumbDrag,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP,thumbReleaseHandler,false,0,true);
            stage.addEventListener(Event.DEACTIVATE,thumbReleaseHandler,false,0,true);
            this.addEventListener(Event.REMOVED_FROM_STAGE,thumbReleaseHandler,false,0,true);
		}

		protected function handleThumbDrag(event:MouseEvent):void {
			var pos:Number = Math.max(0, Math.min(track.height-thumb.height, mouseY-track.y-thumbScrollOffset));
			if(track.height == thumb.height) {
                setScrollPosition(0);
            }else {
                setScrollPosition(pos / (track.height - thumb.height) * (_maxScrollPosition - _minScrollPosition) + _minScrollPosition);
            }
		}

		protected function thumbReleaseHandler(event:Event):void {
			inDrag = false;
			mouseChildren = true;
			thumb.mouseStateLocked = false;

			stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleThumbDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP,thumbReleaseHandler);
            stage.removeEventListener(Event.DEACTIVATE,thumbReleaseHandler);
            this.removeEventListener(Event.REMOVED_FROM_STAGE,thumbReleaseHandler);
		}

		public function setScrollPosition(newScrollPosition:Number, fireEvent:Boolean=true):void {
			var oldPosition:Number = scrollPosition;
			_scrollPosition = Math.max(_minScrollPosition,Math.min(_maxScrollPosition, newScrollPosition));
			if (oldPosition == _scrollPosition) { return; }
			if (fireEvent) { dispatchEvent(new ScrollEvent(_direction, scrollPosition-oldPosition, scrollPosition)); }
			updateThumb();
		}

        protected function drawBackground():void {
            var w:Number = Number(getStyle("width"));
            var arrowH:Number = Number(getStyle("arrowHeight"));
            var h:Number = super.height;
            upArrow.setSize(w,arrowH);
            downArrow.setSize(w,arrowH);
            track.setSize(w, Math.max(0, h-(downArrow.height + upArrow.height)));
            thumb.width = w;

            upArrow.move(0,0);
            downArrow.move(0, Math.max(upArrow.height, h-downArrow.height));
            track.move(0,upArrow.height);
        }

		protected function updateThumb():void {
			var per:Number = _maxScrollPosition - _minScrollPosition + _pageSize;
			if (track.height <= 12 || _maxScrollPosition < _minScrollPosition || (per == 0 || isNaN(per))) {
				thumb.height = 12;
				thumb.visible = false;
			} else {
                thumb.height = Math.max(13, _pageSize / per * track.height);
                if (_maxScrollPosition == _minScrollPosition) {
                    thumb.y = track.y;
                }else {
                    thumb.y = track.y + (track.height - thumb.height) * ((_scrollPosition - _minScrollPosition) / (_maxScrollPosition - _minScrollPosition));
                }
				thumb.visible = enabled;
			}
		}
	}
}
