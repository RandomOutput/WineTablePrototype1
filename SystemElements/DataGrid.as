package SystemElements
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import backend.totemInputController;
	import flash.geom.Point;
	
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
		
		private var totemStream:totemInputController = new totemInputController();
		private var totems = new Array();
		
		public function DataGrid(_numCols:int, _numRows:int, _gridWidth:Number, _gridHeight:Number)
		{
			numCols = _numCols;
			numRows = _numRows;
			gridWidth = _gridWidth;
			gridHeight = _gridHeight;
			
			MAX_HEIGHT = gridHeight * 0.75;
			MIN_HEIGHT = gridHeight * 0.083;
			MAX_WIDTH = gridWidth * 0.5;
			MIN_WIDTH = gridWidth * 0.083;
			
			if(stage != null) {
				drawGrid();
				initGrid();
				stage.addChild(totemStream);
			} else {
				this.addEventListener(Event.ENTER_FRAME, listenForStage);
			}
		}
		
		private function listenForStage(e:Event):void {
			if(stage != null) {
				this.removeEventListener(Event.ENTER_FRAME, listenForStage);
				drawGrid();
				initGrid();
				stage.addChild(totemStream);
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
				//trace("COLLUMN " + i);
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
					//trace("selected height > max height");
					selectedHeight = MAX_HEIGHT;	
				}
				
				nonSelectedHeight = (gridHeight - (numSelected * selectedHeight)) / (numRows - numSelected);
				
				for(var k=0;k<numRows;k++) {
					currentCell = (cols[i][k]);
					if(currentCell.selected) {
						//trace("set selected cell height");
						//trace("selectedHeight: " + selectedHeight);
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
			var selectedWidth:Number = MIN_WIDTH;
			var nonSelectedWidth = MIN_WIDTH;
			var numColsSelected:Number = 0;
				
			for(var c=0; c<colSel.length;c++) {
				if(colSel[c] == 1) {
					numColsSelected++;
				}
			}
			
			for(var a=0;a<cols.length;a++){
				selectedWidth = MIN_WIDTH + ((gridWidth - (numCols * MIN_WIDTH)) / numColsSelected);
				
				if(selectedWidth > MAX_WIDTH) {
					//trace("selected height > max height");
					selectedWidth = MAX_WIDTH;	
				}
				
				nonSelectedWidth = (gridWidth - (numColsSelected * selectedWidth)) / (numCols - numColsSelected);
				trace("nonSelWidth: " + nonSelectedWidth);
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
			//clear active markers
			for(var v=0;v<cols.length;v++){
				for(var n=0;n<cols[v].length;n++) {
					var currentCell:GridCell = cols[v][n];
					currentCell.selected = false;
					//currentCell.visible = true;
				}
			}
			
			for(var w=0;w<totems.length;w++) {
				//trace("totem[" + w +"]: " + (totems[w] as Point).x + ", " + (totems[w] as Point).y);
				for(var i=0;i<cols.length;i++){
					for(var j=0;j<cols[i].length;j++) {
						currentCell = cols[i][j];
						if(currentCell.hitTestPoint((totems[w] as Point).x, (totems[w] as Point).y)) {
							currentCell.selected = true;
							//currentCell.visible = false;
						}
					}
				}
			}
		}
		
		private function pullTuio():void {
			/**
			 * Here we're actually pulling the totem data 
			 * into our array.  You'll have to do this each
			 * time you want to get new updated data from the 
			 * controller.  Each totem is always referenced in
			 * the same array index.  Totem0 will always be 
			 * in the 0 index of the returned array.  The array is
			 * populated with the lpergTotem datatype.
			**/
			
			var updatedData:Array = totemStream.totemData();
			
			/**
			 * The rest of the code is just setting the new 
			 * location of the totems.  If you need to get the 
			 * deltaX or deltaY of a totem, this information is
			 * already calculated in the back-end.  See the documentation
			 * for the lpergTotem datatype for more information.
			**/
			
			totems[0] = new Point(updatedData[0].getLoc().x-1, updatedData[0].getLoc().y-1);
			totems[1] = new Point(updatedData[1].getLoc().x-1, updatedData[1].getLoc().y-1);
			totems[2] = new Point(updatedData[2].getLoc().x-1, updatedData[2].getLoc().y-1);
			totems[3] = new Point(updatedData[3].getLoc().x-1, updatedData[3].getLoc().y-1);
		}
	}
}