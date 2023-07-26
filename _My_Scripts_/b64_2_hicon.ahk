b64_2_hicon(B64in,NewHandle:= False) {
	listlines,off
	Static hBitmap:= 0
	(NewHandle? hBitmap:= 0)
	If(hBitmap)
		Return,hBitmap
	VarSetCapacity(B64,3864 <<!!A_IsUnicode)
	If(!DllCall("Crypt32.dll\CryptStringToBinary","Ptr",&B64in,"UInt",0,"UInt", 0x01,"Ptr",0,"UIntP",DecLen,"Ptr",0,"Ptr",0))
		Return,False
	VarSetCapacity(Dec,DecLen,0)
	If(!DllCall("Crypt32.dll\CryptStringToBinary","Ptr",&B64in,"UInt",0,"UInt",0x01,"Ptr",&Dec,"UIntP",DecLen,"Ptr",0,"Ptr",0))
		Return,False
	  hData:= DllCall("Kernel32.dll\GlobalAlloc","UInt",2,"UPtr",DecLen,"UPtr"), pData:= DllCall("Kernel32.dll\GlobalLock","Ptr",hData,"UPtr")
	,	DllCall("Kernel32.dll\RtlMoveMemory","Ptr",pData,"Ptr",&Dec,"UPtr",DecLen), DllCall("Kernel32.dll\GlobalUnlock","Ptr",hData)
	, DllCall("Ole32.dll\CreateStreamOnHGlobal","Ptr",hData,"Int",True,"PtrP",pStream)
	, hGdip:= DllCall("Kernel32.dll\LoadLibrary","Str","Gdiplus.dll","UPtr"), VarSetCapacity(SI,16,0), NumPut(1,SI,0,"UChar")
	, DllCall("Gdiplus.dll\GdiplusStartup","PtrP",pToken,"Ptr",&SI,"Ptr",0)
	, DllCall("Gdiplus.dll\GdipCreateBitmapFromStream","Ptr",pStream,"PtrP",pBitmap)
	, DllCall("gdiplus\GdipCreateHICONFromBitmap","UPtr",pBitmap,"UPtr*",hIcon)
	, DllCall("Gdiplus.dll\GdipDisposeImage","Ptr",pBitmap), DllCall("Gdiplus.dll\GdiplusShutdown","Ptr",pToken)
	,DllCall("Kernel32.dll\FreeLibrary","Ptr",hGdip), DllCall(NumGet(NumGet(pStream +0,0,"UPtr") +(A_PtrSize *2),0,"UPtr"),"Ptr",pStream)
	Return,hIcon
}