// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package simplyFL.managers {

    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    import simplyFL.core.UIComponent;

    public class StyleManager {

		private static var _instance:StyleManager;

		// Allows lookups of all instances of a specific class:
		private var classToInstancesDict:Dictionary;

        // Allows lookups of current uiStyle for a specific class:
		private var classToUiStylesDict:Dictionary;

        // map[class][uiStyle] = styles;
        private var class_uiStyle_styles_Map:Dictionary;

		public function StyleManager() {
			classToInstancesDict = new Dictionary(true);
            classToUiStylesDict = new Dictionary(true);
            class_uiStyle_styles_Map = new Dictionary(true);
		}

		private static function getInstance():StyleManager {
			if (_instance == null) {
				_instance = new StyleManager();
			}
			return _instance;
		}

		public static function registerInstance(instance:UIComponent):void {
			var inst:StyleManager = getInstance();
			var classDef:Class = getClassDef(instance);
			
			if (classDef == null) {	return;	}
			
			if (inst.classToInstancesDict[classDef] == null) {
				inst.classToInstancesDict[classDef] = new Dictionary(true);
			}
			inst.classToInstancesDict[classDef][instance] = true;
		}

        public static function registerStyles(classDef:Class,uiStyle:String,styleObj:Object):void {
            var inst:StyleManager = getInstance();

            if(inst.class_uiStyle_styles_Map[classDef] == null) {
                inst.class_uiStyle_styles_Map[classDef] = new Dictionary();
            }
            inst.class_uiStyle_styles_Map[classDef][uiStyle] = styleObj;
        }

		public static function getStyles(classOrInst:Object,uiStyle:String):Object {
            var inst:StyleManager = getInstance();
            var classDef:Class = getClassDef(classOrInst);

            if(inst.class_uiStyle_styles_Map[classDef]) {
                return inst.class_uiStyle_styles_Map[classDef][uiStyle];
            }
            return null;
		}

        public static function setComponentUiStyle(classDef:Class, uiStyle:String):void {
            var inst:StyleManager = getInstance();
            if(uiStyle == inst.classToUiStylesDict[classDef]) {return;}
            inst.classToUiStylesDict[classDef] = uiStyle;
            var instancesDict:Dictionary = inst.classToInstancesDict[classDef];
            if (instancesDict) {
                for (var instance:Object in instancesDict)
                    (instance as UIComponent).uiStyle = uiStyle;
            }
        }

        public static function getComponentUiStyle(classOrInst:Object):String {
            var inst:StyleManager = getInstance();
            var classDef:Class = getClassDef(classOrInst);
            return inst.classToUiStylesDict[classDef];
        }

        public static function mergeStyles(...list:Array):Object {
            var styles:Object = {};
            var l:uint = list.length;
            for (var i:uint=0; i<l; i++) {
                var styleList:Object = list[i];
                for (var n:String in styleList) {
                    if (styles[n] != null) { continue; }
                    styles[n] = list[i][n];
                }
            }
            return styles;
        }

		private static function getClassDef(component:Object):Class {
			if(component is Class) {return component as Class;}
			try {
				return getDefinitionByName(getQualifiedClassName(component)) as Class;
			} catch (e:Error) {
				if (component is UIComponent) {
					try {
						return component.loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(component)) as Class;
					} catch (e:Error) {}
				}
			}
			return null;
		}
		
	}
	
}
