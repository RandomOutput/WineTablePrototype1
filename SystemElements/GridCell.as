package SystemElements
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class GridCell extends MovieClip
	{
		public var selected:Boolean = false;
		
		public var cellX:Number;
		public var cellY:Number;
		public var cellWidth:Number;
		public var cellHeight:Number;
		
		public function GridCell(_cellX:Number, _cellY:Number, _cellWidth:Number, _cellHeight:Number)
		{
			cellX = _cellX;
			cellY = _cellY;
			cellWidth = _cellWidth;
			cellHeight = _cellHeight;
			if(stage != null) {
				redrawElement();
			} else {
				this.addEventListener(Event.ENTER_FRAME, listenForStage);
			}
			super();
		}
		
		private function listenForStage(e:Event):void {
			if(stage != null) {
				this.removeEventListener(Event.ENTER_FRAME, listenForStage);
				redrawElement();
			}
		}
		
		public function redrawElement():void {
			this.x = cellX;
			this.y = cellY;
			this.width = cellWidth;
			this.height = cellHeight;
		}
	}
}