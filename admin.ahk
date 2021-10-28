#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;RunAs, Administrator, cmd.exe
RWin & t::
Lwin & t::
If !(A_IsAdmin) {
  Run, *RunAs %comspec% /k

}
    ;- if you're NOT 'admin'
If (A_IsAdmin)       ;- I'm 'admin' so it works
   {
   Run,%comspec% /k
   }
else
   msgbox,ADMIN=%A_IsAdmin%
return
