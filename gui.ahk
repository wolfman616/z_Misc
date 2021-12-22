#noEnv ; #warn
#persistent
#SingleInstance force
sendMode Input
setWorkingDir %a_scriptDir%
setbatchlines -1
global Rot_Num_in, global Rot_Led_in, global Rot_Num, global Rot_Led, global RotLed_Old 
apcgui 			:= "Images\apctest.png"		;	Main
knob1 			:= "Images\knobtest.png"	; 	replace with individual images of knobs
Rot_Mask 		:= "Images\mask.png" 		;	Rotary-LED Alpha-notched-Mask
Anus 			:= -19.3					;	Rotary-LED separation offset degrees 
WM_Target 		:= "z_in_out.ahk ahk_class AutoHotkey" 	;	Midi feedback

menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard
OnMessage(0x4a, "Receive_WM_COPYDATA")  ; 0x4a is WM_COPYDATA

gui, 	layer1:New, -DPIScale +AlwaysOnTop +disabled -SysMenu +ToolWindow +Owner , Layer1
gui, 	layer1:+LastFound 
gui, 	layer1:Add, Picture,x0 y0 w1122 h666 , %apcgui%
gui, 	layer1:Color, EEAA99
gui, 	layer1:Show,x433 y433 w1122 h666 NoActivate, MIDI IN / OUT, 
gui, 	layer1:-Caption 
WinSet, TransColor, EEAA99

gui, 	layer2:New, -DPIScale +AlwaysOnTop, layer2
gui, 	layer2:Color, 0xEEAA99
gui, 	layer2:+LastFound
gui, 	layer2:Add, Slider,  x88 y495 w56 h170 Vertical vMySlider, 50
gui, 	layer2:+AlwaysOnTop -SysMenu +ToolWindow +Owner 
WinSet, TransColor, EEAA99
gui, 	layer2:Show,x433 y433 w1122 h666, MIDI, 
gui,	layer2:+LastFound  
gui, 	layer2:-Caption 
	 	sFile%A_index% 	:=  Rot_Mask

loop 8 {
	CuntHole 		:= ("Dripp" . A_index)
	GapedJap		:= ("Tr4ny" 	. A_index)
	Y_pos_2 		:= "y445"
	switch a_index{
		case "1":
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x445"
		case "2":
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x530"
		case "3":
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x610"
		case "4":
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x695"
		case "5":
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x775"
		case "6":
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x860"
		case "7":
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x945"
		case "8":
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x1035"
	}	
	gui, 	%CuntHole%:New, -DPIScale +AlwaysOnTop +disabled -SysMenu +ToolWindow +Owner , Layerr%A_index%
	gui, 	%CuntHole%:Color, 000000
	gui, 	%CuntHole%:Add, Picture,%X_pos_1% %Y_pos_1% w80 h80 BackgroundTrans , %knob1%	; 
	gui, 	%CuntHole%:+Hwnd%CuntHole%
	gui, 	%CuntHole%:Show, %X_pos_2% %Y_pos_2% w80 h80 NoActivate, MIDOUT, 
	gui, 	%CuntHole%:+LastFound -Caption   ; Make the GUI window the last found window for use by the line below.
	WinSet, TransColor, 000000
	gui, 	%CuntHole%:hide,
	%CuntHole%dc 	:= DllCall("GetDC", UInt, %CuntHole%)
	gui, 	%GapedJap%:New, -DPIScale +AlwaysOnTop +disabled -SysMenu +ToolWindow +Owner , %GapedJap%
	gui, 	%GapedJap%:+LastFound +AlwaysOnTop -Caption +E0x80000
	hwnd%GapedJap% 	:= WinExist()
	pToken%A_index% := Gdip_Startup22()
	pImage%A_index% := Gdip_LoadImageFromFile(Rot_Mask)
	noW%A_index%	:= Gdip_GetImageWidth2(pImage%A_index%)
	noH%A_index%	:= Gdip_GetImageHeight2(pImage%A_index%)
	nh := (noH%A_index%), 	nw := (noW%A_index%)	
	ynh:= ("h" .  nh), 		ynw:= ("w" .  nw)
	mDC%A_index%	:= Gdi_CreateCompatibleDC(0)
	mBM%A_index%	:= Gdi_CreateDIBSection(mDC%A_index%, nW, nH, 32)
	oBM%A_index%	:= Gdi_SelectObject(mDC%A_index%, mBM%A_index%)
	Gdip_DrawImageRectI(pGraphics%A_index%:=Gdip_CreateFromHDC(mDC%A_index%), pImage%A_index%, 0, 0, nW, nH)
	DllCall("gdi32.dll\SetStretchBltMode",Uint, mDC%A_index%, int, 5)
	DllCall("gdi32.dll\StretchBlt",UInt,mDC%A_index%, Int,0, Int,0, Int, nH , Int, nH , UInt, %CuntHole%dc, UInt,0, UInt,0, Int,nW, Int,nH, UInt, "0x00440328")        
	DllCall("UpdateLayeredWindow", "Uint", hwnd%GapedJap%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%A_index%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
	gui, 	%GapedJap%:Show, h80 w80 %X_pos_2% %Y_pos_2% NoActivate,
	gui, 	%GapedJap%:+LastFound
	gui, 	%GapedJap%:-Caption 
	nH:=80,	nw:=80
 	pBitmap%A_index% := Gdip_CreateBitmapFromFile(Rot_Mask)
	;Gdip_GetRotatedDimensions(80, 80, 90, rw1, rh1)
	;Gdip_GetRotatedDimensions(0, 0, 57.29578 * atan(0/0), rw, rh)
	G%A_index%:=Gdip_GraphicsFromHDC(mdc%A_index%)
	Gdip_GraphicsClear(G%A_index%)
	Gdip_ResetWorldTransform(G%A_index%)
	Gdip_TranslateWorldTransform(G%A_index%, 40, 40)
	Gdip_RotateWorldTransform(G%A_index%, (aa=Anus + 19.3))
	Gdip_TranslateWorldTransform(G%A_index%, -40, -40)

	Gdip_DrawImage(G%A_index%, pBitmap%A_index%, 0, 0, nW, nh)
	DllCall("gdi32.dll\SetStretchBltMode",Uint, mDC%A_index%, int, 5)
	DllCall("gdi32.dll\StretchBlt",UInt,mDC%A_index%, Int,0, Int,0, Int, nH , Int, nH , UInt, %CuntHole%dc, UInt,0, UInt,0, Int,nW, Int,nH, UInt, "0x00440328")        
	DllCall("UpdateLayeredWindow", "Uint", hwnd%GapedJap%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%A_index%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
}
return
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
Knob_Upd8:
nH:=80, nw:=80
pBitmap%Rot_Num% := Gdip_CreateBitmapFromFile(Rot_Mask)
;Gdip_GetRotatedDimensions(80, 80, 90, rw1, rh1)
;Gdip_GetRotatedDimensions(0, 0, 57.29578 * atan(0/0), rw, rh)
G%Rot_Num%:=Gdip_GraphicsFromHDC(mdc%Rot_Num%)
Gdip_GraphicsClear(G%Rot_Num%)
Gdip_ResetWorldTransform(G%Rot_Num%)

Gdip_TranslateWorldTransform(G%Rot_Num%, 40, 40)
Gdip_RotateWorldTransform(G%Rot_Num%, (rsot:=Rot_Led * 19.3))
Gdip_TranslateWorldTransform(G%Rot_Num%, -40, -40)

Gdip_DrawImage(G%Rot_Num%, pBitmap%Rot_Num%, 0, 0, nW, nh)
DllCall("gdi32.dll\SetStretchBltMode",Uint, mDC%Rot_Num%, int, 5)
DllCall("gdi32.dll\StretchBlt",UInt,mDC%Rot_Num%, Int,0, Int,0, Int, nH , Int, nH , UInt, Dripp%Rot_Num%dc, UInt,0, UInt,0, Int,nW, Int,nH, UInt, "0x00440328")
DllCall("UpdateLayeredWindow", "Uint", hwndTr4ny%Rot_Num%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%Rot_Num%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
return

Receive_WM_COPYDATA(wParam, lParam)
{
    StringAddress := NumGet(lParam + 2*A_PtrSize)
    WmCoppOffData := StrGet(StringAddress) 
	settimer tooloff, -2000
	StringLeft, 	Rot_Num_in, WmCoppOffData, 3
	StringRight, 	Rot_Led_in, WmCoppOffData, 3
	switch Rot_Num_in {
		case "048":
			Rot_Num := 1
		case "049":
			Rot_Num := 2
		case "050":
			Rot_Num := 3
		case "051":
			Rot_Num := 4
		case "052":
			Rot_Num := 5
		case "053":
			Rot_Num := 6
		case "054":
			Rot_Num := 7
		case "055":
			Rot_Num := 8
	}
			
	switch Rot_Led_in {
		case 0,8:
			Rot_Led:=0
		case 9,17:
			Rot_Led:=1
		case 18,26:  
			Rot_Led:=2
		case 27,35:
			Rot_Led:=3
		case 36,44:
			Rot_Led:=4
		case 45,53:
			Rot_Led:=5
		case 54,62:
			Rot_Led:=6
		case 63,71:
			Rot_Led:=7
		case 72,80:
			Rot_Led:=8
		case 81,89:
			Rot_Led:=9
		case 90,98:
			Rot_Led:=10
		case 99,107:
			Rot_Led:=11
		case 108,116:
			Rot_Led:=12
		case 117,125:
			Rot_Led:=13
		case 126,127:
			Rot_Led:=14
	}           
	if (Rot_Led 	!= RotLed_Old) {	
		gosub Knob_Upd8
		RotLed_Old 	:= Rot_Led
	}
    return true
}


Gdi_CreateCompatibleDC(hDC = 0)
{
   Return   DllCall("gdi32\CreateCompatibleDC", "Uint", hDC)
}

Gdi_CreateDIBSection(hDC, nW, nH, bpp = 32, ByRef pBits = "")
{
   NumPut(VarSetCapacity(bi, 40, 0), bi)
   NumPut(nW, bi, 4)
   NumPut(nH, bi, 8)
   NumPut(bpp, NumPut(1, bi, 12, "UShort"), 0, "Ushort")
 
   Return   DllCall("gdi32\CreateDIBSection", "Uint", hDC, "Uint", &bi, "Uint", DIB_RGB_COLORS:=0, "UintP", pBits, "Uint", 0, "Uint", 0)
}

Gdi_SelectObject(hDC, hGdiObj)
{
   Return   DllCall("gdi32\SelectObject", "Uint", hDC, "Uint", hGdiObj)
}

Gdi_DeleteObject(hGdiObj)
{
   Return   DllCall("gdi32\DeleteObject", "Uint", hGdiObj)
}

Gdi_DeleteDC(hDC)
{
   Return   DllCall("gdi32\DeleteDC", "Uint", hDC)
}

Gdip_Startup22()
{
   If Not   DllCall("GetModuleHandle", "str", "gdiplus")
      DllCall("LoadLibrary"    , "str", "gdiplus")
   VarSetCapacity(si, 16, 0), si := Chr(1)
   DllCall("gdiplus\GdiplusStartup", "UintP", pToken, "Uint", &si, "Uint", 0)
   Return   pToken
}

Gdip_Shutdown2(pToken)
{
   DllCall("gdiplus\GdiplusShutdown", "Uint", pToken)
   If   hModule :=   DllCall("GetModuleHandle", "str", "gdiplus")
         DllCall("FreeLibrary"    , "Uint", hModule)
   Return   0
}

Gdip_CreateFromHDC(hDC)
{
   DllCall("gdiplus\GdipCreateFromHDC", "Uint", hDC, "UintP", pGraphics)
   Return   pGraphics
}

Gdip_DeleteGraphics2(pGraphics)
{
   Return   DllCall("gdiplus\GdipDeleteGraphics", "Uint", pGraphics)
}

Gdip_LoadImageFromFile(sFile)
{
   VarSetCapacity(wFile, 1023)
   DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sFile, "int", -1, "Uint", &wFile, "int", 512)
   DllCall("gdiplus\GdipLoadImageFromFile", "Uint", &wFile, "UintP", pImage)
   Return   pImage
}

Gdip_DisposeImage2(pImage)
{
   Return   DllCall("gdiplus\GdipDisposeImage", "Uint", pImage)
}

Gdip_GetImageWidth2(pImage)
{
   DllCall("gdiplus\GdipGetImageWidth", "Uint", pImage, "UintP", nW)
   Return   nW
}

Gdip_GetImageHeight2(pImage)
{
   DllCall("gdiplus\GdipGetImageHeight", "Uint", pImage, "UintP", nH)
   Return   nH
}

Gdip_DrawImageRectI(pGraphics, pImage, nL, nT, nW, nH)
{
   Return   DllCall("gdiplus\GdipDrawImageRectI", "Uint", pGraphics, "Uint", pImage, "int", nL, "int", nT, "int", nW, "int", nH)
}


Send_WM_COPYDATA(ByRef StringToSend, ByRef WM_Target)  ; ByRef saves a little memory in this case.
; This function sends the specified string to the specified window and returns the reply.
; The reply is 1 if the target window processed the message, or 0 if it ignored it.
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
    ; First set the structure's cbData member to the size of the string, including its zero terminator:
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    TimeOutTime := 4000  ; Optional. Milliseconds to wait for response from receiver.ahk. Default is 5000
    ; Must use SendMessage not PostMessage.
    SendMessage, 0x4a, 0, &CopyDataStruct,, %WM_Target%,,,, %TimeOutTime% ; 0x4a is WM_COPYDATA.
    DetectHiddenWindows %Prev_DetectHiddenWindows%  ; Restore original setting for the caller.
    SetTitleMatchMode %Prev_TitleMatchMode%         ; Same.
    return ErrorLevel  ; Return SendMessage's reply back to our caller.
}





return,

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return

/* 

top rotary light mask degree offset
01: 0
02: 18,6
03: 40.3
04: 59
05: 79.1
06: 97.8
07: 118
08: 138
09: 156.7
10: 176.9
11: 176.9 +20.2 197.1
12: 176.9 +38.8 215.7
13: 176.9 +55.9 232.8
14: 176.9 +76 252.9
15: 176.9 +96.2 273.1



 */