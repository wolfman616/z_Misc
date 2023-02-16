#noenv ;Screen-area marqee selection / screenshot function
Setcontroldelay -1		;	suggested to init from elevated script for hotkeys as below
SetBatchLines -1	;	suggested to init from UIA script for uiband as below
SetWinDelay -1	; DetectHiddenWindows,On this caused tt to not move
ListLines,Off
DetectHiddenText,	On
SetTitleMatchMode,	2
SetTitleMatchMode,	Slow
SendMode,Input
CoordMode,Mouse,Screen
CoordMode,Pixel,Screen
global pbmp,bandie:= 1
onexit,x1t
GetRange()
return,

#f::
DllCall("SetWindowBand","ptr",mainhwnd,"ptr",0,"uint",bandie++)
tt(bandie)
return,

GetRange(ByRef x="",ByRef y="",ByRef w="",ByRef h="") {
	static COL_SELECTION1:= 0x351177, COL_SELECTION2:= 0x221144
	SetBatchLines, -1
	setSystemCursor(32515) ; IDC_Cross := 32515 32513,32514,32515,32516,32640,32641,32642,32643,32644,32645,32646,32648,32649,32650,32651 ;
	 cmm:= A_CoordModeMouse ;;Save the initial state and set the current state ;;
	 CoordMode,Mouse,Screen
	 nW:= A_ScreenWidth, nH:= A_ScreenHeight ;; create canvas GUI ;;
;; Create main GUI Which will host the omnipresent "Desktop" DC's clone ;;
	Gui,Canvas:		New,-dpiscale +AlWaysOnTop +ToolWindow -Caption +hwndmainhwnd ;+e0x80000
	Gui,Canvas:		Add, Picture,x0 y0 w%nW% h%nH% +0xE HwndPicID
;; Create selection range GUI ;;
	Gui,Rang3:	New,-dpiscale +LastFound +AlWaysOnTop -Caption -Border +HwndRang3ID ;+e0x80000  ;0x40000 ;+OwnerCanvas ;+e0x80000  ;+OwnerCanvas -Caption 
	WinSet,Transparent,30	;WinSet,style,-0x80000 ;*(0x80000-ws_border)
;; DesktopDC stuff ;;
	  Ptr:= A_PtrSize? "UPtr":"UInt", int:="int"
	  hDC:= DllCall("GetDC",Ptr,0,Ptr)
	  mDC:= DllCall("CreateCompatibleDC",Ptr,hDC,Ptr)
	  hBM:= DllCall("CreateCompatibleBitmap",Ptr,hDC,int,nW,int,nH,Ptr)
	  oBM:= DllCall("SelectObject", Ptr,mDC,Ptr,hBM, Ptr)
	  DllCall("BitBlt", Ptr,mDC,int,0,int,0,int,nW,int,nH
		,Ptr,hDC,int,0,int,0,int,0x00CC0020)
	SendMessage,0x172,0,hBM,,ahk_id %PicID%
	(E:=ErrorLevel? DllCall("DeleteObject",Ptr,E))
	DllCall("ReleaseDC",Ptr,0,Ptr,hDC)
	DllCall("SelectObject",Ptr,mDC,Ptr,oBM)
;;Display the Main Canvas window;;
	Gui,Canvas:		Show,NA x0 y0 w%nW% h%nH%
	Gui,Dimmer:		New
	,-DPIscale +Lastfound -dpiscale +AlWaysOnTop +ToolWindow -Caption +hwndDimmerhwnd +parentCanvas ;+e0x80020 
	Gui,Dimmer:		Color,% COL_SELECTION2
	winset,transparent,50
	Gui,Dimmer:		Show,Hide x0 y0 w%nW% h%nH% 
	WinAnimate(Dimmerhwnd,"activate center",100)
	sleep,20
;; prompt to designate selection range via LButton-drag.;;
	settimer,TTmsg_L1,-1 ;; Prompt to click drag ;;
	sleep,5
	winget,ttid,id,ahk_Class tooltips_class32
	loop, {
		Critical
		MouseGetPos,xo,yo
		win_move(ttid,xo-12,yo+64,"","","")
		if(GetkeyState("LButton","P")) {
			continue,
		} else,if(!GetkeyState("LButton","P")) 
			sleep,8
		(a_index=1? xoo:=xo, yoo:=yo)
	}
	Until,GetkeyState("LButton","P")
	sleep,10
	if(GetkeyState("LButton","P")) {
		MouseGetPos,xo,yo
		TTmsg_L2()
		sleep,10
		winget,ttid,id,ahk_Class tooltips_class32
	}
	if(!initted) {
		Gui,Rang3:Show,% "na x" xo " y" yo " w" 1 " h" 1
		initted:= true
	}
	Loop, {
		critical
		MouseGetPos,x,y
		win_move(ttid,x-12,y+64,"","","")
		(x>xo? (w:= x-xo, x-=w) : (x<xo? w:= xo-x : (x==xo? w:=0)))
		(y>yo? (h:= y-yo, y-=h) : (y<yo? h:= yo-y : (y==yo? h:=0)))
		win_move(rang3id,x,y,w,h,"")
		if(!((x=xo) && (y=yo)) && (GetkeyState("LButton","P")))
			continue,
	}
	Until,(!GetkeyState("LButton","P"))
	tooltip,
	WinAnimate(Dimmerhwnd,"hide center ",3)
	sleep,30
	CaptureWindow(0,Rang3ID)
	RestoreCursor()
	Gui,Rang3: +lastfound +alwaysontop
	Gui,Rang3: +lastfound ;+0x40000
;	lean the canvas and selection range GUI
	Gui,Dimmer:		Show,HIDE x0 y0 w%nW% h%nH% 
	WinAnimate(Dimmerhwnd,"activate center",160)
	WinAnimate(Dimmerhwnd,"hide center ",120)
	WinAnimate(Rang3id,"hide center",90)
	WinAnimate(Rang3id,"show center",90)
	Gui,Rang3: +lastfound
	winminimize,
	WinGetPos,ViewPos_X,ViewPos_Y,ViewPos_W,ViewPos_H,ahk_id %Rang3ID%
	hDC:= DllCall("GetDC",Ptr,PicID,Ptr)
	inittedDC:= DllCall("GetDC",int,Rang3ID,int)
	SetBltMode(inittedDC,1)
	DllCall("BitBlt",Ptr,inittedDC,int,0,int,0,int,ViewPos_W,int,ViewPos_H
	,Ptr,hDC,int,ViewPos_X,int,ViewPos_Y,int,0x00CC0020)
; Gui,Rang3:Destroy
	WinAnimate(mainhwnd,"hide blend",900)
	Gui,Canvas:Destroy
; Clean the memory image and restore the initial state
	DllCall("ReleaseDC",Ptr,0,Ptr,hdc)
	DllCall("DeleteDC",Ptr,hDC)
	DllCall("ReleaseDC",Ptr,0,Ptr,mDC)
	DllCall("ReleaseDC",Ptr,0,Ptr,inittedDC)
	DllCall("DeleteDC",Ptr,inittedDC)
	DllCall("DeleteDC",Ptr,mDC)
	DllCall("DeleteObject",Ptr,hBM)
	CoordMode,Mouse,% cmm
}

x1t:
DllCall("SystemParametersInfo", "uInt",0x57, "uInt",0, "uInt",0, "uInt",0) ; RestoreCursor()
exitapp

SetClipboardData(nFormat, hBitmap) {
	DllCall("GetObject", "Uint", hBitmap, "int", VarSetCapacity(oi,84,0), "Uint", &oi)
	hDBI :=	DllCall("GlobalAlloc", "Uint", 2, "Uint", 40+NumGet(oi,44))
	pDBI :=	DllCall("GlobalLock", "Uint", hDBI)
	DllCall("RtlMoveMemory", "Uint", pDBI, "Uint", &oi+24, "Uint", 40)
	DllCall("RtlMoveMemory", "Uint", pDBI+40, "Uint", NumGet(oi,20), "Uint", NumGet(oi,44))
	DllCall("GlobalUnlock", "Uint", hDBI)
	DllCall("OpenClipboard", "Uint", 0)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "Uint", nFormat, "Uint", hDBI)
	DllCall("CloseClipboard")
}

TTmsg_L1() {
	global ttid
	; switch,TTMsgNum {
		; case 1 : msg:="'twith the LEFT Mouse-Button`nclick & drag  to make a selection", dur:= 5000
		; case 2 : msg:="`tWhen ready`nRelease the LButton...", dur:= 2400
	MouseGetPos,xo,yo
		win_move(ttid,xo-12,yo+64,"","","")
	return,TT(msg:="'twith the LEFT Mouse-Button`nclick & drag  to make a selection",xo-12,yo+64,dur:= 5000)
}

TTmsg_L2() {
	MouseGetPos,xo,yo
	return,TT(msg:="`tWhen ready`nRelease the LButton...",xo-12,yo+64,dur:= 2400)
}

CreateHBITMAPFromBitmap(pBitmap, Background:=0x00000000) {
; background should be zero, to not alter alpha channel of the image
	hBitmap := 0
	If !pBitmap
	{
		gdipLastError := 2
		Return
	}

	gdipLastError := DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "UPtr", pBitmap, "UPtr*", hBitmap, "int", 0)
	return hBitmap
}

CaptureWindow(hwndOwner, hwnd) {	;-- screenshot function 3
	VarSetCapacity(RECT, 16, 0)
	DllCall("GetWindowRect", "Ptr", hwnd, "Ptr", &RECT)
	width  := NumGet(RECT, 8, "Int")  - NumGet(RECT, 0, "Int")
	height := NumGet(RECT, 12, "Int") - NumGet(RECT, 4, "Int")

	hdc    := DllCall("GetDC", "Ptr", 0, "Ptr")
	hdcMem := DllCall("CreateCompatibleDC", "Ptr", hdc, "UPtr")
	hBmp   := DllCall("CreateCompatibleBitmap", "Ptr", hdc, "Int", width, "Int", height, "UPtr")
	hdcOld := DllCall("SelectObject", "Ptr", hdcMem, "Ptr", hBmp)

	DllCall("BitBlt", "Ptr", hdcMem
		, "Int", 0, "Int", 0, "Int", width, "Int", height
		, "Ptr", hdc, "Int", Numget(RECT, 0, "Int"), "Int", Numget(RECT, 4, "Int")
		, "UInt", 0x00CC0020) ; SRCCOPY

	DllCall("SelectObject", "Ptr", hdcMem, "Ptr", hdcOld)
	DllCall("OpenClipboard", "Ptr", hwndOwner) ; Clipboard owner
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "uint", 0x2, "Ptr", hBmp) ; CF_BITMAP
	DllCall("CloseClipboard")

	DllCall("ReleaseDC", "Ptr", 0, "Ptr", hdc)
	Return,True
}


WinGetRect(hwnd,ByRef W,ByRef H) { ; gwarn u know he loves it.
	; modified by Marius Șucanto, returns an load from own mouth. ;
	If(!hwnd)
		return,
	size:= VarSetCapacity(rect,16,0)
	er:= DllCall("dwmapi\DwmGetWindowAttribute"
	,	"UPtr",hWnd		; HWND<	 >hWnd
	,	"UInt",9		; DWORD< >dwAttribute< >(DWMWA_EXTENDED_FRAME_BOUNDS)
	,	"UPtr",&rect	; PVOID< >pvAttribute
	,	"UInt",size		; DWORD< >cbAttribute
	,	"UInt")			; HRESULT>
	(er? DllCall("WinGetRect","UPtr",hwnd,"UPtr ",&rect,"UInt"))
	r:= []
	r.x1:= NumGet(rect,0,"Int"), r.y1:= NumGet(rect,4 ,"Int")
	,r.x2:= NumGet(rect,8,"Int"), r.y2:= NumGet(rect,12,"Int")
	r.w:= Abs(max(r.x1,r.x2) -min(r.x1,r.x2))
	,r.h:= Abs(max(r.y1,r.y2) -min(r.y1,r.y2))
	W:= r.w,H:= r.h ; ToolTip, % r.w " --- " r.h , , , 2
	Return,r
}

CreateDIBs(hDC,nW,nH,bpp=32,ByRef pBits="") {
	NumPut(VarSetCapacity(bi,40,0),bi)
	NumPut(nW,bi,4), NumPut(nH,bi,8)
	,NumPut(bpp,NumPut(1,bi,12,"UShort"),0,"Ushort")
	Return,DllCall("gdi32\CreateDIBs","Uint",hDC,"Uint"
	,&bi,"Uint",DIB_RGB_COLORS:= 0,"UintP",pBits,"Uint",0,"Uint",0)
}

CreateBitmapFromHBITMAP(hBitmap, Palette:=0) {
; Creates a Bitmap GDI+ object from a GDI [DIB] bitmap handle.
; hPalette - Handle to a GDI palette used to define the bitmap colors

; Do not pass to this function a GDI bitmap or a GDI palette that is
; currently is selected into a device context [hDC].

	pBitmap := 0
	If !hBitmap
	{
		gdipLastError := 2
		Return
	}

	gdipLastError := DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "UPtr", hBitmap, "UPtr", hPalette, "UPtr*", pBitmap)
	return,pBitmap
}

   setSystemCursor(CursorID = "", cx = 0, cy = 0 ) { ; Thanks to Serenity - https://autohotkey.com/board/topic/32608-changing-the-system-cursor/
         static SystemCursors := "32512,32513,32514,32515,32516,32640,32641,32642,32643,32644,32645,32646,32648,32649,32650,32651"

         Loop, Parse, SystemCursors, `,
         {
               Type := "SystemCursor"
               CursorHandle := DllCall( "LoadCursor", "uInt",0, "Int",CursorID )
               %Type%%A_Index% := DllCall( "CopyImage", "uInt",CursorHandle, "uInt",0x2, "Int",cx, "Int",cy, "uInt",0 )
               CursorHandle := DllCall( "CopyImage", "uInt",%Type%%A_Index%, "uInt",0x2, "Int",0, "Int",0, "Int",0 )
               DllCall( "SetSystemCursor", "uInt",CursorHandle, "Int",A_Loopfield)
         }
	}

pBitmapFromHWND(hwnd,clientOnly:=0) { ; Restore the window if minimized! Must be visible for capture.
	;if DllCall("IsIconic", "ptr", hwnd)
		;DllCall("ShowWindow", "ptr", hwnd, "int", 4)
	thisFlag:= 0
	If(clientOnly=1) {
		VarSetCapacity(rc,16,0)
		DllCall("GetClientRect","ptr",hwnd,"ptr",&rc)
		Width:= NumGet(rc,8,"int")
		Height:= NumGet(rc,12,"int")
		thisFlag:= 1
	} else,WinGetRect(hwnd,Width,Height)

	hBM:= CreateDIBs(Width,Height,32)
	hDC:= DllCall("CreateCompatibleDC",Ptr,hDC,Ptr)
	DllCall("SelectObject",Ptr,hdc,Ptr,hbm)
	PrintWin(hwnd,hdc,2 +thisFlag)
	pBitmap:= CreateBitmapFromHBITMAP(hbm)
	DllCall("DeleteObject",Ptr,hbm)
	DllCall("DeleteDC",Ptr,hDC)
	return,pBitmap
}

BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, raster:="") {
; This function works only with GDI hBitmaps that
; are Device-Dependent Bitmaps [DDB].

	return DllCall("gdi32\BitBlt"
				, "UPtr", dDC
				, "int", dX, "int", dY
				, "int", dW, "int", dH
				, "UPtr", sDC
				, "int", sX, "int", sY
				, "uint", Raster ? Raster : 0x00CC0020)
}
SetBltMode(hdc,iStretchMode:=4) { ; iStretchMode options:; 
	; BLACKONWHITE=1. COLORONCOLOR=3, HALFTONE=4. WHITEONBLACK=2
	; STRETCH_ORSCANS=WHITEONBLACK. STRETCH_ANDSCANS=BLACKONWHITE
	; STRETCH_DELETESCANS=COLORONCOLOR. STRETCH_HALFTONE=HALFTONE
	return,DllCall("gdi32\SetBltMode","UPtr",hdc,"int",iStretchMode)
}
GetDC(hwnd:=0) {
	return DllCall("GetDC", "UPtr", hwnd)
}
GetDCEx(hwnd, flags:=0, hrgnClip:=0) {
; Device Context extended flags:
; DCX_CACHE = 0x2
; DCX_CLIPCHILDREN = 0x8
; DCX_CLIPSIBLINGS = 0x10
; DCX_EXCLUDERGN = 0x40
; DCX_EXCLUDEUPDATE = 0x100
; DCX_INTERSECTRGN = 0x80
; DCX_INTERSECTUPDATE = 0x200
; DCX_LOCKWINDOWUPDATE = 0x400
; DCX_NORECOMPUTE = 0x100000
; DCX_NORESETATTRS = 0x4
; DCX_PARENTCLIP = 0x20
; DCX_VALIDATE = 0x200000
; DCX_WINDOW = 0x1
	return,DllCall("GetDCEx", "UPtr", hwnd, "UPtr", hrgnClip, "int", flags)
}
SelectObject(hDC, hGdiObj) {
	Return,DllCall("gdi32\SelectObject", "Uint", hDC, "Uint", hGdiObj)
}
ReleaseDC(hdc, hwnd:=0) {
	return DllCall("ReleaseDC", "UPtr", hwnd, "UPtr", hdc)
}
DeleteObject(hGdiObj) {
	Return,DllCall("gdi32\DeleteObject", "Uint", hGdiObj)
}
DeleteDC(hDC) {
	Return,DllCall("gdi32\DeleteDC", "Uint", hDC)
}

IsInteger(Var) {
	Static Integer:= "Integer"
	If Var Is Integer
		Return,True
	Return,False
}

IsNumber(Var) {
	Static number:= "number"
	If Var Is number
		Return,True
	Return,False
}

PrintWin(hwnd,hdc,Flags:=2) {
	; set Flags to 2, to capture hardware accelerated windows
	; this only applies on Windows 8.1 and later versions.
	;If ((A_OSVersion="WIN_XP" || A_OSVersion="WIN_2000" || A_OSVersion="WIN_2003") && flags=2)
		;flags := 0
	return,DllCall("PrintWin", "UPtr", hwnd, "UPtr", hdc, "uint", Flags)
}

RestoreCursor() {
	DllCall("SystemParametersInfo", "uInt",0x57, "uInt",0, "uInt",0, "uInt",0) 
}