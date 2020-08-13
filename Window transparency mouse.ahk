#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#b::  
; Press Win+b to make the app not have taskbar item
WinSet, TransColor, Off, ahk_id %MouseWin%
WinSet, TransColor, %MouseRGB% 220, ahk_id %MouseWin%
return

#!y::  ; Press Win+y to turn off transparency for the window under the mouse.
MouseGetPos,,, MouseWin
WinSet, TransColor, Off, ahk_id %MouseWin%
return

#g::  ; Press Win+G to show the current settings of the window under the mouse.
MouseGetPos,,, MouseWin
WinGet, Transparent, Transparent, ahk_id %MouseWin%
WinGet, TransColor, TransColor, ahk_id %MouseWin%
ToolTip Translucency:`t%Transparent%`nTransColor:`t%TransColor%
return