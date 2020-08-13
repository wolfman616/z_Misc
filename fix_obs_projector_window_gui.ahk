;Removes titlebar and controls on projected scene.
#NoEnv 
#notrayicon
#SingleInstance force
#persistent
SendMode Input
SetWorkingDir %A_ScriptDir% 
Menu, Tray, Icon, C:\ICON\32\obs.ico 	;obs64.exe ;Qt5QWindowIcon
run "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OBS Studio\OBS Studio (64bit).lnk"
sleep 2500
WinGet, obspid, pid, Windowed Projector (Scene) - Scene
;GuiControl, Font, 578, Options
WinSet, Style, 0x10000000, Windowed Projector (Scene) - Scene
WinSet, ExStyle, 0x00000000, Windowed Projector (Scene) - Scene
exitapp
