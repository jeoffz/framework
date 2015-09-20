package  {

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	public class PreloadSwf extends Sprite {

		public function PreloadSwf() {
			if(stage) start();
			else addEventListener(Event.ADDED_TO_STAGE,onAddtoStage);
		}
		
		private function onAddtoStage( event:Event ):void {
            removeEventListener(Event.ADDED_TO_STAGE,onAddtoStage);
            start();
        }
		
		private function start():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
		}
		
	}
	
}
