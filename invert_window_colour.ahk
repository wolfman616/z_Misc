#noEnv ; #warn ;#NOTRAYICON
#SingleInstance Force
#MaxThreadsPerHotkey 2
SetBatchLines -1
SetWinDelay -1
sendMode Input
setWorkingDir %a_scriptDir%

menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard

global Matrix

Matrix := 	"-1|0|0|0|0|"
. 				"0|-1|0|0|0|"
. 				"0|0|-1|0|0|"
. 				"0|0|0|1|0|"
. 				"1|1|1|0|1"

gui, +HWNDhgui +AlwaysOnTop
DllCall("GetWindowBand", "ptr", hgui, "uint*", band)
gui, Destroy
hgui := ""

/* 
if (band = 1) {
	if (A_PtrSize = 8)
		RunWait "C:\Program Files\AutoHotkey\AutoHotkeyU64_UIA.exe" "%A_ScriptFullPath%"
	else if A_IsUnicode
		RunWait "C:\Program Files\AutoHotkey\AutoHotkeyU32_UIA.exe" "%A_ScriptFullPath%"
	else
		RunWait "C:\Program Files\AutoHotkey\AutoHotkeyA32_UIA.exe" "%A_ScriptFullPath%"
}
 */
 
DetectHiddenWindows, On

OnExit, Uninitialize
return

+#I:: 		; 		<-			Invert 
#I::		; 		Windows + i 
hTarget 	:= WinExist("A")
if (hTarget = hTargetPrev) {
	hTargetPrev := ""
	count--
	return
}
count++
hTargetPrev := hTarget
if (hgui = "") {
	DllCall("LoadLibrary", "str", "magnification.dll")
	DllCall("magnification.dll\MagInitialize")

	VarSetCapacity(MAGCOLOREFFECT, 100, 0)
	Loop, Parse, Matrix, |
	NumPut(A_LoopField, MAGCOLOREFFECT, (A_Index - 1) * 4, "float")
	loop 2 {
		if (A_Index = 2)
			gui, %A_Index%: +AlwaysOnTop ; needed for ZBID_UIACCESS
		gui, %A_Index%: +HWNDhgui%A_Index% -DPIScale +toolwindow -Caption +E0x02000000 +E0x00080000 +E0x20 ; WS_EX_COMPOSITED := E0x02000000 WS_EX_LAYERED := E0x00080000 WS_EX_CLICKTHROUGH := E0x20
		hChildMagnifier%A_Index% := DllCall("CreateWindowEx", "uint", 0, "str", "Magnifier", "str", "MagnifierWindow", "uint", WS_CHILD := 0x40000000, "int", 0, "int", 0, "int", 0, "int", 0, "ptr", hgui%A_Index%, "uint", 0, "ptr", DllCall("GetWindowLong" (A_PtrSize=8 ? "Ptr" : ""), "ptr", hgui%A_Index%, "int", GWL_HINSTANCE := -6 , "ptr"), "uint", 0, "ptr")
			DllCall("magnification.dll\MagSetColorEffect", "ptr", hChildMagnifier%A_Index%, "ptr", &MAGCOLOREFFECT)
	}
}
;gui, 2: Show, NA ; needed for removing flickering
hgui := hgui1
hChildMagnifier := hChildMagnifier1
loop {
	if (count != 1) { ; target window changed
		if (count = 2)
			count--
		WinHide, ahk_id %hgui%
		return
	}
	VarSetCapacity(WINDOWINFO, 60, 0)
	if (DllCall("GetWindowInfo", "ptr", hTarget, "ptr", &WINDOWINFO) = 0) and (A_LastError = 1400) ; destroyed
	{
		count--
		WinHide, ahk_id %hgui%
		return
	}
	if (NumGet(WINDOWINFO, 36, "uint") & 0x20000000) or !(NumGet(WINDOWINFO, 36, "uint") & 0x10000000) ; minimized or not visible
	{
		if (wPrev != 0) {
			WinHide, ahk_id %hgui%
			wPrev := 0
		}
		sleep 2
		continue
	}
	x 	:= NumGet(WINDOWINFO, 20, "int")
	y 	:= NumGet(WINDOWINFO, 8, "int")
	w 	:= NumGet(WINDOWINFO, 28, "int") - x
	h	:= NumGet(WINDOWINFO, 32, "int") - y
	if (hgui = hgui1) and ((NumGet(WINDOWINFO, 44, "uint") = 1) or (DllCall("GetAncestor", "ptr", WinExist("A"), "uint", GA_ROOTOWNER := 3, "ptr") = hTarget)) ; activated
	{
		hgui := hgui2
		hChildMagnifier := hChildMagnifier2
		WinMove, ahk_id %hgui%,, x, y, w, h
		WinMove, ahk_id %hChildMagnifier%,, 0, 0, w, h
		settimer 1, -20
		settimer 2, -20
		settimer 3, -20
		hidegui := hgui1
	} else 
	if (hgui = hgui2) and (NumGet(WINDOWINFO, 44, "uint") != 1) and ((hr := DllCall("GetAncestor", "ptr", WinExist("A"), "uint", GA_ROOTOWNER := 3, "ptr")) != hTarget) and hr ; deactivated
	{
		hgui := hgui1
		hChildMagnifier := hChildMagnifier1
		WinMove, ahk_id %hgui%,, x, y, w, h
		WinMove, ahk_id %hChildMagnifier%,, 0, 0, w, h
		DllCall("SetWindowPos", "ptr", hgui, "ptr", hTarget, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x0040|0x0010|0x001|0x002)
		DllCall("SetWindowPos", "ptr", hTarget, "ptr", 1, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x0040|0x0010|0x001|0x002) ; some windows can not be z-positioned before setting them to bottom
		DllCall("SetWindowPos", "ptr", hTarget, "ptr", hgui, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x0040|0x0010|0x001|0x002)
		settimer 1, -20
		settimer 2, -20
		settimer 3, -20
		hidegui := hgui2 
	} else 
	if (x != xPrev) or (y != yPrev) or (w != wPrev) or (h != hPrev) ; location changed
	{
		WinMove, ahk_id %hgui%,, x, y, w, h
		WinMove, ahk_id %hChildMagnifier%,, 0, 0, w, h
		settimer 1, -20
		settimer 2, -20
		settimer 3, -20
	}
	if (A_PtrSize = 8) {
		VarSetCapacity(RECT, 16, 0)
		NumPut(x, RECT, 0, "int")
		NumPut(y, RECT, 4, "int")
		NumPut(w, RECT, 8, "int")
		NumPut(h, RECT, 12, "int")
		DllCall("magnification.dll\MagSetWindowSource", "ptr", hChildMagnifier, "ptr", &RECT)
	} 
	else 	DllCall("magnification.dll\MagSetWindowSource", "ptr", hChildMagnifier, "int", x, "int", y, "int", w, "int", h)
	xPrev := x, yPrev := y, wPrev := w, hPrev := h
	if hidegui {
		WinHide, ahk_id %hidegui%
		hidegui := ""
	}
}
return
1:
gui, 2: Show, NA ; needed for removing flickering
return
2:
WinShow, ahk_id %hChildMagnifier%
return
3:
WinShow, ahk_id %hgui%
return

Uninitialize:
if (hgui != "")
 DllCall("magnification.dll\MagUninitialize")
exitapp

Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return