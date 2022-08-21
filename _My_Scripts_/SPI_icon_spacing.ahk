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
#include C:\Script\AHK\- LiB\_struct.ahk

    a := DllCall("SystemParametersInfoA", "UInt", 0x000D, "UInt", 64, "UInt",0, "UInt", 1,"UInt")
    b := DllCall("SystemParametersInfoA", "UInt", 0x0018, "UInt", 64, "UInt",0, "UInt", 1,"UInt")
	if (!a || !b)
		msgbox,0,SPI Error,Failed,1000
	return,

; Sets or retrieves the width, in pixels, of an icon cell. The system uses this rectangle to arrange icons in large icon view.

; To set this value, set uiParam to the new value and set pvParam to NULL. You cannot set this value to less than SM_CXICON.

; To retrieve this value, pvParam must point to an integer that receives the current value.
