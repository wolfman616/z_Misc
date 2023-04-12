; HWND_BOTTOM =1		;Places the window at the bottom of the Z order. If the hWnd parameter identifies a topmost window, the window loses its topmost status and is placed at the bottom of all other windows.
; HWND_NOTOPMOST=-2	;Places the window above all non-topmost windows (that is, behind all topmost windows). This flag has no effect if the window is already a non-topmost window.
; HWND_TOP=0			;Places the window at the top of the Z order.
; HWND_TOPMOST=-1		;Places the window above all non-topmost windows. The window maintains its topmost position even when it is deactivated. 
; SWP_ASYNCWINDOWPOS=0x4000	;If the calling thread and the thread that owns the window are attached to different input queues, the system posts the request to the thread that owns the window. This prevents the calling thread from blocking its execution while other threads process the request.
; SWP_DEFERERASE=0x2000		;Prevents generation of the WM_SYNCPAINT message.
; SWP_DRAWFRAME=0x0020		;Draws a frame (defined in the window's class description) around the window.
; SWP_FRAMECHANGED=0x0020		;Applies new frame styles set using the SetWindowLong function. Sends a WM_NCCALCSIZE message to the window, even if the window's size is not being changed. If this flag is not specified, WM_NCCALCSIZE is sent only when the window's size is being changed.
; SWP_HIDEWINDOW=0x0080		;Hides the window.
; SWP_NOACTIVATE=0x0010		;Does not activate the window. If this flag is not set, the window is activated and moved to the top of either the topmost or non-topmost group (depending on the setting of the hWndInsertAfter parameter).
; SWP_NOCOPYBITS=0x0100		;Discards the entire contents of the client area. If this flag is not specified, the valid contents of the client area are saved and copied back into the client area after the window is sized or repositioned.
; SWP_NOMOVE=0x0002			;Retains the current position (ignores X and Y parameters).
; SWP_NOOWNERZORDER=0x0200	;Does not change the owner window's position in the Z order.
; SWP_NOREDRAW=0x0008			;Does not redraw changes. If this flag is set, no repainting of any kind occurs. This applies to the client area, the nonclient area (including the title bar and scroll bars), and any part of the parent window uncovered as a result of the window being moved. When this flag is set, the application must explicitly invalidate or redraw any parts of the window and parent window that need redrawing.
; SWP_NOREPOSITION=0x0200		;Same as the SWP_NOOWNERZORDER flag.
; SWP_NOSENDCHANGING=0x0400	;Prevents the window from receiving the WM_WINDOWPOSCHANGING message.
; SWP_NOSIZE=0x0001			;Retains the current size (ignores the cx and cy parameters).
; SWP_NOZORDER=0x0004			;Retains the current Z order (ignores the hWndInsertAfter parameter).
; SWP_SHOWWINDOW=0x0040		;Displays the window.

Win_Move(Hwnd, X="", Y="", W="", H="", Flags="") {
	static SWP_NOREDRAW=8, SWP_ASYNCWINDOWPOS=0x4000, HWND_BOTTOM=1, HWND_TOPMOST=-1, HWND_NOTOPMOST = -2
	, SWP_NOMOVE=0x2, SWP_NOSIZE=0x1, SWP_NOZORDER=0x4, SWP_NOACTIVATE = 0x10, SWP_R=0x8, SWP_A=0x4000
	hFlags := SWP_NOZORDER | SWP_NOACTIVATE | SWP_A
	loop, parse, Flags,`,
	try hFlags |= SWP_%A_LoopField%
	if (x y != "") {
		p := DllCall("GetParent", "uint", hwnd), Win_Get(p, "Lxy", px, py), Win_GetRect(hwnd, "xywh", cx, cy, cw, ch)
	if x=
		x := cx - px 
	if y=
		y := cy - py
	} else hFlags |= SWP_NOMOVE
	if (h w != "") {
		if !cx
			Win_GetRect(hwnd, "wh", cw, ch)
		if w=
			w := cw
		if h=
			h := ch
	} else hFlags |= SWP_NOSIZE
	return DllCall("SetWindowPos", "uint", Hwnd, "uint", 0, "int", x, "int", y, "int", w, "int", h, "uint", hFlags)
}

Win_Get(Hwnd, pQ="", ByRef o1="", ByRef o2="", ByRef o3="", ByRef o4="", ByRef o5="", ByRef o6="", ByRef o7="", ByRef o8="", ByRef o9="") {
	if pQ contains R,B,L
	VarSetCapacity(WI, 60, 0), NumPut(60, WI), DllCall("GetWindowInfo", "uint", Hwnd, "uint", &WI)
	k := i := 0
	loop {
		i++, k++
		if (_ := SubStr(pQ, k, 1)) = ""
			break
		if !IsLabel("Win_Get_" _ )
			return A_ThisFunc "> Invalid query parameter: " _
		Goto %A_ThisFunc%_%_%
		Win_Get_C:
		winGetClass, o%i%, ahk_id %hwnd%
		continue
		Win_Get_I:
		winGet, o%i%, PID, ahk_id20/08/2009 %hwnd%
		continue
		Win_Get_N:
		rect := "title"
		VarSetCapacity(TBI, 44, 0), NumPut(44, TBI, 0), DllCall("GetTitleBarInfo", "uint", hwnd, "str", TBI)
		title_x := NumGet(TBI, 4, "Int"), title_y := NumGet(TBI, 8, "Int"), title_w := NumGet(TBI, 12) - title_x, title_h := NumGet(TBI, 16) - title_y
		goto Win_Get_Rect
		Win_Get_B:
		rect := "border"
		border_x := NumGet(WI, 48, "UInt"), border_y := NumGet(WI, 52, "UInt")
		goto Win_Get_Rect
		Win_Get_R:
		rect := "window"
		window_x := NumGet(WI, 4, "Int"), window_y := NumGet(WI, 8, "Int"), window_w := NumGet(WI, 12, "Int") - window_x, window_h := NumGet(WI, 16, "Int") - window_y
		goto Win_Get_Rect
		Win_Get_L:
		client_x := NumGet(WI, 20, "Int"), client_y := NumGet(WI, 24, "Int"), client_w := NumGet(WI, 28, "Int") - client_x, client_h := NumGet(WI, 32, "Int") - client_y
		rect := "client"
		Win_Get_Rect:
		k++, arg := SubStr(pQ, k, 1)
		if arg in x,y,w,h
		{
			o%i% := %rect%_%arg%, j := i++
			goto Win_Get_Rect
		} else
		if !j
			o%i% := %rect%_x " " %rect%_y (_ = "B" ? "" : " " %rect%_w " " %rect%_h)
		rect := "", k--, i--, j := 0
		continue
		Win_Get_S:
		winGet, o%i%, Style, ahk_id %Hwnd%
		continue
		Win_Get_E:
		winGet, o%i%, ExStyle, ahk_id %Hwnd%
		continue
		Win_Get_P:
		o%i% := DllCall("GetParent", "uint", Hwnd)
		continue
		Win_Get_A:
		o%i% := DllCall("GetAncestor", "uint", Hwnd, "uint", 2) ; GA_ROOT
		continue
		Win_Get_O:
		o%i% := DllCall("GetWindowLong", "uint", Hwnd, "int", -8) ; GWL_HWNDPARENT
		continue
		Win_Get_T:
		if DllCall("IsChild", "uint", hwnd)
			winGetText, o%i%, ahk_id %hwnd%
		else winGetTitle, o%i%, ahk_id %hwnd%
		continue
		Win_Get_M:
		winGet, _, PID, ahk_id %hwnd%
		hp := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", False, "uint", _ )
		if (ErrorLevel or !hp)
			continue
		VarSetCapacity(buf, 512, 0), DllCall( "psapi.dll\GetModuleFileNameExA", "uint", hp, "uint", 0, "str", buf, "uint", 512), DllCall( "CloseHandle", hp )
		o%i% := buf
		continue
	}
	return o1
}

Win_GetRect(hwnd, pQ="", ByRef o1="", ByRef o2="", ByRef o3="", ByRef o4="") {
	VarSetCapacity(RECT, 16), r := DllCall("GetWindowRect", "uint", hwnd, "uint", &RECT)
	ifEqual, r, 0, return
	if (pQ = "") or pQ = ("*")
	retAll := True, pQ .= "xywh"
	xx := NumGet(RECT, 0, "Int"), yy := NumGet(RECT, 4, "Int")
	if ( SubStr(pQ, 1, 1) = "*" ) {
		Win_Get(DllCall("GetParent", "uint", hwnd), "Lxy", lx, ly), xx -= lx, yy -= ly
		StringTrimLeft, pQ, pQ, 1
	}
	loop, parse, pQ
	if A_LoopField = x
		o%A_Index% := xx
	else if A_LoopField = y
		o%A_Index% := yy
	else if A_LoopField = w
		o%A_Index% := NumGet(RECT, 8, "Int") - xx - ( lx ? lx : 0)
	else if A_LoopField = h
		o%A_Index% := NumGet(RECT, 12, "Int") - yy - ( ly ? ly : 0 )
	return retAll ? o1 " " o2 " " o3 " " o4 : o1
}
