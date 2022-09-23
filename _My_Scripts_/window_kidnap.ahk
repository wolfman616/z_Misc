Window_Kidnap(byref Child="") { ;full kidnap would be to supplan wndproc
	global new_PN
	( !Child ? (Child:=A_new_hwnd) ) ; stylemen invoked
	msgbox % child "`n" A_new_hwnd

	WinGetPos,ChildX,ChildY,Child_W,Child_H,ahk_id %Child%
	Gui,Surrogate: New,+hwndSurrogate +Resize -dpiscale +e0x10000,%new_PN% Surrogate
	Gui,Surrogate: Color,030915 ; 061830
	Gui,Surrogate: Show,Center x%ChildX% y%ChildY% w%Child_W% h%Child_H%
	winset style, -0x4400000,ahk_id %Child%
	winset style, +0x4000000,ahk_id %Child%	
	DllCall("SetParent","ptr",Child,"ptr",Surrogate)

	;WinMove,ahk_id %Child%,,ChildX+10,ChildY+10,Child_W-100,Child_H-100
	win_move(child,0,0,child_w,Child_h)
	return,Surrogate ;hwnd to new parent window
}