#noEnv ; #warn ; only use with Autohotkey\AutoHotkeyA32_UIA.exe
;#persistent
#SingleInstance nowarn
sendMode Input
setWorkingDir %a_scriptDir%
#include C:\Script\AHK\- LiB\GDI+_All.ahk

menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard
	;ImagePath2   := 	"C:\Users\ninj\Desktop11\Untitled2.png"

if 0 != 1 	; Not run with parameter
	ImagePath   := 	"C:\Users\ninj\Desktop11\Untitled2.png"
else
if 0 = 1	; run with parameter from menus
	ImagePath 	= %1%
	gui god: new, +owner +LabelGUI +hwndhwndgod LastFound -Caption +AlwaysOnTop -DPIScale, god
gui god: new, +LabelGUI LastFound -Caption -DPIScale, midi
gGui := WinExist()
gui, god:color, EEAA99 	;gui, 	APCBackMain:Show,x433 y433 w1110 h640, APCBackMain

winSet, Transcolor, EEAA99 




gui dad: new, +LabelGUI LastFound -Caption -DPIScale +hwndhwnddad, midi
hGui := WinExist()

Gui, dad:+LastFound -Caption +parentgod +hwndhwnddad +E0x80000
 

;Gui, cunt:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED & WS_EX_LAYERED => Double Buffer
; winSet, Style, 0x96000000
; winSet, EXStyle, 0x00200008

dtopdc 	:= DllCall("GetDC", "UInt", "dtop")

pToken   := Gdip_Startup()
pImage   := Gdip_LoadImageFromFile("C:\Users\ninj\Desktop11\Untitled2.png")
nW   := Gdip_GetImageWidth(pImage)
nH   := Gdip_GetImageHeight(pImage)

mDC   := Gdi_CreateCompatibleDC(0)
mBM   := Gdi_CreateDIBSection(mDC, nW, nH, 32)
oBM   := Gdi_SelectObject(mDC, mBM)

Gdip_DrawImageRectI(pGraphics:=Gdip_CreateFromHDC(mDC), pImage, 0, 0, nW, nH)

gui, 	alph:New, +ToolWindow +OwnDialogs -Caption +disabled -DPIScale +hwndhwndalph +parentgod +AlwaysOnTop -SysMenu +E0x80000, midi
	gui, 	alph: +LastFound -Caption	; DllCall("SetParent", "uint", hwndalph, "uint", MainhWnd)
	agui	:= WinExist()
	;setup gdip om the wince
	aToken := Gdip_Startup()
	aImage := Gdip_LoadImageFromFile("C:\Users\ninj\Desktop11\Untitled2.png")
	nH:=300,	nw:=300	;noW%A_index%	:= Gdip_GetImageWidth2(aImage)	;noH%A_index%	:= Gdip_GetImageHeight2(aImage) ;nh := (noH%A_index%), 	nw := (noW%A_index%)	
	ynh:= ("h" . nh), 		ynw:= ("w" . nw)
	aDC	:= Gdi_CreateCompatibleDC(0)
	abm	:= Gdi_CreateDIBSection(aDC, nW, nH, 32)
	aoBM	:= Gdi_SelectObject(aDC, abm)
	Gdip_DrawImageRectI(aGraphics:=Gdip_CreateFromHDC(aDC), aImage, 0, 0, nW, nH)
	
	;DllCall("gdi32.dll\SetStretchBltMode", "Uint", aDC, "Int", 5) 
	;DllCall("gdi32.dll\StretchBlt", "Uint", aDC, "Int", 0, "Int", 0, "Int", nH , "Int", nH , "UInt", %C_Whole%dc, "UInt", 0, "UInt", 0, "Int", nW, "Int", nH, "UInt", "0x00440328")
	;DllCall("UpdateLayeredWindow", "Uint", hwndalph, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", aDC, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
	;	DllCall("SetParent", "uint", hwndalph, "uint", MainhWnd)
	
	;		WinSet, Transcolor, ffffff
	;gui, 	%C_Whole%:hide

 	pBitmap := Gdip_CreateBitmapFromFile("C:\Users\ninj\Desktop11\Untitled2.png")
	; Gdip_GetRotatedDimensions(80, 80, 90, rw1, rh1)	; Gdip_GetRotatedDimensions(0, 0, 57.29578 * atan(0/0), rw, rh)
	G:=Gdip_GraphicsFromHDC(aDC)
	Gdip_GraphicsClear(G)
	Gdip_ResetWorldTransform(G)
	Gdip_TranslateWorldTransform(G, 40, 40)
	;Gdip_RotateWorldTransform(G, (rsot:= Rot_%A_index% * 19.3))
	Gdip_TranslateWorldTransform(G, -40, -40)

	Gdip_DrawImage(G, pBitmap, 0, 0, nW, nh) 
		
	DllCall("gdi32.dll\SetStretchBltMode", "Uint", mDC, "Int", 5)
		DllCall("gdi32.dll\StretchBlt", "Uint",mDC, "Int", 0, "Int", 0, "Int", 300 , "Int", 300 , "UInt", dtopdc, "UInt", 3540, "UInt", 65, "Int", 300, "Int", 300, "UInt", 0x00C000CA )
	DllCall("UpdateLayeredWindow", "Uint", hwnddad, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)

;DllCall("UpdateLayeredWindow", "Uint", hgui, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", adc, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)



; Gdip_Shutdown(pToken)
gui, 	alph:Show, noactivate x0 y0 w300 h300, alph
	gui, 	alph: +LastFound -Caption +disabled 
Gui, dad: Show, X0 Y0 W%nW% H%nH% , dad
Gui, god: Show, X3540 Y65 W%nW% H%nH% , god
win_move(hwndgod,"","","","",HWND_TOPMOST)
winget, ded, id, ahk_class SideBar_HTMLHostWindow
win_move(ded,"","","","",HWND_BOTTOM)


;msgbox % ded
;Gui, cunt:New, +hwndhwndcunty +LastFound +parentgod -Caption -DPIScale, midi
;cGui := WinExist() 

;gui cunt: +disabled -SysMenu +ToolWindow +owndialogs
;gui, 	cunt:color, 00ff00	;	DllCall("SetParent", "uint", %C_Whole%, "uint", MainhWnd)
;gui, 	 cunt:Add, Picture,x0 y0 w300 h300, %ImagePath1%
;winSet, Transcolor, 00ff00 

;DllCall("gdi32.dll\SetStretchBltMode", "Uint", adc, "Int", 5)
	;DllCall("gdi32.dll\StretchBlt", "Uint",adc, "Int", 0, "Int", 0, "Int", 300 , "Int", 300 , "UInt", mdc, "UInt", 0, "UInt", 0, "Int", 300, "Int", 300, "UInt", "0x00440328")
;DllCall("UpdateLayeredWindow", "Uint", hgui, "Uint", 0, "Uint", 0, "int64P", 300|300<<32, "Uint", adc, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)

; GDI_SelectObject(mDC, oBM)
; Gdi_DeleteObject(mBM)
; Gdi_DeleteDC(mDC)

; Gdip_DeleteGraphics(pGraphics)
; Gdip_DisposeImage(pImage)


	

;Gui, cunt: Show, Center W%nW% H%nH% , cunt
	;gui, cunt:-Caption +AlwaysOnTop
Return

GuiClose:
GuiEscape:
ExitApp
~escape::
ExitApp

return,

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return
