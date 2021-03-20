sFile	:= "C:\Users\ninj\DESKTOP\580b57fcd9996e24bc43c521.png"
#include gdip.ahk
pToken	:= Gdip_Startup()
pBitmap	:= Gdip_CreateBitmapFromFile(sFile)
hBitmap	:= Gdip_CreateHBITMAPFromBitmap(pBitmap)
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)
SetClipboardData(8, hBitmap)
DllCall("DeleteObject", "Uint", hBitmap)
Return

SetClipboardData(nFormat, hBitmap)
{
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