#noEnv ; #warn
#SingleInstance force
sendMode Input
menu, tray, standard
result:=""
loop,parse,% "096,112,144,192",`, 
{
	success := DllCall("GetSystemMetricsForDpi", "int", 49, "int", a_loopfield, "uint")
	result .= "sm_cxsmicon @ " a_loopfield " DPI = " success "`n"
}
msgbox,% result 

success := DllCall("GetThreadDpiAwarenessContext")
msgbox,% "GetThreadDpiAwarenessContext " success
success := DllCall("GetThreadDpiHostingBehavior")
msgbox,% "GetThreadDpiHostingBehavior " success

VarSetCapacity(ICONMETRICSW_STRUCT, 108)
NumPut(108,    ICONMETRICSW_STRUCT, 0, "uInt") 
success := DllCall("SystemParametersInfoForDpi", "UInt", 0x002D, "UInt", 108, "uint", &ICONMETRICSW_STRUCT, "uint", 0, "Uint", 144, "Uint")      ; Enable
msgbox,% "icon horizontal spacing: " NumGet(&ICONMETRICSW_STRUCT,  4, "Int") "icon vertical spacing: "  NumGet(&ICONMETRICSW_STRUCT,  8, "Int")
return,

; int GetSystemMetricsForDpi(
  ; [in] int  nIndex,
  ; [in] UINT dpi
; )
; BOOL SystemParametersInfoForDpi(
  ; [in]      UINT  uiAction,
  ; [in]      UINT  uiParam,
  ; [in, out] PVOID pvParam,
  ; [in]      UINT  fWinIni,
  ; [in]      UINT  dpi
; )
