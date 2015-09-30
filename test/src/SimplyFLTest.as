/**
 * Created by zhujiahe on 2015/9/28.
 */
package {
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;

    import simplyFL.containers.SimplePanel;
    import simplyFL.controls.BaseButton;
    import simplyFL.controls.Button;
    import simplyFL.controls.CheckBox;
    import simplyFL.controls.RadioButton;
    import simplyFL.controls.ScrollBar;
    import simplyFL.controls.TextArea;
    import simplyFL.controls.TextInput;
    import simplyFL.controls.TextScrollBar;
    import simplyFL.defines.ScrollBarDirection;
    import simplyFL.defines.ScrollPolicy;
    import simplyFL.skins.As3ComponentSkinSetter;

    [SWF(width=800, height=600, frameRate=60)]
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
            btn0.move(10, 10);
            addChild(btn0);

            var btn1:BaseButton = new BaseButton();
            btn1.move(120, 10);
            btn1.enabled = false;
            addChild(btn1);

            var btn2:Button = new Button();
            btn2.move(10, 40);
            btn2.label = "确认";
            addChild(btn2);

            var btn3:Button = new Button();
            btn3.move(120, 40);
            btn3.enabled = false;
            addChild(btn3);

            var rb0:RadioButton = new RadioButton();
            rb0.move(10, 70);
            addChild(rb0);

            var rb1:RadioButton = new RadioButton();
            rb1.move(80, 70);
            rb1.selected = true;
            rb1.enabled = false;
            addChild(rb1);

            var cb0:CheckBox = new CheckBox();
            cb0.move(150, 70);
            cb0.label = "勾选";
            cb0.selected = true;
            addChild(cb0);

            var textInput:TextInput = new TextInput();
            textInput.move(10, 100);
            textInput.setSize(180, 22);
            textInput.displayAsPassword = true;
            addChild(textInput);

            var scrollBar:ScrollBar = new ScrollBar();
            scrollBar.move(10, 130);
            scrollBar.height = 180;
            scrollBar.direction = ScrollBarDirection.HORIZONTAL;
            scrollBar.maxScrollPosition = 30;
            scrollBar.pageSize = 30;
            addChild(scrollBar);

            var simplePanel:SimplePanel = new SimplePanel();
            simplePanel.move(220, 10);
            simplePanel.setSize(300,300);
            simplePanel.title = "SimplePanelTest.as";
            var shape:Shape = new Shape();
            shape.graphics.beginFill(0x7f7f7f);
            shape.graphics.drawRect(0,0,400,400);
            shape.graphics.endFill();
            simplePanel.content = shape;
            addChild(simplePanel);

            var textScrollBar:TextScrollBar = new TextScrollBar();
            textScrollBar.move(10,150);
            textScrollBar.direction = ScrollBarDirection.HORIZONTAL;
            addChild(textScrollBar);

            var textArea:TextArea = new TextArea();
            textArea.move(10,180);
            textArea.horizontalScrollPolicy = ScrollPolicy.OFF;
            textArea.verticalScrollPolicy = ScrollPolicy.ON;
            addChild(textArea);

//            addEventListener(MouseEvent.CLICK, onClick);
//            addEventListener(Event.CHANGE, onChange);
//            addEventListener(TextEvent.TEXT_INPUT, onInput);
        }

        private function onInput(event:TextEvent):void {
            trace("input",event.target);
        }

        private function onClick(event:MouseEvent):void {
            trace(event.target);
        }

        private function onChange(event:Event):void {
            trace(event.target);
        }
    }
}