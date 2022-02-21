#noEnv ; #warn
#persistent
#SingleInstance force
sendMode Input
detecthiddenwindows on
detecthiddentext on
settitlematchmode 2
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard

Log1_RZ := "razerlooin"
Pa5s_RZ := "password"

CoordMode, pixel , window
WinGet, listofgay, List, ahk_exe RzSynapse.exe
Loop %listofgay% {
	ss := ("ahk_id " . listofgay%A_index%)
	winGet, Style, Style,% SS
	winGet, ExStyle, ExStyle,% SS
	if ((Style = "0x16080000") && (ExStyle = "0x000C0000")) {
		winactivate, % ss
		send ^{a}
		send %Log1_RZ%	
		send {tab}
		send ^{a}
		send %Pa5s_RZ%
		PixelGetColor, color, 219, 326
		if color != 0x02DD02
			msgbox, % "default snot saved"
		else send {enter}
}	}	
return,

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return
