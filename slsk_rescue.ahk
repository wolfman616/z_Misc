#NoEnv 
#SingleInstance force
#winactivateforce
SendMode Input 
DetectHiddenWindows, On
Width1:=(A_ScreenWidth/2)-(1400),Height1:=(A_ScreenHeight/2)-(350),Width2:=(A_ScreenWidth/2)-(35),Height2:=(A_ScreenHeight/2)-(10)

IfWinNotExist, SoulSeek
	{
	twat:=WinExist("ahk_exe SLSK2.exe")
	if errorlevel
		Process, Exist, slsk2.exe
	if errorlevel
		tooltip, .::sLsK n0t f0uNd::. , %Width2%,%Height2%,1

settimer, tooloff,-3500
	} else
	winset region,W2880 H700, SoulSeek,
	Winrestore
	WinActivate,  SoulSeek
	WinMaximize , SoulSeek
	winset region,W2880 H700 , SoulSeek,
	Winrestore
	;sleep 20
	winset redraw,,SoulSeek,
	;sleep 20
	WinMove, SoulSeek,, %width1%, %Height1%
	WinGetPos,,, Width, Height, SoulSeek,
	tooltip % "::Window Retrieved::`n  :From The Abyss:`n      "   round(width1) "  ,  " round(Height1) "`n    w=" width "h=" height
	return
	
tooloff:
tooltip, off,,,1
return
