// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.core {

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    import simplyFL.managers.StyleManager;

    //--------------------------------------
    //  Styles
    //--------------------------------------

    [Style(name="width", type="Number")]
    [Style(name="height", type="Number")]

    //--------------------------------------
    //  Class description
    //--------------------------------------
	public class UIComponent extends Sprite {

		public static var inCallLaterPhase:Boolean = false;

		protected var isLivePreview:Boolean = false;

		protected var instanceStyles:Object;

		protected var sharedStyles:Object; // Holds a reference to the class-level styles.

		protected var _uiStyle:String;

        protected var callLaterMethods:Dictionary;

		protected var invalidHash:Object;

		protected var _width:Number;

		protected var _height:Number;

		protected var startWidth:Number;

		protected var startHeight:Number;

		public function UIComponent() {
			super();

            tabEnabled = false;
            tabChildren = false;

			instanceStyles = {};
			sharedStyles = {};
			invalidHash = {};
			callLaterMethods = new Dictionary();

			StyleManager.registerInstance(this);

			configUI();
			invalidate(InvalidationType.ALL);
		}

		protected function configUI():void {
			isLivePreview = checkLivePreview();
			var r:Number = rotation;
			rotation = 0;
			var w:Number = super.width;
			var h:Number = super.height;
			super.scaleX = super.scaleY = 1;
            if(w==0 || h==0) {
                w = getStyle("width") as Number;
                h = getStyle("height") as Number;
            }
			setSize(w,h);
			move(super.x,super.y);
			rotation = r;
			startWidth = w;
			startHeight = h;
			if (numChildren > 0) { removeChildAt(0); }
		}

        [Inspectable(defaultValue="default")]
		public function set uiStyle(value:String):void {
			if(value == _uiStyle) {return;}
			_uiStyle = value;
			var styleObj:Object = StyleManager.getStyles(this,_uiStyle);
            if(styleObj == null) {
                throw new Error(this + ".uiStyle " + uiStyle + "doesn't exist.");
            }
            sharedStyles = styleObj;
			invalidate(InvalidationType.STYLES);
		}
		public function get uiStyle():String { return _uiStyle;}

		/** clearΪtrueʱ�����instanceStyles��Ĭ��Ϊfalse */
		public function setUiStyle(value:String,clear:Boolean=false):void {
            uiStyle = value;
            if (clear) {
                instanceStyles = {};
            }
        }

		public function setStyles(styleObj:Object):void {
			for(var style:String in styleObj)
				setStyle(style,styleObj[style]);
		}

		public function setStyle(style:String, value:Object):void {
			//Use strict equality so we can set a style to null ... so if the instanceStyles[style] == undefined, null is still set.
			//We also need to work around the specific use case of TextFormats
			if (instanceStyles[style] === value && !(value is TextFormat)) { return; }
			instanceStyles[style] = value;
			invalidate(InvalidationType.STYLES);
		}

		public function clearStyles(styles:Array):void {
			for each(var style:String in styles)
				setStyle(style,null);
		}

		public function clearStyle(style:String):void {
			setStyle(style,null);
		}

		public function getStyle(style:String):Object {
			return (instanceStyles[style] == null) ? sharedStyles[style] : instanceStyles[style];
		}

        protected function copyStylesToChild(child:UIComponent,styleObj:Object):void {
            for (var style:String in styleObj) {
                child.setStyle(style,getStyle(styleObj[style]));
            }
        }
	
		public function setSize(width:Number, height:Number):void {
			_width = width;
			_height = height;
			invalidate(InvalidationType.SIZE);
		}

		override public function get width():Number { return _width; }
		override public function set width(value:Number):void {
			if (_width == value) { return; }
			setSize(value, height);
		}

		override public function get height():Number { return _height; }
		override public function set height(value:Number):void {
			if (_height == value) { return; }
			setSize(width, value);
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

		override public function get scaleX():Number {
			return width / startWidth;
		}

		override public function set scaleX(value:Number):void {
			setSize(startWidth*value, height);
		}

		override public function get scaleY():Number {
			return height / startHeight;
		}

		override public function set scaleY(value:Number):void {
			setSize(width, startHeight*value);
		}

		protected function getScaleY():Number {
			return super.scaleY;
		}

		protected function setScaleY(value:Number):void {
			super.scaleY = value;
		}

		protected function getScaleX():Number {
			return super.scaleX;
		}

		protected function setScaleX(value:Number):void {
			super.scaleX = value;
		}

		public function validateNow():void {
			invalidate(InvalidationType.ALL,false);
			draw();
		}

		public function invalidate(property:String=InvalidationType.ALL,callLater:Boolean=true):void {
			invalidHash[property] = true;
			if (callLater) { this.callLater(draw); }
		}

		protected function validate():void {
			invalidHash = {};
		}

        // Included the first property as a proper param to enable *some* type checking, and also because it is a required param.
		protected function isInvalid(property:String,...properties:Array):Boolean {
			if (invalidHash[property] || invalidHash[InvalidationType.ALL]) { return true; }
			while (properties.length > 0) {
				if (invalidHash[properties.pop()]) { return true; }
			}
			return false;
		}

		public function drawNow():void {
			draw();
		}

		protected function draw():void {
			// classes that extend UIComponent should deal with each possible invalidated property
			// common values include all, size, enabled, styles, state
			// draw should call super or validate when finished updating
			validate();
		}

		protected function callLater(fn:Function):void {
			if (inCallLaterPhase) { return; }
			
			callLaterMethods[fn] = true;
			if (stage != null) {
				try {
					stage.addEventListener(Event.RENDER,callLaterDispatcher,false,0,true);
					stage.invalidate();
				} catch (se:SecurityError) {
					addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
				}
			} else {
				addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
			}
		}

		private function callLaterDispatcher(event:Event):void {
			if (event.type == Event.ADDED_TO_STAGE) {
                removeEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher);
				try {
					// now we can listen for render event:
					stage.addEventListener(Event.RENDER,callLaterDispatcher,false,0,true);
					stage.invalidate();
				} catch (se1:SecurityError) {
					addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
				}
                return;
			} else {
				event.target.removeEventListener(Event.RENDER,callLaterDispatcher);
				event.target.removeEventListener(Event.ENTER_FRAME,callLaterDispatcher);
				try {
					if (stage == null) {
						// received render, but the stage is not available, so we will listen for addedToStage again:
						addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
						return;
					}
				} catch (se2:SecurityError) {
				}
			}

			inCallLaterPhase = true;
			
			var methods:Dictionary = callLaterMethods;
			for (var method:Object in methods) {
				(method as Function).call();
				delete(methods[method]);
			}
			inCallLaterPhase = false;
		}

		protected function checkLivePreview():Boolean {
			if (parent == null) { return false; }
			var className:String;
			try {
				className = getQualifiedClassName(parent);
			} catch (e:Error) {}
			return (className == "fl.livepreview::LivePreviewParent");
		}

		protected function getDisplayObjectInstance(skin:Object):DisplayObject {
			var obj:Object = null;
			var classDef:Object = null;
			if (skin is Class) {
				obj = new skin();
				if (obj is BitmapData) {
					return new Bitmap(obj as BitmapData);
				}
				return (obj as DisplayObject);
			} else if (skin is DisplayObject) {
				(skin as DisplayObject).x = 0;
				(skin as DisplayObject).y = 0;
				return skin as DisplayObject;
			} else if (skin is BitmapData) {
				return new Bitmap(skin as BitmapData);
			}

			try {
				classDef = getDefinitionByName(skin.toString());
			} catch(e:Error) {
				try {
					classDef = loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object;
				} catch (e:Error) {
					// Nothing
				}
			}

			if (classDef == null) {
				return null;
			}
			obj = new classDef();
			if (obj is BitmapData) {
				return new Bitmap(obj as BitmapData);
			}
			return obj as DisplayObject;
		}

	}

}