package Engine
{
	import flash.display.MovieClip;
	import SystemElements.*;
	
	public class Main extends MovieClip
	{
		private var mainGrid:DataGrid;
		
		public function Main()
		{
			mainGrid = new DataGrid(5, 3, 1280, 800);
			stage.addChild(mainGrid);
		}
	}
}