#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; Gui, %GuiID%:Show, Hide ;if needed
 Gui, %GuiID%:+Toolwindow
 Gui, %GuiID%:+0x94C80000   ;Winset,   Style, +0x94C80000
 Gui, %GuiID%:-Toolwindow   ;Winset, ExStyle, -0x00000080
; Gui, %GuiID%:+E0x00040000  ;WS_EX_APPWINDOW (Add to taskbar if needed)
 Gui, %GuiID%:Show