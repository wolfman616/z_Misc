;detects registry keys present in text caret ; will integrate to reglast allowing to spawn the location if suitable.
#persistent
#singleinstance force
setbatchlines -1
RegRead, RegLast ,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\, LastKey
Global Active_Window:="",global Focused_Control_Name,global Selected_Text,global RegMatch,global RegAddress
RegNeedle:="i)(^[^\[]?)?(?:computer\\){0}(HK){1}((EY_LOCAL_MACHINE\\)|(EY_CLASSES_ROOT\\)|(CU\\)|(LM\\)|(CR\\)|(U\\)|(CC\\)){1}([\w\\.])+([^$\]]){0}"
gosub Eventz

Hook:
EventX=%EVENT_OBJECT_TEXTSELECTIONCHANGED%
RegistryFound:=""

OnExit("AtExit")
AtExit() {
	global hWinEventHook, lpfnWinEventProc
	if (hWinEventHook)
		DllCall("UnhookWinEvent", "Ptr", hWinEventHook), hWinEventHook := 0
	if (lpfnWinEventProc)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc, "Ptr"), lpfnWinEventProc := 0	
	return 0
	}

hWinEventHook := DllCall("SetWinEventHook", "UInt", EventX, "UInt", EventX, "Ptr", 0, "Ptr", (lpfnWinEventProc := RegisterCallback("OnEventX", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)

OnEventX(hWinEventHook, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	WinGet, Active_Window, ID , A
	ControlGetFocus, Focused_Control_Name , ahk_id %Active_Window%
	ControlGet, Selected_Text, Selected ,, %Focused_Control_Name%, "ahk_id %Active_Window%"
	tooltip %Selected_Text% :: Event : %event% ::`nidObject: %idObject% ::
	gosub RegistryStringFind
	}
return

Capitalised:
Capitalised:=Regexreplace(Selected_Text,"(\b\w)(.*?)","$U1$2") ; will need to be added toa  context menu or similar
return

RegistryStringFind:
if RegistryFound:= RegExMatch(Selected_Text, RegNeedle, RegMatch)
{
RegAddress=Computer\%RegMatch%
tooltip % regaddress,,,2
}
return



Eventz:

EVENT_OBJECT_TEXTSELECTIONCHANGED:=0x8014
	; An object's text selection has changed. This event is supported by common controls and is used by UI Automation.
	; The hwnd, ID, and idChild parameters of the WinEventProc callback function describe the item that is contained in the updated text selection.

gosub Hook

