"use strict";

function UpdateTimer( data )
{
	//$.Msg( "UpdateTimer: ", data );
	//var timerValue = Game.GetDOTATime( false, false );

	//var sec = Math.floor( timerValue % 60 );
	//var min = Math.floor( timerValue / 60 );

	//var timerText = "";
	//timerText += min;
	//timerText += ":";

	//if ( sec < 10 )
	//{
	//	timerText += "0";
	//}
	//timerText += sec;

	var timerText = "";
	timerText += data.timer_minute_10;
	timerText += data.timer_minute_01;
	timerText += ":";
	timerText += data.timer_second_10;
	timerText += data.timer_second_01;

	$( "#Timer" ).text = timerText;

	//$.Schedule( 0.1, UpdateTimer );
}


function AddTimer()
{
	$.Msg( "This was loaded. ");
}

function ShowTimer( data )
{
	$( "#Timer" ).AddClass( "timer_visible" );
}

function AlertTimer( data )
{
	$( "#Timer" ).AddClass( "timer_alert" );
}

function HideTimer( data )
{
	$( "#TimerBox" ).AddClass( "timerbox_hidden" );
}

(function () {
	GameEvents.Subscribe( "countdown", UpdateTimer );
	GameEvents.Subscribe( "show_timer", ShowTimer );
    GameEvents.Subscribe( "timer_alert", AlertTimer );
	GameEvents.Subscribe( "add_timer", AddTimer );
	GameEvents.Subscribe( "hide_timer", HideTimer );
})();