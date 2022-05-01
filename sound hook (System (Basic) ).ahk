#persistent
#singleinstance force

OnExit("AtExit")
AtExit() {
	global hWinEventHook, lpfnWinEventProc
	if (hWinEventHook)
		DllCall("UnhookWinEvent", "Ptr", hWinEventHook), hWinEventHook := 0
	if (lpfnWinEventProc)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc, "Ptr"), lpfnWinEventProc := 0	
	return 0
	}

EventX:=0x0001
;EVENT_SYSTEM_SOUND:=0x0001
hWinEventHook := DllCall("SetWinEventHook", "UInt", EventX, "UInt", EventX, "Ptr", 0, "Ptr", (lpfnWinEventProc := RegisterCallback("OnEventX", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)

OnEventX(hWinEventHook, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
tooltip NIGGER %event% %idObject% %idChild%
}
return
