#NoEnv 
#Notrayicon
#persistent
#KeyHistory,        0
ListLines,          Off  
#Singleinstance,    Force
coordMode,    ToolTip, Screen	
coordmode,    Mouse,   Screen
#include      <GDI+_All.ahk>

; create 1 pic
ImgFilePath   :=  "C:\Script\AHK\Psych0s1s2bg.png" ; spurious layer designed to cover up watermark
gui_zpos      :=  "aot" 
gui_pos       :=  "x3541 y1010"  ; gets recalculated later
gui_noactiv8  :=  "noactivate"

1mgdr4w(ImgFilePath, 1, "br", "br", "neither always on top nor UI_BAND") 

; create 2nd pic
ImgFilePath   :=  "C:\Script\AHK\Psych335.png"     ; the desired image
gui_zpos      :=  "+UIBand" 
gui_pos       :=  "x3541 y1010"  ; gets recalculated later
gui_noactiv8  :=  "noactivate"

1mgdr4w(ImgFilePath, 2, "br", "br", "UIBand") 
return,

~^!escape:: ctl alt escape
GuiClose:
GuiEscape:
exitapp,

1mgdr4w(imageFilePath, id_num, xpos:="", ypos:="", zpos:="") {
	pToken    := Gdip_Startup()
	pImage    := Gdip_CreateBitmapFromFile(imageFilePath)
	CURRENT_W := Gdip_GetImageWidth( pImage)
	CURRENT_H := Gdip_GetImageHeight(pImage)
	mDC       := Gdi_CreateCompatibleDC(0)
	mBM       := Gdi_CreateDIBSection((mDC), CURRENT_W, CURRENT_H, 32)
	oBM       := Gdi_SelectObject(mDC, mBM)
	pGFX      := Gdip_CreateFromHDC(mDC)
	
	Gdip_DrawImageRectI(pGFX, pImage, 0, 0,  CURRENT_W, CURRENT_H)
	if ((zpos = "aot") ||  (zpos = "UIBand"))
		aotop:="+AlwaysOnTop"
		else aotop:=""
	gui, pwn%id_num%:    New,, no_glass 
	gui, pwn%id_num%:   +LastFound -Caption -DPIScale -SysMenu +toolwindow +owner +OwnDialogs +E0x80020 +HWNDhGui%id_num%
	gui, pic_%id_num%:	 New, -DPIScale +Parentpwn%id_num% %aotop% +ToolWindow +E0x80000, no_glass 
	gui, pic_%id_num%: 	+LastFound -Caption -SysMenu +OwnDialogs +disabled
	if ( xpos="br" || ypos="br" )
		 gui_pos := ("x" . (a_screenwidth-CURRENT_W) . " y" . (a_screenheight-CURRENT_H))  ; offset to bottom right of display
	else guipos  := ("x" .  CURRENT_W . " y" . CURRENT_H)
	gui, pwn%id_num%:    Show,noactivate %gui_pos% w%CURRENT_W% h%CURRENT_H%
	gui, pwn%id_num%:   -Caption %aotop%

	DllCall("UpdateLayeredWindow", "Uint", hGui%id_num%, "Uint", 0, "Uint", 0, "int64P", CURRENT_W|CURRENT_H<<32
	, "Uint", mDC, "int64P", 0, "Uint", 0,    "intP", 0xFF<<16|1<<24, "Uint", 2)

	GDI_SelectObject(mDC,oBM)
	Gdi_DeleteObject(mBM)
	Gdi_DeleteDC(mDC)
	Gdip_DeleteGraphics(pGraphics)
	Gdip_DisposeImage(pImage)
	
	if !(zpos  = "UIBand")
		return,% (hGui%id_num%)
	else {
		if (zpos = "UIBand")
			ourBand := 2   ; ZBID_UIACCESS
			
		code =
		(LTrim
		   SetWorkingDir, %A_ScriptDir%
		   #Include %A_ScriptDir%\Lib\MinHook.ahk
		   address_SetWindowBand := DllCall("GetProcAddress", Ptr, DllCall("GetModuleHandle", Str, "user32", "Ptr"), AStr, "SetWindowBand", "Ptr")
		   hook1 := New MinHook("", address_SetWindowBand, "SetWindowBand_Hook")
		   hook1.Enable()
		  ; send {LWin}
		   return

			SetWindowBand_Hook(hWnd, hwndInsertAfter, dwBand) {
			  global hook1
			  hg=hGui%id_num%
			  global (%hg%)
			  return DllCall(hook1.original, "ptr",%hg%, "ptr", 0, "uint", %ourBand%)
			}
		)
		
		Process, Exist, explorer.exe
		pid := ErrorLevel
		dllFile := FileExist("AutoHotkeyMini.dll") ? A_ScriptDir "C:\Script\AHK\- LiB\minhook\x32\AutoHotkeyMini.dll"
				  : (A_PtrSize = 8)                ?             "C:\Script\AHK\- LiB\minhook\x64\AutoHotkeyMini.dll"
				  :  A_ScriptDir "\ahkDll\x32\AutoHotkeyMini.dll"
		rThread := InjectAhkDll(pid, dllFile, "")
		rThread.Exec(code)
		AppVisibility := ComObjCreate(CLSID_AppVisibility := "{7E5FE3D9-985F-4908-91F9-EE19F9FD1514}", IID_IAppVisibility := "{2246EA2D-CAEA-4444-A3C4-6DE827E44313}")
		settimer poon, -2000
		rThread := ""
				return, hGui%id_num%
		poon:
		if (DllCall(NumGet(NumGet(AppVisibility+0)+4*A_PtrSize), "Ptr", AppVisibility, "Int*", fVisible) >= 0)   {
			if (fVisible = 1) 
				settimer, rapist , -1
		return,  
		;send {LWin}
		rapist:
		   if (DllCall("GetWindowBand", "ptr", (hGui%id_num%), "uint*", pdwBand) = 1) 
			  if (pdwBand = ourBand)
				return
		   else, settimer, rapist, -2000
		}
		rThread := ""
		return, hGui%id_num%
}	}	