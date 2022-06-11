#NoEnv 
#persistent
#Singleinstance,%     "Force"
DetectHiddenWindows,% "On"
DetectHiddenText,%    "On"
SetTitleMatchMode,%   "2"		
SetTitleMatchMode,%   "Slow"
setWorkingDir,%    A_ScriptDir
SetBatchLines,%       "-1"
SetWinDelay,%         "-1"
 ListLines,%           "Off"    ;    dont4get 
coordMode,%   "ToolTip",%  "Screen"	
coordmode,%   "Mouse"  ,%  "Screen" 
#include C:\Script\AHK\- LiB\Taskbar.ahk
global ID_VIEW_VARIABLES, ID_TRAY_EDITSCRIPT, ID_TRAY_RELOADSCRIPT, ID_TRAY_SUSPEND, ID_TRAY_PAUSE, ID_TRAY_EXIT
ID_VIEW_VARIABLES := 65407
ID_TRAY_EDITSCRIPT := 65304
ID_TRAY_SUSPEND := 65305
ID_TRAY_PAUSE := 65306
ID_TRAY_EXIT := 65307
ID_TRAY_RELOADSCRIPT := 65303

menu, Tray, NoStandard
menu, Tray, Add ,% "Open", ID_VIEW_VARIABLES
menu, Tray, Icon,% "Open",%            "C:\Icon\24\Gterminal_24_32.ico"
menu, Tray, Add ,% "Open Containing",  S_OpenDir
menu, Tray, Icon,% "Open Containing",% "C:\Icon\24\explorer24.ico"
menu, Tray, Add ,% "Edit Script",      ID_TRAY_EDITSCRIPT
menu, Tray, Icon,% "Edit Script",%     "C:\Icon\24\explorer24.ico"
menu, Tray, Add ,% "Reload",           ID_TRAY_RELOADSCRIPT
menu, Tray, Icon,% "Reload",%          "C:\Icon\24\eaa.bmp"
menu, Tray, Add ,% "Suspend VKs",      ID_TRAY_SUSPEND
menu, Tray, Icon,% "Suspend VKs",%     "C:\Icon\24\head_fk_a_24_c1.ico"
menu, Tray, Add ,% "Pause",            ID_TRAY_PAUSE
menu, Tray, Icon,% "Pause",%           "C:\Icon\24\head_fk_a_24_c2b.ico"
menu, Tray, Add ,% "Exit",             ID_TRAY_EXIT
menu, Tray, Icon,% "Exit",%            "C:\Icon\24\head_fk_a_24_c2b.ico"


main()
return,

main() {

}

ID_VIEW_VARIABLES:
ID_TRAY_EDITSCRIPT:
ID_TRAY_RELOADSCRIPT:
ID_TRAY_SUSPEND:
ID_TRAY_PAUSE:
ID_TRAY_EXIT:
PostMessage, 0x0111, (%a_thislabel%),,,% A_ScriptName " - AutoHotkey"
return,

AHK_NOTIFYICON(wParam, lParam) {
	static init:=OnMessage(0x404, "AHK_NOTIFYICON")
	switch lParam {
		;case 0x201:  ; WM_LBUTTONDOWN
		;case 0x202:  ; WM_LBUTTONUP
		case 0x203:   ; WM_LBUTTONDBLCLK           
			tt("Loading...")
			settimer, ID_VIEW_VARIABLES,-1

			;PostMessage, 0x0111,%ID_VIEW_VARIABLES%,,,% (A_ScriptName " - AutoHotkey")
			
		;case 0x205: ; WM_RBUTTONUP
		;case 0x206:  ; WM_RBUTTONDBLCLK 
		;case 0x020B:  ; WM_XBUTTONDOWN 
			;	tt("fdsgg")

		case 0x0208:  ; WM_MBUTTONUP  
		tt("fdsgg")
			settimer, ID_TRAY_RELOADSCRIPT,-1
}	}
				
S_OpenDir:
tt(a_scriptFullPath, 1000)
Open_Containing(a_scriptFullPath)
return,