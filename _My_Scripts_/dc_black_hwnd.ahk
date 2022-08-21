
SetTitleMatchMode, 2
DetectHiddenWindows, On
#noEnv ; #warn
#persistent
#SingleInstance force
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard
;#include	C:\Script\AHK\- LiB\GDI+_All.ahk
 
#x::
mousegetpos x, y, hn, cn

dc := GetDC(hn)

pToken   := Gdip_Startup()

nW   := 1400
nH   := 1000

mDC   := Gdi_CreateCompatibleDC(0)
mBM   := Gdi_CreateDIBSection(mDC, nW, nH, 32) 
oBM   := Gdi_SelectObject(mDC, mBM)

	DllCall("gdi32.dll\SetStretchBltMode", "Uint", dc, "Int", 5)
	DllCall("gdi32.dll\StretchBlt", "Uint",dc , "Int", 0, "Int", 0, "Int", nW , "Int", nW , "UInt", mdc, "UInt", 0, "UInt", 0, "Int", nW, "Int", nH, "UInt", "0x00CC0020")

return
Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return

GetDC(hwnd:=0) {
   return DllCall("GetDC", "UPtr", hwnd)
}
Gdip_Startup(multipleInstances:=0) {
   pToken := 0
   If (multipleInstances=0)
   {
      if !DllCall("GetModuleHandle", "str", "gdiplus", "UPtr")
         DllCall("LoadLibrary", "str", "gdiplus")
   } Else DllCall("LoadLibrary", "str", "gdiplus")

   VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
   DllCall("gdiplus\GdiplusStartup", "UPtr*", pToken, "UPtr", &si, "UPtr", 0)
   return pToken
}

Gdi_CreateCompatibleDC(hDC = 0) {
   Return DllCall("gdi32\CreateCompatibleDC", "Uint", hDC)
}

Gdi_CreateDIBSection(hDC, nW, nH, bpp = 32, ByRef pBits = "") {
   NumPut(VarSetCapacity(bi, 40, 0), bi)
   NumPut(nW, bi, 4)
   NumPut(nH, bi, 8)
   NumPut(bpp, NumPut(1, bi, 12, "UShort"), 0, "Ushort")
 
   Return   DllCall("gdi32\CreateDIBSection", "Uint", hDC, "Uint", &bi, "Uint", DIB_RGB_COLORS:=0, "UintP", pBits, "Uint", 0, "Uint", 0)
}

Gdi_SelectObject(hDC, hGdiObj) {
   Return   DllCall("gdi32\SelectObject", "Uint", hDC, "Uint", hGdiObj)
}