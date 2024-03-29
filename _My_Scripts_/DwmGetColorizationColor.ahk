﻿; HRESULT DwmGetColorizationColor(
  ; [out] DWORD *pcrColorization,
  ; [out] BOOL  *pfOpaqueBlend
; );
/* col := opac := "", msgbox, ((r := DwmGetColorizationColor(col,opac)) . " " opac)
return, */
DwmGetColorizationColor(byref Colour="", byref Opacity="") {
    varSetCapacity(pcrColorization, a_ptrsize)
    varSetCapacity(pfOpaqueBlend  , a_IsUnicode ? 2 : 1 )
	dllCall("Dwmapi.dll\DwmGetColorizationColor","Int",
	. &pcrColorization,"Ptr",&pfOpaqueBlend,"Ptr")
	Opacity := numget(pfOpaqueBlend, 0,2)
	return, (Colour:=Format("{:#x}",numget(pcrColorization,0,a_ptrsize)))
}
;;;;; msgbox % Send_Msg(0x320, winexist("ahk_exe explorer.exe"),"0x99ff0000", 1) ; WM_DWMCOLORIZATIONCOLORCHANGED