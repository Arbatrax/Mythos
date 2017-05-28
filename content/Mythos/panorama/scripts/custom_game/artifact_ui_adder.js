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

function AddTimer( data )
{
	//$.Msg( "This was loaded. ");
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

function ChangeUI( data )
{
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false );
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_HEROES, false );
	//$( '#ArtifactTopBar').append("<CustomUIElement type='HudTopBar'           layoutfile='file://{resources}/layout/custom_game/multiteam_top_scoreboard.xml' />");
	ShowTimer()
}

(function () {
	GameEvents.Subscribe( "change_ui", ChangeUI );
	GameEvents.Subscribe( "countdown", UpdateTimer );
	GameEvents.Subscribe( "show_timer", ShowTimer );
    GameEvents.Subscribe( "timer_alert", AlertTimer );
	GameEvents.Subscribe( "add_timer", AddTimer );
	GameEvents.Subscribe( "hide_timer", HideTimer );
	GameEvents.Subscribe( "overtime_alert", HideTimer );
})();