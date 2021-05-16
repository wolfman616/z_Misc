#noEnv ; #warn
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard

global i := 0, global T_Elapsed, global T_Trigger
AutoJump_delay := 15 ; milliseconds

#q::exitapp

; Autojump Toggle:
~Space:: 		;	 tap spacebar twice in 0.8 Seconds to enable, and once again after a moment to disable
	if T_Start {
		T_Elapsed := A_TickCount - T_Start
		if ( T_Elapsed < 80 ) {		 ;	when space is held we disregard
			T_Start :=
			return
		}
	}
	T_Start := A_TickCount
return
	~Space up::
		if i { ; if Autojump enabled: Timeframe beforewhich disabling Autojump can occur
			if( ( T_Trigger_Elapsed :=  T_Start - T_Trigger ) > 800 ) { 
				settimer, Auto_Jump, off
				T_Elapsed := 0, i := 0
			}
		} else {
			if ( T_Elapsed > 50 ) {
				if ( T_Elapsed < 500 ) {
					if ( A_PriorHotkey = "~Space" ) {
						settimer, Auto_Jump, % ( i := !i ) ? AutoJump_delay : "Off"
						T_Trigger := T_Start
					}
				}
			}
		}
return

Auto_Jump: 
send {space}
return

Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return