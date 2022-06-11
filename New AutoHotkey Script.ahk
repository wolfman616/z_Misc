#NoEnv 
#persistent
#Singleinstance,%    "Force"
DetectHiddenWindows,% "On"
DetectHiddenText,%    "On"
SetTitleMatchMode,%   "2"		
SetTitleMatchMode,%  "Slow"
setWorkingDir,%    A_ScriptDir
SetBatchLines,%       "-1"
SetWinDelay,%         "-1"
ListLines,%           "Off"    ;    dont4get
coordMode,%   "ToolTip",%  "Screen"	
coordmode,%   "Mouse"  ,%  "Screen" 

gosub,%            "_VARIABLES"

menu, Tray, NoStandard
menu, Tray, Add ,% "Open",             ID_VIEW_VARIABLES
menu, Tray, Icon,% "Open",%            "C:\Icon\24\Gterminal_24_32.ico"
menu, Tray, Add ,% "Open Containing",  S_OpenDir
menu, Tray, Icon,% "Open Containing",% "C:\Icon\24\explorer24.ico"
menu, Tray, Add ,% "Edit Script",      ID_TRAY_EDITSCRIPT
menu, Tray, Icon,% "Edit Script",%     "C:\Icon\24\explorer24.ico"
menu, Tray, Add ,% "Reload",           ID_FILE_RELOADSCRIPT
menu, Tray, Icon,% "Reload",%          "C:\Icon\24\eaa.bmp"
menu, Tray, Add ,% "Suspend VKs",      ID_TRAY_SUSPEND
menu, Tray, Icon,% "Suspend VKs",%     "C:\Icon\24\head_fk_a_24_c1.ico"
menu, Tray, Add ,% "Pause",            ID_FILE_PAUSE
menu, Tray, Icon,% "Pause",%           "C:\Icon\24\head_fk_a_24_c2b.ico"
menu, Tray, Add ,% "Exit",             ID_FILE_EXIT
menu, Tray, Icon,% "Exit",%            "C:\Icon\24\head_fk_a_24_c2b.ico"

Main()
return,


Main(){

}


_VARIABLES:
ID_VIEW_VARIABLES := 65407, ID_TRAY_EDITSCRIPT := 65304, ID_FILE_RELOADSCRIPT := 65400, ID_TRAY_SUSPEND := 65305, ID_FILE_PAUSE := 65403, ID_FILE_EXIT := 65405
return, ; ID_TRAY_OPEN := 65300  ; ID_TRAY_RELOADSCRIPT := 65303  ; ID_TRAY_WINDOWSPY := 65302  ; ID_TRAY_PAUSE := 65306  ; ID_TRAY_EXIT := 65307  ; ID_FILE_EDITSCRIPT := 65401  ; ID_FILE_WINDOWSPY := 65402  ; ID_FILE_SUSPEND := 65404  ; ID_FILE_EXIT := 65405  ; ID_VIEW_LINES := 65406

ID_VIEW_VARIABLES:
ID_TRAY_EDITSCRIPT:
ID_FILE_RELOADSCRIPT:
ID_TRAY_SUSPEND:
ID_FILE_PAUSE:
ID_FILE_EXIT:
postmessage, 0x0111, a_thislabel,,,% A_ScriptName " - AutoHotkey"
return,

S_OpenDir:
tt(a_scriptFullPath, 1000)
Open_Containing(a_scriptFullPath)
return,