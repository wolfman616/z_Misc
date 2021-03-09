#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#singleinstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
COMMAND = cmd.exe -C:\Script\POWERCFG.cmd.lnk
command2 = "C:\Users\ninj\DESKTOP\bum.lnk"
x := ComObjCreate("WScript.Shell").Exec(COMMAND2).StdOut.ReadAll()


msgbox, % x 

