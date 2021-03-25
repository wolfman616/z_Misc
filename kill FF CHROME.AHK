#noEnv ;#persistent
#singleInstance force
Menu, tray, noStandard
Menu, tray, add, Open Script Location, Open_Script_Location,
Menu, tray, standard

Processes:="firefox.exe,chrome.exe,firefox.exe" 		;	tor=firefox.exe
loop, parse, Processes, `,
{
	loop {		
		process, exist, a_loopField
		process, close, %a_loopfield%
	} 	until !errorlevel 
}
exit

Open_script_location:	
runwait %COMSPEC% /C explorer.exe /select`, "%a_scriptFullPath%",, hide
sleep %S%
sendInput {F5}
return