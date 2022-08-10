col := opac := ""
r   := DwmGetColorizationColor(col,opac)
msgbox,% r " " opac 
return,

DwmGetColorizationColor(byref Colour="", byref Opacity="") {
    varSetCapacity(pcrColorization, a_ptrsize)
    varSetCapacity(pfOpaqueBlend  , a_IsUnicode ? 2 : 1 )
	dllCall("Dwmapi.dll\DwmGetColorizationColor","Int",&pcrColorization,"Ptr",&pfOpaqueBlend,"Ptr")
	Opacity := numget(pfOpaqueBlend, 0,2)
	return, (Colour := Format("{:#x}",numget(pcrColorization,0,a_ptrsize)))
}