#noEnv ; #warn
#persistent
#SingleInstance force
coordmode, mouse, screen
coordmode, tooltip, mouse
sendMode Input
setWorkingDir %a_scriptDir%
#notrayicon
#include	C:\Script\AHK\- LiB\GDI+_All.ahk
#NoEnv
SetBatchLines, -1

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

pToken		:= 	Gdip_Startup()
exStyles	:= 	(WS_EX_COMPOSITED := 0x02000000) | (WS_EX_LAYERED := 0x80000)
Gui, GiF1: New, +E%exStyles% -Caption -DPIScale +AlwaysOnTop -SysMenu +ToolWindow +owndialogs, midi
Gui, GiF1: +LastFound -Caption ;+E0x80000
gui, GiF1: color, 000000

Gui, GiF1: Add, Picture, y10 hwndhwndGif1, % filePath
Gui, GiF1: Add, Button, xp y+10 w80 h24 gPlayPause hwndhwndPlayPause, Pause
gif1 :=    new Gif(filePath, hwndGif1)
winSet,    Transcolor, 000000 
mousegetpos, x, y
xx := ("x" . (x-50)), yy := ("y" . (y-180))
Gui, GiF1: Show,%xx% %yy%, midi
gif1.Play()
return

#z::
mousegetpos, x, y
xx:= ("x" . (x-50)), yy:= ("y" . (y-180))
Gui, GiF1: Show,%xx% %yy%, midi
gif1.Play()
return

;######################################################
PlayPause:
isPlaying := gif1.isPlaying
GuiControl,, % hwndPlayPause, % (isPlaying) ? "Play" : "Pause"
if (!isPlaying) {
   gif1.Play()
} else {
   gif1.Pause()
}
return 
;######################################################
esc::
backspace::
GuiClose:
Exit:
Gdip_ShutDown(pToken)
ExitApp
;######################################################
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

	GetFrameDelay(pImage) {   ; Return a zero-based array, containing the frames delay (in milliseconds)
		static PropertyTagFrameDelay := 0x5100
		
		DllCall("Gdiplus\GdipGetPropertyItemSize", "Ptr", pImage, "UInt", PropertyTagFrameDelay, "UInt*", ItemSize)
		VarSetCapacity(Item, ItemSize, 0)
		DllCall("Gdiplus\GdipGetPropertyItem"    , "Ptr", pImage, "UInt", PropertyTagFrameDelay, "UInt", ItemSize, "Ptr", &Item)
		
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

ToolOff:
toolTip,
return