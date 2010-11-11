/*******
File: LPERG Backend Custom Gesture Event
Author: Daniel Plemmons (see LPERG site for contact information)

Description:
*******/

 package backend
 {
 	import flash.events.Event;
 
	 public class GestureEvent extends Event
	 {
	 	//this is the first event type
		 public static const HORIZ_ALIGN:String = "02_verticleAlignment";
		 
		 //this is the second event in my type
		 public static const VERT_ALIGN:String = "02_horizontalALignment";
		 
		 //this is the custom message attatched when my event is dispatched
		 public var customMessage:String = "";
		 
		 public function GestureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		 {
		 	super(type, bubbles, cancelable);
		 }
	 }
 }
