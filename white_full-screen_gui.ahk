#noEnv 		; 		TO HELP PHYSICALLY CLEANING MONITOR - FULL WHITE GUI 
#persistent	;		"ESCAPE" TO EXIT
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard  
#SingleInstance Force
SysGet, MonitorCnt, MonitorCount
if (MonitorCnt > 1) {
	msgbox more than one display detected
	exit
} else {
    SysGet, MonitorDim, MonitorWorkArea
	dpi := A_ScreenDPI
	Width := A_ScreenWidth
	Height := A_ScreenHeight  
	msgbox % "Monitor will now turn white for Cleaning`nPress Escape`nDPI = " A_ScreenDPI "`nW = " A_ScreenWidth "`nH - " A_ScreenHeight
	
GUI_INIT:
Gui newWnd:New
Gui newWnd: -ToolWindow -SysMenu -Caption -Theme -Resize +AlwaysOnTop
Gui newWnd: Color, 66FFFFFF
rectCoordStr := % "x" . 0 . " y" . 0 . " w" . A_ScreenWidth . " h" . A_ScreenHeight
Gui newWnd:Show, %rectCoordStr% NoActivate,  PLEASE CLEAN ME
}
OnMessage(0x203, "WM_LBUTTONDBLCLK")	;; window message for the mouse left double-click
return

turdz:
Gui newWnd:destroy
msgbox cleaning KB?
ifmsgbox OK, {
	loop {
		BlockInput, on
		sleep 660 
		BlockInput, off
		sleep 6 
		GetKeyState, ctl, ctrl, P
		if (ctl = "D") {
			GetKeyState, minus, NumpadSub, P
			if (minus = "D") {
				msgbox
				BlockInput, off
				break
}	}	}	}
return

WM_LBUTTONDBLCLK(){
	gosub turdz
	exitApp
}

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250
ToolOff:
toolTip,
return

ESC::
Gui newWnd: Destroy
ExitApp
