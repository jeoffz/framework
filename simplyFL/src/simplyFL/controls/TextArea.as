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
    import simplyFL.core.Label;
    import simplyFL.core.UIComponent;
    import simplyFL.defines.ScrollBarDirection;
    import simplyFL.defines.ScrollPolicy;
    import simplyFL.events.ScrollEvent;

    //--------------------------------------
    //  Events
    //--------------------------------------

    [Event(name="change", type="flash.events.Event")]
    [Event(name="textInput", type="flash.events.TextEvent")]
    [Event(name="scroll", type="simplyFL.events.ScrollEvent")]

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

    [Style(name="arrowHeight", type="Number")]
    [Style(name="scrollBarWidth", type="Number")]

    [Style(name="upSkin", type="Class")]
    [Style(name="disabledSkin", type="Class")]

    [Style(name="textPadding", type="Number")]
    [Style(name="embedFonts", type="Boolean")]
    [Style(name="textFormat", type="flash.text.TextFormat")]
    [Style(name="disabledTextFormat", type="flash.text.TextFormat")]

    [Style(name="focusRectPadding", type="Number")]
    [Style(name="focusRectSkin", type="Class")]

    //--------------------------------------
    //  Class description
    //--------------------------------------

    public class TextArea extends UIComponent {

        public var labelField:Label;

        protected var _editable:Boolean = true;

        protected var _enabled:Boolean = true;

        protected var _wordWrap:Boolean = true;

        protected var _horizontalScrollPolicy:String = ScrollPolicy.AUTO;

        protected var _verticalScrollPolicy:String = ScrollPolicy.AUTO;

        protected var _horizontalScrollBar:TextScrollBar;

        protected var _verticalScrollBar:TextScrollBar;

        protected var _background:DisplayObject;

        protected var _textHasChanged:Boolean = false;

        protected static const SCROLL_BAR_STYLES:Object = {
            downArrowDisabledSkin: "downArrowDisabledSkin",
            downArrowDownSkin: "downArrowDownSkin",
            downArrowOverSkin: "downArrowOverSkin",
            downArrowUpSkin: "downArrowUpSkin",
            upArrowDisabledSkin: "upArrowDisabledSkin",
            upArrowDownSkin: "upArrowDownSkin",
            upArrowOverSkin: "upArrowOverSkin",
            upArrowUpSkin: "upArrowUpSkin",
            thumbDisabledSkin: "thumbDisabledSkin",
            thumbDownSkin: "thumbDownSkin",
            thumbOverSkin: "thumbOverSkin",
            thumbUpSkin: "thumbUpSkin",
            thumbIcon: "thumbIcon",
            trackDisabledSkin: "trackDisabledSkin",
            trackDownSkin: "trackDownSkin",
            trackOverSkin: "trackOverSkin",
            trackUpSkin: "trackUpSkin",
            repeatDelay: "repeatDelay",
            repeatInterval: "repeatInterval",
            arrowHeight: "arrowHeight"
        };

        public function TextArea(uiStyleObj:Object = null) {
            super(uiStyleObj);
        }

        override protected function configUI():void {
            super.configUI();

            labelField = new Label();
            addChild(labelField);
            updateTextFieldType();

            _verticalScrollBar = new TextScrollBar();
            _verticalScrollBar.visible = false;
            copyStylesToChild(_verticalScrollBar, SCROLL_BAR_STYLES);
            _verticalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll, false, 0, true);
            addChild(_verticalScrollBar);

            _horizontalScrollBar = new TextScrollBar();
            _horizontalScrollBar.visible = false;
            _horizontalScrollBar.direction = ScrollBarDirection.HORIZONTAL;
            copyStylesToChild(_horizontalScrollBar, SCROLL_BAR_STYLES);
            _horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll, false, 0, true);
            addChild(_horizontalScrollBar);

            labelField.addEventListener(TextEvent.TEXT_INPUT, handleTextInput, false, 0, true);
            labelField.addEventListener(Event.CHANGE, handleChange, false, 0, true);

            _horizontalScrollBar.scrollTarget = labelField;
            _verticalScrollBar.scrollTarget = labelField;
            addEventListener(MouseEvent.MOUSE_WHEEL, handleWheel, false, 0, true);

            addEventListener(FocusEvent.FOCUS_IN, focusInHandler, false, 0, true);
            addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, false, 0, true);
        }

        public function get horizontalScrollBar():TextScrollBar {
            return _horizontalScrollBar;
        }

        public function get verticalScrollBar():TextScrollBar {
            return _verticalScrollBar;
        }

        public function get enabled():Boolean {
            return _enabled;
        }

        public function set enabled(value:Boolean):void {
            if (value == _enabled) {
                return;
            }
            _enabled = value;
            updateTextFieldType();
            mouseEnabled = value;
            mouseChildren = value;
            if (value == false && stage && stage.focus == labelField) {
                stage.focus = stage;
            }
            invalidate(InvalidationType.STATE);
        }

        public function get text():String {
            return labelField.text;
        }

        public function set text(value:String):void {
            labelField.text = value;
            invalidate(InvalidationType.DATA);
            invalidate(InvalidationType.STYLES);
            _textHasChanged = true;
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
            invalidate(InvalidationType.DATA);
            invalidate(InvalidationType.STYLES);
            _textHasChanged = true;
        }

        public function get condenseWhite():Boolean {
            return labelField.condenseWhite;
        }

        public function set condenseWhite(value:Boolean):void {
            labelField.condenseWhite = value;
            invalidate(InvalidationType.DATA);
        }

        public function get horizontalScrollPolicy():String {
            return _horizontalScrollPolicy;
        }

        public function set horizontalScrollPolicy(value:String):void {
            _horizontalScrollPolicy = value;
            invalidate(InvalidationType.SIZE);
        }

        public function get verticalScrollPolicy():String {
            return _verticalScrollPolicy;
        }

        public function set verticalScrollPolicy(value:String):void {
            _verticalScrollPolicy = value;
            invalidate(InvalidationType.SIZE);
        }

        public function get horizontalScrollPosition():Number {
            return labelField.scrollH;
        }

        public function set horizontalScrollPosition(value:Number):void {
            // We must force a redraw to ensure that the size is up to date.
            drawNow();
            labelField.scrollH = value;
        }

        public function get verticalScrollPosition():Number {
            return labelField.scrollV;
        }

        public function set verticalScrollPosition(value:Number):void {
            // We must force a redraw to ensure that the size is up to date.
            drawNow();
            labelField.scrollV = value;
        }

        public function get textWidth():Number {
            drawNow();
            return labelField.textWidth;
        }

        public function get textHeight():Number {
            drawNow();
            return labelField.textHeight;
        }

        public function get length():Number {
            return labelField.text.length;
        }

        public function get restrict():String {
            return labelField.restrict;
        }

        public function set restrict(value:String):void {
            if (value == "") value = null;
            labelField.restrict = value;
        }

        public function get maxChars():int {
            return labelField.maxChars;
        }

        public function set maxChars(value:int):void {
            labelField.maxChars = value;
        }

        public function get maxHorizontalScrollPosition():int {
            return labelField.maxScrollH;
        }

        public function get maxVerticalScrollPosition():int {
            return labelField.maxScrollV;
        }

        public function get wordWrap():Boolean {
            return _wordWrap;
        }

        public function set wordWrap(value:Boolean):void {
            _wordWrap = value;
            invalidate(InvalidationType.STATE);
        }

        public function get selectionBeginIndex():int {
            return labelField.selectionBeginIndex;
        }

        public function get selectionEndIndex():int {
            return labelField.selectionEndIndex;
        }

        public function get displayAsPassword():Boolean {
            return labelField.displayAsPassword;
        }

        public function set displayAsPassword(value:Boolean):void {
            labelField.displayAsPassword = value;
        }

        public function get editable():Boolean {
            return _editable;
        }

        public function set editable(value:Boolean):void {
            _editable = value;
            invalidate(InvalidationType.STATE);
        }

        public function get alwaysShowSelection():Boolean {
            return labelField.alwaysShowSelection;
        }

        public function set alwaysShowSelection(value:Boolean):void {
            labelField.alwaysShowSelection = value;
        }

        public function getLineMetrics(lineIndex:int):TextLineMetrics {
            return labelField.getLineMetrics(lineIndex);
        }

        public function setSelection(setSelection:int, endIndex:int):void {
            labelField.setSelection(setSelection, endIndex);
        }

        public function appendText(text:String):void {
            labelField.appendText(text);
            invalidate(InvalidationType.DATA);
        }

        protected function updateTextFieldType():void {
            labelField.type = (enabled && _editable) ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
            labelField.selectable = enabled;
            labelField.wordWrap = _wordWrap;
            labelField.multiline = true;
        }

        protected function handleChange(event:Event):void {
            event.stopPropagation(); // so you don't get two change events
            dispatchEvent(new Event(Event.CHANGE, true));
            invalidate(InvalidationType.DATA);
        }

        protected function handleTextInput(event:TextEvent):void {
            event.stopPropagation();
            dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT, true, false, event.text));
        }

        protected function handleScroll(event:ScrollEvent):void {
            dispatchEvent(event);
        }

        protected function handleWheel(event:MouseEvent):void {
            if (!enabled || !_verticalScrollBar.visible) {
                return;
            }
            _verticalScrollBar.scrollPosition -= event.delta * _verticalScrollBar.lineScrollSize;
            dispatchEvent(new ScrollEvent(ScrollBarDirection.VERTICAL, event.delta * _verticalScrollBar.lineScrollSize, _verticalScrollBar.scrollPosition));
        }

        protected function setEmbedFont():void {
            var embed:Object = getStyle("embedFonts");
            if (embed != null) {
                labelField.embedFonts = embed;
            }
        }

        override protected function draw():void {
            if (isInvalid(InvalidationType.STATE)) {
                updateTextFieldType();
            }
            if (isInvalid(InvalidationType.STYLES)) {
                setChildStyles();
                setEmbedFont();
            }
            if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE)) {
                drawTextFormat();
                drawBackground();
                invalidate(InvalidationType.SIZE, false);
            }
            if (isInvalid(InvalidationType.SIZE, InvalidationType.DATA)) {
                drawLayout();
            }
            super.draw();
        }

        protected function setChildStyles():void {
            copyStylesToChild(_verticalScrollBar, SCROLL_BAR_STYLES);
            copyStylesToChild(_horizontalScrollBar, SCROLL_BAR_STYLES);
        }

        protected function drawTextFormat():void {
            var tf:TextFormat = getStyle(enabled ? "textFormat" : "disabledTextFormat") as TextFormat;
            labelField.setTextFormat(tf);
            labelField.defaultTextFormat = tf;
            setEmbedFont();
        }

        protected function drawBackground():void {
            var bg:DisplayObject = _background;
            var styleName:String = (enabled) ? "upSkin" : "disabledSkin";
            _background = getDisplayObjectInstance(getStyle(styleName));
            if (_background != null) {
                addChildAt(_background, 0);
            }
            if (bg != null && bg != _background && contains(bg)) {
                removeChild(bg);
            }

            _horizontalScrollBar.height = Number(getStyle("scrollBarWidth"));
            _verticalScrollBar.width = Number(getStyle("scrollBarWidth"));
        }

        protected function drawLayout():void {
            var txtPad:Number = Number(getStyle("textPadding"));
            labelField.x = labelField.y = txtPad;
            _background.width = width;
            _background.height = height;

            // Figure out which scrollbars we need:
            var vScrollBar:Boolean = needVScroll();
            var hScrollBar:Boolean = needHScroll();
            var availHeight:Number = height - (hScrollBar ? _horizontalScrollBar.height : 0);
            var availWidth:Number = width - (vScrollBar ? _verticalScrollBar.width : 0);

            setTextSize(availWidth, availHeight, txtPad);

            // catch the edge case of the horizontal scroll bar necessitating a vertical one:
            if (hScrollBar && !vScrollBar && needVScroll()) {
                vScrollBar = true;
                availWidth -= _verticalScrollBar.width;
                setTextSize(availWidth, availHeight, txtPad);
            }

            // Size and move the scrollBars
            if (vScrollBar) {
                _verticalScrollBar.visible = true;
                _verticalScrollBar.x = width - _verticalScrollBar.width;
                _verticalScrollBar.height = availHeight;
                _verticalScrollBar.visible = true;
                _verticalScrollBar.enabled = enabled;
            } else {
                _verticalScrollBar.visible = false;
            }

            if (hScrollBar) {
                _horizontalScrollBar.visible = true;
                _horizontalScrollBar.y = height - _horizontalScrollBar.height;
                _horizontalScrollBar.width = availWidth;
                _horizontalScrollBar.visible = true;
                _horizontalScrollBar.enabled = enabled;
            } else {
                _horizontalScrollBar.visible = false;
            }

            updateScrollBars();

            if(_textHasChanged) {
                addEventListener(Event.ENTER_FRAME, delayedLayoutUpdate, false, 0, true);
            }
        }

        protected function delayedLayoutUpdate(event:Event):void {
            if (_textHasChanged) {
                _textHasChanged = false;
                drawLayout();
                return;
            }
            removeEventListener(Event.ENTER_FRAME, delayedLayoutUpdate);
        }

        protected function updateScrollBars():void {
            _horizontalScrollBar.update();
            _verticalScrollBar.update();
            _verticalScrollBar.enabled = enabled;
            _horizontalScrollBar.enabled = enabled;
            _horizontalScrollBar.drawNow();
            _verticalScrollBar.drawNow();
        }

        protected function needVScroll():Boolean {
            if (_verticalScrollPolicy == ScrollPolicy.OFF) {
                return false;
            }
            if (_verticalScrollPolicy == ScrollPolicy.ON) {
                return true;
            }
            return (labelField.maxScrollV > 1);
        }

        protected function needHScroll():Boolean {
            if (_horizontalScrollPolicy == ScrollPolicy.OFF) {
                return false;
            }
            if (_horizontalScrollPolicy == ScrollPolicy.ON) {
                return true;
            }
            return (labelField.maxScrollH > 0);
        }

        protected function setTextSize(width:Number, height:Number, padding:Number):void {
            var w:Number = width - padding * 2;
            var h:Number = height - padding * 2;

            if (w != labelField.width) {
                labelField.width = w;
            }
            if (h != labelField.height) {
                labelField.height = h;
            }
        }

        protected function focusInHandler(event:FocusEvent):void {
            if (event.target == this) {
                stage.focus = labelField;
            }
            drawFocus(true);
        }

        protected function focusOutHandler(event:FocusEvent):void {
            setSelection(0, 0);
            drawFocus(false);
        }

    }
}
