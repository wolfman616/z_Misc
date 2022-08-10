; HRESULT DwmGetColorizationColor(
  ; [out] DWORD *pcrColorization,
  ; [out] BOOL  *pfOpaqueBlend
; );
msgbox % Send_Msg(0x320, winexist("ahk_exe explorer.exe"),"0x99ff0000", 1) ; WM_DWMCOLORIZATIONCOLORCHANGED
