#noEnv
#persistent,
#SingleInstance,	force
ListLines,	    	Off
setBatchLines,   	-1
setWinDelay,		-1
sendMode, 			Input
setWorkingDir 		%a_scriptDir%
#include 			C:\Script\AHK\- LiB\GDI+_All.ahk

global 1stclick, global TipHandle, global Title, global Wi, global Hi, global Xi, global Yi, global ParentXs, global ParentYs, global ParentX, global ParentY, global Active_hwnd,global class_active
gfloater_Path 	:=	"C:\Program Files\Autohotkey\Autohotkey.exe C:\Script\AHK\GiF_floating_Preview.ahk "
AttatchMsg		:=	"click desired location 2 attatch!" ,
CurAniFile		:=	"S:\Documents\Icons\- CuRS0R\Fire Cursor.ani"

Main:

OnExit, Exit

if 0 != 1 		 ; Not run with parameter
	filePath :=  "D:\Documents\My Pictures\animated wiz.gif"
else 
if 0 = 1		 ; run with parameter from menus etc
	filePath  =  %1%
if !(fileexist(filePath)) {
	msgbox,0,% "Error",% "Cant find`n" . filePath
	FileSelectFile, filePath , Options, D:\Documents\My Pictures\, Title, Animated GIF (*.gif)
}

Active_hwnd := WinExist("A")
WinGetClass, class_active, A
if (class_active = "CabinetWClass")	
	gosub, Butt_Go
else if (class_active = "WorkerW")	; Desktop active so we will simply run a different script this time
	run, %gfloater_Path% "%1%" 		; (#floating near mouse cursor#) gif gui script path 
return

;end;
;'#'`#'`#'`#'`#'`#`'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#
;LABELZ;

PlayPause:
isPlaying := gif1.isPlaying
GuiControl,, % hwndPlayPause, % (isPlaying) ? "Play" : "Pause"
if (!isPlaying)
	gif1.Play()
else gif1.Pause()
return

Exit:
Gdip_ShutDown(pToken)
ExitApp
return
;'#'`#'`#'`#'`#'`#`'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#'`#
;FunC/Cl455;
class Gif { 
 __New(file, hwnd, cycle := true) {
		this.file := file
		this.hwnd := hwnd
		this.cycle := cycle
		this.pBitmap := Gdip_CreateBitmapFromFile(this.file)
		Gdip_GetImageDimensions(this.pBitmap, width, height)
		this.width := width, this.height := height
		this.isPlaying := false
		
		DllCall("Gdiplus\GdipImageGetFrameDimensionsCount", "ptr", this.pBitmap, "uptr*", frameDimensions)
		this.SetCapacity("dimensionIDs", 16*frameDimensions)
		DllCall("Gdiplus\GdipImageGetFrameDimensionsList", "ptr", this.pBitmap, "uptr", this.GetAddress("dimensionIDs"), "int", frameDimensions)
		DllCall("Gdiplus\GdipImageGetFrameCount", "ptr", this.pBitmap, "uptr", this.GetAddress("dimensionIDs"), "int*", count)
		this.frameCount := count
		this.frameCurrent := -1
		this.frameDelay := this.GetFrameDelay(this.pBitmap)
		this._Play("")
	}
	
	GetFrameDelay(pImage) { 	; 	Return a zero-based array, containing the frames delay (in milliseconds)
		static PropertyTagFrameDelay := 0x5100

		DllCall("Gdiplus\GdipGetPropertyItemSize", "Ptr", pImage, "UInt", PropertyTagFrameDelay, "UInt*", ItemSize)
		VarSetCapacity(Item, ItemSize, 0)
		DllCall("Gdiplus\GdipGetPropertyItem" , "Ptr", pImage, "UInt", PropertyTagFrameDelay, "UInt", ItemSize, "Ptr", &Item)
		
		PropLen := NumGet(Item, 4, "UInt")
		PropVal := NumGet(Item, 8 + A_PtrSize, "UPtr")
		
		outArray := []
		Loop, % PropLen//4 {
			if !n := NumGet(PropVal+0, (A_Index-1)*4, "UInt")
				n := 10
			outArray[A_Index-1] := n * 10
		}
		return outArray
	}
		
	Play() {
		this.isPlaying := true
		fn := this._Play.Bind(this)
		this._fn := fn
		SetTimer, % fn, -1
	}
	
	Pause() {
		this.isPlaying := false
		fn := this._fn
		SetTimer, % fn, Delete
	}
	
	_Play(mode := "set") {
		this.frameCurrent := mod(++this.frameCurrent, this.frameCount)
		DllCall("Gdiplus\GdipImageSelectActiveFrame", "ptr", this.pBitmap, "uptr", this.GetAddress("dimensionIDs"), "int", this.frameCurrent)
		hBitmap := Gdip_CreateHBITMAPFromBitmap(this.pBitmap)
		SetImage(this.hwnd, hBitmap)
		DeleteObject(hBitmap)
		if (mode = "set" && this.frameCurrent < (this.cycle ? 0xFFFFFFFF : this.frameCount - 1)) {
			fn := this._fn
			SetTimer, % fn, % -1 * this.frameDelay[this.frameCurrent]
	}	}
	
	__Delete() {
		Gdip_DisposeImage(this.pBitmap)
		Object.Delete("dimensionIDs")
}	}
return

Butt:
MsgBox, BUTT-ON!
return

#z::
tooltip, % AttatchMsg, -10, -100
TipHandle:=winexist("ahk_class tooltips_class32")
;SetSystemCursor(CurAniFile)
mousegetpos, ParentXs, ParentYs,
settimer, Coord_get, 2
settimer, move_tt, 2
return

Coord_get:
CoordMode, 		mouse, Window		;	ToolTip|Pixel|Mouse|Caret|Menu / Screen|Window|Client
mousegetpos, 	ParentX, ParentY, Parent_Hwnd, Parent_cWnd
if (getKeyState("lbutton", "P")) {
	if !1stclick {
		1stclick:=true, 	
		settimer, Butt_Go, -200
}	}
return

move_tt:
CoordMode, 		Mouse, Screen
mousegetpos, 	Xc, Yc,
CoordMode, 		Mouse, Window
win_move(TipHandle, Xc-125, Yc-125,"","") 
return

Butt_Go:	
settimer, Coord_get, Off
WinGetActiveStats, Title, Wi, Hi, Xi, Yi
if !ParentX {
	goto gdip
}
if (title = "") {
	ParentX := ParentX -20
	if Parenty > 100
		Parenty := Parenty +5
} else {
	if (title = "Mouse Properties") {
		ParentX := ParentX - 24 
		if Parenty > 25
			Parenty := Parenty - 37
	} else {
		ParentX := ParentX - 30
		if Parenty > 25
			Parenty := Parenty - 40
}	}

gdip:
pToken 	:=	Gdip_Startup()
pImage	:=	Gdip_LoadImageFromFile(filepath)
nW		:=	Gdip_GetImageWidth(pImage)
nH		:=	Gdip_GetImageHeight(pImage)
if !ParentX {
	ParentX		:=	((wi - 75) - nW)
	ParentY		:=	((hi - 75) - nH)
	Parent_Hwnd	:=	Active_hwnd
}
exStyles := (ws_ex_noactivate:= 0x08000000) | (ws_ex_trans:= 0x20) 
;| (WS_EX_COMPOSITED := 0x02000000) | (WS_EX_LAYERED := 0x80000)
Gui, gif1: New, +E%exStyles% +hwndwindy -Caption -DPIScale
xx	:= 	("X" . ParentX), 	yy	:= 	("Y" . ParentY)
Gui, gif1: Add, Picture , backgroundtrans %xx% %yy% hwndhwndGif1, % filePath
gif1 := new Gif(filePath, hwndGif1)
Gui, gif1:+LastFound -Caption +E%exStyles%
DllCall("SetParent", "uint", windy, "uint", Parent_Hwnd)
DllCall("SetParent", "uint", hwndGif1, "uint", Parent_Hwnd)
Gui, gif1:+LastFound -Caption +E%exStyles%
settimer, move_tt, 	Off
settimer, ToolOff, 	-1
Control, ExStyle, %exStyles% , , ahk_id %hwndGif1%
Control, Style, +0x08000000, , 	 ahk_id %hwndGif1%
1stclick := False
RestoreCursor()
gif1.Play()
return

ToolOff:
toolTip,
return

GuiClose:
~shift::
~control::
Space::
~escape::
~lbutton:: ;~rbutton::
exitapp
