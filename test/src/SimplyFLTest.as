/**
 * Created by zhujiahe on 2015/9/28.
 */
package {
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    import simplyFL.controls.BaseButton;

    import simplyFL.controls.Button;
    import simplyFL.controls.CheckBox;
    import simplyFL.controls.RadioButton;
    import simplyFL.controls.ScrollBar;
    import simplyFL.controls.TextInput;
    import simplyFL.defines.ScrollBarDirection;

    import simplyFL.skins.As3ComponentSkinSetter;

    public class SimplyFLTest extends Sprite {
        public function SimplyFLTest() {
            As3ComponentSkinSetter.setupSkin(function onLoaded():void {
                if (stage) start();
                else addEventListener(Event.ADDED_TO_STAGE, onAddtoStage);
            });
        }

        private function onAddtoStage(event:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, onAddtoStage);
            start();
        }

        private function start():void {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            var btn0:BaseButton = new BaseButton();
            btn0.move(10,10);
            addChild(btn0);

            var btn1:BaseButton = new BaseButton();
            btn1.move(120,10);
            btn1.enabled = false;
            addChild(btn1);

            var btn2:Button = new Button();
            btn2.move(10,40);
            btn2.label = "按钮";
            addChild(btn2);

            var btn3:Button = new Button();
            btn3.move(120,40);
            btn3.enabled = false;
            addChild(btn3);

            var rb0:RadioButton = new RadioButton();
            rb0.move(10,70);
            addChild(rb0);

            var rb1:RadioButton = new RadioButton();
            rb1.move(80,70);
            rb1.selected = true;
            rb1.enabled = false;
            addChild(rb1);

            var cb0:CheckBox = new CheckBox();
            cb0.move(150,70);
            cb0.label = "勾选";
            cb0.selected = true;
            addChild(cb0);

            var textInput:TextInput = new TextInput();
            textInput.move(10,100);
            textInput.setSize(180,22);
            textInput.displayAsPassword = true;
            addChild(textInput);

            var scrollBar:ScrollBar = new ScrollBar();
            scrollBar.move(10,130);
            scrollBar.setSize(1,180);
            scrollBar.direction = ScrollBarDirection.HORIZONTAL;
            scrollBar.maxScrollPosition = 30;
            scrollBar.pageSize = 30;
            addChild(scrollBar);
        }
    }
}