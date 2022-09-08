#noEnv 
#persistent
DetectHiddenWindows,% "On"
DetectHiddenText,%    "On"
SetTitleMatchMode,%   "2"		
SetTitleMatchMode,%   "Slow"
#SingleInstance,%     "force"
setWorkingDir,%       a_scriptDir
SetBatchLines,%       "-1"

menu, tray, add,%     "Open Script Folder", Open_ScriptDir
menu, tray,%          "standard"

Gui, Slav3: New                    ; dummy gui to reg WM_
Gui, Slav3: +LastFound +hwnd_Hw1nd ; +ToolWindow Hwnd := WinExist() also works
Gui, Slav3: Show,,% "SHELLH00K"
Gui, Slav3: Hide
            DllCall("RegisterShellHookWindow", "UInt", _Hw1nd )
u_Msg_id := DllCall("RegisterWindowMessage",   "Str" , "SHELLHOOK")
OnMessage( u_Msg_id,"T4ilH00k" )
return,

T4ilH00k( wParam,lParam ) {
	global
	WinGet,      pname,% "ProcessName",% (hwand := ("ahk_id " . (Format("{:#x}", lParam))))
	wingetClass, Clas5,%      hwand 
	wingettitle, Title_last,% hwand 	
	switch wParam {		
		case "1": ; HSHELL_WINDOWCREATED
			switch pname {
				case "notepad.exe": 
					pname_list:= pname_list . a:=Format("{:#x}", lParam)
					tt(("HSHELL_WINDOWCREATED " . pname . " - " . a), 1000)
			}
			switch Clas5 {
				case "CLIPBRDWNDCLASS,sysdragimage": 
					class_list:= class_list . a:=Format("{:#x}", lParam)
					tt(("HSHELL_WINDOWCREATED " . Clas5 . " - " . a), 1000)
			}
		case "2": ; HSHELL_WINDOWDESTROYED
			if instr(pname_list, (Format("{:#x}", lParam))) {
				pname_list := StrReplace(pname_list, a:=(Format("{:#x}", lParam) , ""))
					tt(("HSHELL_WINDOWDESTROYED " . pname . " - " . a), 1000)
			}
	         else,	if instr(Clas5_list, (Format("{:#x}", lParam))) {
				Clas5_list := StrReplace(Clas5_list, a:=(Format("{:#x}", lParam) , ""))
					tt(("HSHELL_WINDOWDESTROYED " . Clas5 . " - " . a), 1000)
}	}		}
	
Open_Containing_ii(target_uncpath, HighlightDisabledonFile="") {
	SplitPath, target_uncpath, OutFileName, OutDir, OutExtension
	if OutExtension && !HighlightDisabledonFile ; highlight target is a file?
		highlight_file := "/select,"
	run,% (comspec " /C explorer.exe " . highlight_file . target_uncpath),, hide
	;run,% "explore " target_uncpath
	return, ErrorLevel
}

Open_ScriptDir:
tt(a_scriptFullPath, 1000)
Open_Containing_ii(a_scriptFullPath)
return,

ToolOff:
toolTip,
return,

GuiClose:
GuiEscape:
ExitApp
