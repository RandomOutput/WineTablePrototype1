package SystemElements
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class DataGrid extends MovieClip
	{
		private var MAX_HEIGHT:Number;
		private var MIN_HEIGHT:Number;
		private var MAX_WIDTH:Number;
		private var MIN_WIDTH:Number;
		
		private var numCols:int;
		private var numRows:int;
		private var gridWidth:Number;
		private var gridHeight:Number;
		
		private var cols:Vector.<Vector.<GridCell>>;
		
		public function DataGrid(_numCols:int, _numRows:int, _gridWidth:Number, _gridHeight:Number)
		{
			numCols = _numCols;
			numRows = _numRows;
			gridWidth = _gridWidth;
			gridHeight = _gridHeight;
			
			MAX_HEIGHT = gridHeight * 0.75;
			MIN_HEIGHT = gridHeight * 0.083;
			MAX_WIDTH = gridWidth * 0.75;
			MIN_WIDTH = gridWidth * 0.083;
			
			if(stage != null) {
				drawGrid();
				initGrid();
			} else {
				this.addEventListener(Event.ENTER_FRAME, listenForStage);
			}
		}
		
		private function listenForStage(e:Event):void {
			if(stage != null) {
				this.removeEventListener(Event.ENTER_FRAME, listenForStage);
				drawGrid();
				initGrid();
			}
		}
		
		private function drawGrid():void {
			trace("drawGrid");
			var baseWidth = gridWidth / numCols;
			var baseHeight = gridHeight / numRows;
			
			cols = new Vector.<Vector.<GridCell>>;
			
			for(var i=0;i<numCols;i++){
				var newCol = new Vector.<GridCell>();
				cols.push(newCol);
				
				for(var j=0;j<numRows;j++) {
					var newCell = new GridCell(this.x + (i * baseWidth), this.y + (j * baseHeight), baseWidth, baseHeight);
					newCol.push(newCell);
					stage.addChild(newCell);
				}
			}
		}
		
		public function initGrid():void {
			this.addEventListener(Event.ENTER_FRAME, tick);
		}
		
		private function tick(e:Event) {
			pullTuio();
			redrawElement();
		}
		
		public function redrawElement():void {
			var colSel:Array = new Array();
			
			for(var q=0;q<numCols;q++) {
				colSel.push(0);
			}
			
			markActiveCells();
			
			//define heights individually
			for(var i=0;i<cols.length;i++){
				trace("COLLUMN " + i);
				var numSelected:Number = 0;
				var selectedHeight:Number = MIN_HEIGHT;
				var nonSelectedHeight = MIN_HEIGHT;
				
				//how many are selected, cells & cols
				for(var j=0;j<numRows;j++) {
					var currentCell:GridCell = cols[i][j];
					if(currentCell.selected) { 
						colSel[i] = 1;
						numSelected++;
					}
				}
				
				
				selectedHeight = MIN_HEIGHT + ((gridHeight - (numRows * MIN_HEIGHT)) / numSelected);
				/*trace("gridHeight: " + gridHeight);
				trace("numRows: " + numRows);
				trace("MIN_HEIGHT: " + MIN_HEIGHT);
				trace("(gridHeight - (numRows * MIN_HEIGHT)): " + (gridHeight - (numRows * MIN_HEIGHT)));
				trace("numSelected: " + numSelected);
				*/
				if(selectedHeight > MAX_HEIGHT) {
					trace("selected height > max height");
					selectedHeight = MAX_HEIGHT;	
				}
				
				nonSelectedHeight = (gridHeight - (numSelected * selectedHeight)) / (numRows - numSelected);
				
				for(var k=0;k<numRows;k++) {
					currentCell = (cols[i][k]);
					if(currentCell.selected) {
						trace("set selected cell height");
						trace("selectedHeight: " + selectedHeight);
						currentCell.cellHeight = selectedHeight;
					} else {
						currentCell.cellHeight = nonSelectedHeight;
					}
					
					if(k!=0){
						currentCell.cellY = cols[i][k-1].cellY + cols[i][k-1].cellHeight;
					}
					
				}
				
			}
			
			//define widths for cols
			var selectedWidth:Number = MIN_HEIGHT;
			var nonSelectedWidth = MIN_HEIGHT;
			var numColsSelected:Number = 0;
				
			for(var c=0; c<colSel.length;c++) {
				if(colSel[c] == 1) {
					numColsSelected++;
				}
			}
			
			for(var a=0;a<cols.length;a++){
				selectedWidth = MIN_HEIGHT + ((gridHeight - (numRows * MIN_HEIGHT)) / numColsSelected);

				if(selectedWidth > MAX_WIDTH) {
					//trace("selected height > max height");
					selectedWidth = MAX_WIDTH;	
				}
				
				nonSelectedWidth = (gridWidth - (numSelected * selectedWidth)) / (numCols - numColsSelected);
				
				for(var b=0;b<numRows;b++) {
					currentCell = (cols[a][b]);
					if(colSel[a] == 1) {
						//trace("set selected cell height");
						//trace("selectedWidth: " + selectedWidth);
						currentCell.cellWidth = selectedWidth;
					} else {
						currentCell.cellWidth = nonSelectedWidth;
					}
					
					if(a!=0){
						currentCell.cellX = cols[a-1][b].cellX + cols[a-1][b].cellWidth;
					}
				}
			}
			
			for(var l=0;l<cols.length;l++){
				for(var m=0;m<numRows;m++) {
					currentCell = cols[l][m];
					currentCell.redrawElement();
				}
			}
		}
		
		public function markActiveCells():void {
			for(var i=0;i<cols.length;i++){
				for(var j=0;j<cols[i].length;j++) {
					var currentCell:GridCell = cols[i][j];
					if(currentCell.hitTestPoint(stage.mouseX, stage.mouseY)) {
						currentCell.selected = true;
						currentCell.visible = false;
					} else {
						currentCell.selected = false;
						currentCell.visible = true;
					}
				}
			}
		}
		
		private function pullTuio():void {
			
		}
	}
}