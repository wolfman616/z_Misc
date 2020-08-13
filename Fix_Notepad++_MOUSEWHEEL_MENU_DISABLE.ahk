#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#IfWinActive ahk_class Notepad++
WheelDown::
  GetKeyState state, RButton, P ; get state of right mouse button
  If (state = "U") {            ; U = up
    Send {WheelDown}
  }
  Return
#IfWinActive ahk_class Notepad++
WheelUp::
  GetKeyState state, RButton, P ; get state of right mouse button
  If (state = "U") {            ; U = up
    Send {WheelUp}
  }
  Return