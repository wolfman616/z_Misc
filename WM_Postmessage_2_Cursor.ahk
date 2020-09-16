#NoEnv
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
#PERSISTENT
#SINGLEINSTANCE FORCE

#LButton::
PostMessage_2CursorWin(0x111, 41504, 0)
if errorlevel
	tooltip %ErrorLevel% Error
return

#RButton::
PostMessage_2CursorCTL(0x111, 41504, 0)
if errorlevel
	tooltip %Errorlevel% Error
settimer, tooloff, -1000
return

PostMessage_2CursorWin(Message, wParam = 0, lParam=0) {	
	OldCoordMode:= A_CoordModeMouse
	CoordMode, Mouse, Screen
	MouseGetPos X, Y, , , 2
	hWnd := DllCall("WindowFromPoint", "int", X , "int", Y)
	PostMessage %Message%, %wParam%, %lParam%, , ahk_id %hWnd%
	CoordMode, Mouse, %OldCoordMode%
  } ;</23.01.000004>

PostMessage_2CursorCTL(Message, wParam = 0, lParam=0) {	
	OldCoordMode:= A_CoordModeMouse
	CoordMode, Mouse, Screen
	MouseGetPos X, Y, , hwnd , 2
	;hWnd := DllCall("WindowFromPoint", "int", X , "int", Y)
	PostMessage %Message%, %wParam%, %lParam%, , ahk_id %hWnd%
	CoordMode, Mouse, %OldCoordMode%
  } ;</23.01.000004>

ToolOff:
Tooltip, 
return
