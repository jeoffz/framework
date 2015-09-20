// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.controls {

    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.text.TextLineMetrics;

    import simplyFL.core.InvalidationType;
    import simplyFL.core.LabelField;
    import simplyFL.core.UIComponent;

    //--------------------------------------
    //  Events
    //--------------------------------------

	[Event(name="change", type="flash.events.Event")]
	[Event(name="textInput", type="flash.events.TextEvent")]

    //--------------------------------------
    //  Styles
    //--------------------------------------

	[Style(name="upSkin", type="Class")]
    [Style(name="disabledSkin", type="Class")]
    [Style(name="overSkin", type="Class")]

    [Style(name="textPadding", type="Number", format="Length")]
	[Style(name="embedFonts", type="Boolean")]
    [Style(name="textFormat", type="flash.text.TextFormat")]
    [Style(name="disabledTextFormat", type="flash.text.TextFormat")]

    [Style(name="width", type="Number")]
    [Style(name="height", type="Number")]

    //--------------------------------------
    //  Class description
    //--------------------------------------
	public class TextInput extends UIComponent {

		public var labelField:LabelField;

        protected var _mouseState:String;

		protected var _editable:Boolean = true;

        protected var _enabled:Boolean = true;

		protected var _background:DisplayObject;

		public function TextInput() { super(); }

        override protected function configUI():void {
            super.configUI();
            labelField = new LabelField();
            addChild(labelField);
            updateTextFieldType();

            labelField.addEventListener(TextEvent.TEXT_INPUT, handleTextInput, false, 0, true);
            labelField.addEventListener(Event.CHANGE, handleChange, false, 0, true);
            addEventListener(FocusEvent.FOCUS_IN, focusInHandler,false, 0, true);
            addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler,false, 0, true);
            addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler,false, 0 ,true);
            addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler,false, 0 ,true);
            setMouseState("up");
        }

		[Inspectable(defaultValue="")]
		public function get text():String {
			return labelField.text;
		}

		public function set text(value:String):void {
			labelField.text = value;
		}

		[Inspectable(defaultValue=true)]
		public function get enabled():Boolean {
			return _enabled;
		}

		public function set enabled(value:Boolean):void {
            if (value == _enabled) { return; }
            _enabled = value;
            invalidate(InvalidationType.STATE);
			updateTextFieldType();
            mouseEnabled = value;
            if(value == false && stage && stage.focus == labelField) {
                stage.focus = stage;
            }
		}

		[Inspectable(defaultValue=true)]
		public function get editable():Boolean {
			return _editable;
		}

		public function set editable(value:Boolean):void {
			_editable = value;
			updateTextFieldType();
		}

		public function get length():int {
			return labelField.length;
		}

		[Inspectable(defaultValue=0)]
		public function get maxChars():int {
			return labelField.maxChars;
		}

		public function set maxChars(value:int):void {
			labelField.maxChars = value;
		}
		
		[Inspectable(defaultValue=false)]
		public function get displayAsPassword():Boolean {
			return labelField.displayAsPassword;
		}
		public function set displayAsPassword(value:Boolean):void {
			labelField.displayAsPassword = value;
		}
		
		[Inspectable(defaultValue="")]
		public function get restrict():String {
			return labelField.restrict;
		}
		public function set restrict(value:String):void {
			if (value == "") { value = null; }
			labelField.restrict = value;
		}

		public function get selectionBeginIndex():int {
			return labelField.selectionBeginIndex;
		}

		public function get selectionEndIndex():int {
			return labelField.selectionEndIndex;
		}

		 public function get condenseWhite():Boolean {
			return labelField.condenseWhite;
		 }
		 public function set condenseWhite(value:Boolean):void {
			labelField.condenseWhite = value;
		 }

		 public function get htmlText():String {
			return labelField.htmlText;
		 }
		 public function set htmlText(value:String):void {
			if (value == "") { 
				text = "";
				return;
			}
			labelField.htmlText = value;
		 }

		public function get textHeight():Number {
			return labelField.textHeight;
		}

		public function get textWidth():Number {
			return labelField.textWidth;
		}

		public function setSelection(beginIndex:int, endIndex:int):void {
			labelField.setSelection(beginIndex, endIndex);
		}

		public function getLineMetrics(index:int):TextLineMetrics {
			return labelField.getLineMetrics(index);
		}

		public function appendText(text:String):void {
			labelField.appendText(text);
		}

		protected function updateTextFieldType():void {
			labelField.type = (enabled && editable) ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			labelField.selectable = enabled;
            labelField.mouseEnabled = enabled;
		}

		protected function handleChange(event:Event):void {
			event.stopPropagation(); // so you don't get two change events
			dispatchEvent(new Event(Event.CHANGE, true));
		}

		protected function handleTextInput(event:TextEvent):void {
			event.stopPropagation();
			dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT, true, false, event.text));
		}

		protected function setEmbedFont():void {
			var embed:Object = getStyle("embedFonts");
			if (embed != null) {
				labelField.embedFonts = embed;
			}	
		}

        public function setMouseState(state:String):void {
            if (_mouseState == state) { return; }
            _mouseState = state;
            invalidate(InvalidationType.STATE);
        }

        protected function mouseEventHandler(event:MouseEvent):void {
            if (event.type == MouseEvent.ROLL_OVER) {
                setMouseState("over");
            } else if (event.type == MouseEvent.ROLL_OUT) {
                setMouseState("up");
            }
        }

		override protected function draw():void {
			if (isInvalid(InvalidationType.STYLES,InvalidationType.STATE)) {
				drawTextFormat();
				drawBackground();
				invalidate(InvalidationType.SIZE,false);
			}
			if (isInvalid(InvalidationType.SIZE)) {
				drawLayout();
			}

			super.draw();
		}

		protected function drawBackground():void {
			var bg:DisplayObject = _background;

            var styleName:String = (enabled ? _mouseState : "disabled") + "Skin";
            if(stage && stage.focus == labelField) {
                styleName = "overSkin";
            }

			_background = getDisplayObjectInstance(getStyle(styleName));
			if (_background == null) { return; }
			addChildAt(_background,0);
			
			if (bg != null && bg != _background && contains(bg)) {
				removeChild(bg); 
			}			
		}

		protected function drawTextFormat():void {
            var tf:TextFormat = getStyle(enabled?"textFormat":"disabledTextFormat") as TextFormat;
            labelField.setTextFormat(tf);
			labelField.defaultTextFormat = tf;
			setEmbedFont();
		}

		protected function drawLayout():void {
			var txtPad:Number = Number(getStyle("textPadding"));
			if (_background != null) {
				_background.width = width;
				_background.height = height;
			}
			labelField.width = width-2*txtPad;
			labelField.height = height-2*txtPad;
			labelField.x = labelField.y = txtPad;
		}

		protected function focusInHandler(event:FocusEvent):void {
			if (event.target == this) {
				stage.focus = labelField;
			}
			if (editable) {
				if (labelField.selectable && labelField.selectionBeginIndex == labelField.selectionBeginIndex) {
					setSelection(0, labelField.length);
				}
			}
            invalidate(InvalidationType.STATE);
		}

		protected function focusOutHandler(event:FocusEvent):void {
            invalidate(InvalidationType.STATE);
		}
	}
}