/**
 * Created by zhujiahe on 2015/8/7.
 */
package simplyFL.skins {
    import flash.display.Loader;
    import flash.events.Event;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.utils.ByteArray;

    import simplyFL.controls.BaseButton;
    import simplyFL.controls.Button;
    import simplyFL.controls.CheckBox;
    import simplyFL.controls.RadioButton;
    import simplyFL.controls.ScrollBar;
    import simplyFL.controls.TextInput;
    import simplyFL.core.LabelField;
    import simplyFL.managers.StyleManager;

    public class As3ComponentSkinSetter {

        [Embed(source="as3Component_skin.swf", mimeType="application/octet-stream")]
        private static var commonStyle_skin:Class;

        public function As3ComponentSkinSetter() {}

        public static function setupSkin(callBack:Function = null):void
        {
            var textFormat:TextFormat = new TextFormat("微软雅黑", 12, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
            var disabledTextFormat:TextFormat = new TextFormat("微软雅黑", 12, 0x999999, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
            LabelField.DefaultTextFormat = textFormat;

            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function onComplete(event:Event):void {

                // set BaseButton Skins
                var styleObj:Object = {
                    width:88, height:22,
                    repeatDelay:500,repeatInterval:35,
                    upSkin:"As3Component_BaseButton_upSkin",
                    overSkin:"As3Component_BaseButton_overSkin",
                    downSkin:"As3Component_BaseButton_downSkin",
                    disabledSkin:"As3Component_BaseButton_disabledSkin",
                    selectedUpSkin:"As3Component_BaseButton_selectedUpSkin",
                    selectedOverSkin:"As3Component_BaseButton_selectedOverSkin",
                    selectedDownSkin:"As3Component_BaseButton_selectedDownSkin",
                    selectedDisabledSkin:"As3Component_BaseButton_selectedDisabledSkin"
                };
                StyleManager.registerStyles(BaseButton,"As3Component_BaseButton",styleObj);
                StyleManager.setComponentStyles(BaseButton,"As3Component_BaseButton");

                // set Button Skins
                styleObj = StyleManager.mergeStyles(styleObj, {
                            textPadding: 5,
                            embedFonts: false,
                            textFormat: textFormat,
                            disabledTextFormat: disabledTextFormat
                        }
                );
                StyleManager.registerStyles(Button,"As3Component_Button",styleObj);
                StyleManager.setComponentStyles(Button,"As3Component_Button");

                // set CheckBox Skins
                styleObj = {
                    width:88, height:22,
                    upIcon:"As3Component_CheckBox_upIcon",
                    overIcon:"As3Component_CheckBox_overIcon",
                    downIcon:"As3Component_CheckBox_downIcon",
                    disabledIcon:"As3Component_CheckBox_disabledIcon",
                    selectedUpIcon:"As3Component_CheckBox_selectedUpIcon",
                    selectedOverIcon:"As3Component_CheckBox_selectedOverIcon",
                    selectedDownIcon:"As3Component_CheckBox_selectedDownIcon",
                    selectedDisabledIcon:"As3Component_CheckBox_selectedDisabledIcon",
                    textPadding:5,
                    embedFonts:false,
                    textFormat: textFormat,
                    disabledTextFormat: disabledTextFormat
                };
                StyleManager.registerStyles(CheckBox,"As3Component_CheckBox",styleObj);
                StyleManager.setComponentStyles(CheckBox,"As3Component_CheckBox");

                // set RadioButton Skins
                styleObj = {
                    width:88, height:22,
                    upIcon:"As3Component_RadioButton_upIcon",
                    overIcon:"As3Component_RadioButton_overIcon",
                    downIcon:"As3Component_RadioButton_downIcon",
                    disabledIcon:"As3Component_RadioButton_disabledIcon",
                    selectedUpIcon:"As3Component_RadioButton_selectedUpIcon",
                    selectedOverIcon:"As3Component_RadioButton_selectedOverIcon",
                    selectedDownIcon:"As3Component_RadioButton_selectedDownIcon",
                    selectedDisabledIcon:"As3Component_RadioButton_selectedDisabledIcon",
                    textPadding:5,
                    embedFonts:false,
                    textFormat: textFormat,
                    disabledTextFormat: disabledTextFormat
                };
                StyleManager.registerStyles(RadioButton,"As3Component_RadioButton",styleObj);
                StyleManager.setComponentStyles(RadioButton,"As3Component_RadioButton");

                // set TextInput Skins
                styleObj = {
                    width:100, height:22,
                    upSkin:"As3Component_TextInput_upSkin",
                    disabledSkin:"As3Component_TextInput_disabledSkin",
                    overSkin:"As3Component_TextInput_overSkin",
                    textPadding:0,
                    embedFonts:false,
                    textFormat: textFormat,
                    disabledTextFormat: disabledTextFormat
                };
                StyleManager.registerStyles(TextInput,"As3Component_TextInput",styleObj);
                StyleManager.setComponentStyles(TextInput,"As3Component_TextInput");

                // set ScrollBar Skins
                styleObj = {
                    width:15, height:100,arrowHeight:14,
                    downArrowDisabledSkin:"As3Component_ScrollBar_downArrowDisabledSkin",
                    downArrowDownSkin:"As3Component_ScrollBar_downArrowDownSkin",
                    downArrowOverSkin:"As3Component_ScrollBar_downArrowOverSkin",
                    downArrowUpSkin:"As3Component_ScrollBar_downArrowUpSkin",
                    upArrowDisabledSkin:"As3Component_ScrollBar_upArrowDisabledSkin",
                    upArrowDownSkin:"As3Component_ScrollBar_upArrowDownSkin",
                    upArrowOverSkin:"As3Component_ScrollBar_upArrowOverSkin",
                    upArrowUpSkin:"As3Component_ScrollBar_upArrowUpSkin",
                    trackDisabledSkin:"As3Component_ScrollBar_trackUpSkin",
                    trackDownSkin:"As3Component_ScrollBar_trackUpSkin",
                    trackOverSkin:"As3Component_ScrollBar_trackUpSkin",
                    trackUpSkin:"As3Component_ScrollBar_trackUpSkin",
                    thumbDisabledSkin:"As3Component_ScrollBar_thumbUpSkin",
                    thumbDownSkin:"As3Component_ScrollBar_thumbDownSkin",
                    thumbOverSkin:"As3Component_ScrollBar_thumbOverSkin",
                    thumbUpSkin:"As3Component_ScrollBar_thumbUpSkin",
                    repeatDelay:500,repeatInterval:35
                };
                StyleManager.registerStyles(ScrollBar,"As3Component_ScrollBar",styleObj);
                StyleManager.setComponentStyles(ScrollBar,"As3Component_ScrollBar");

                callBack();
            });
            loader.loadBytes((new commonStyle_skin) as ByteArray,new LoaderContext(false,ApplicationDomain.currentDomain));
        }
    }
}
