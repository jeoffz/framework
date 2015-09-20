// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.controls {

	import flash.display.Sprite;
	import flash.text.TextFieldType;

	import simplyFL.core.LabelField;

	//--------------------------------------
    //  Class description
    //--------------------------------------

	public class Label extends Sprite {

		public var labelField:LabelField;

		public function Label() {
			super();

			labelField = new LabelField();
			labelField.type = TextFieldType.DYNAMIC;
			labelField.selectable = false;
			labelField.text = "Label";

			configUI();
		}

		protected function configUI():void {
			var r:Number = rotation;
			rotation = 0;
			var w:Number = super.width;
			var h:Number = super.height;
			super.scaleX = super.scaleY = 1;
            if(w>0 && h>0) setSize(w,h);
			move(super.x,super.y);
			rotation = r;
			if (numChildren > 0) { removeChildAt(0); }
			addChild(labelField);
		}

		[Inspectable(enumeration="dynamic,input",defaultValue="dynamic")]
		public function get type():String {
			return labelField.type;
		}
		public function set type(value:String):void {
			labelField.type = value;
		}

		[Inspectable(defaultValue="Label")]
		public function get text():String {
			return labelField.text;
		}
		public function set text(value:String):void {
			labelField.text = value;
		}
		
		[Inspectable(defaultValue="")]
		public function get htmlText():String {
			return labelField.htmlText;
		}
		public function set htmlText(value:String):void {
			labelField.htmlText = value;
		}

		[Inspectable(defaultValue=0,type="color")]
		public function get textColor():uint {
			return labelField.textColor;
		}
		public function set textColor(value:uint):void {
			labelField.textColor = value;
		}

		[Inspectable(defaultValue=false)]
		public function get wordWrap():Boolean {
			return labelField.wordWrap;
		}
		public function set wordWrap(value:Boolean):void {
			labelField.wordWrap = value;
		}

		[Inspectable(defaultValue=false)]
		public function get displayAsPassword():Boolean {
			return labelField.displayAsPassword;
		}
		public function set displayAsPassword(value:Boolean):void {
			labelField.displayAsPassword = value;
		}

        [Inspectable(enumeration="left,right,center",defaultValue="left")]
        public function get align():String {
            return labelField.align;
        }
        public function set align(value:String):void {
            labelField.align = value;
        }

        [Inspectable(defaultValue="_sans",type="font")]
        public function get font():String {
            return labelField.font;
        }
        public function set font(value:String):void {
            labelField.font = value;
        }

        [Inspectable(defaultValue=12)]
        public function get fontsize():int {
            return labelField.fontsize;
        }
        public function set fontsize(value:int):void {
            labelField.fontsize = value;
        }

		override public function get width():Number {
			return labelField.width;
		}
		override public function set width(value:Number):void {
			labelField.width = value;
		}

		override public function get height():Number {
			return labelField.height;
		}
		override public function set height(value:Number):void {
			labelField.height = value;
		}

		public function setSize(width:Number, height:Number):void {
			labelField.width = width;
			labelField.height = height;
		}

		public function move(x:Number,y:Number):void {
			super.x = Math.round(x);
			super.y = Math.round(y);
		}

		override public function set x(value:Number):void {
			super.x = Math.round(value);
		}

		override public function set y(value:Number):void {
			super.y = Math.round(value);
		}
		
	}
}