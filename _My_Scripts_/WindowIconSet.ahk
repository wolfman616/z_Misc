WindowIconSet(hWndl,Icon_Path,Index:= 0,byref B64Small="",byref B64Reg="") {
	local
	listlines,off
	Token:= Gdip_Startup() 
	static SM_CXSMICON,SM_CXICON
	if(!SM_CXICON) ; init the icon metric values for regular and small icon pixel spans.
			SM_CXICON:=   DllCall("GetSystemMetrics","Int",11)
	,		SM_CXSMICON:= DllCall("GetSystemMetrics","Int",49)
	SendMessage,0x80,0,(B64Small=""? HiconD(Icon_Path,SM_CXSMICON) : b64_2_hicon(B64Small)),,ahk_id %hWndl% ;WM_SETICON,ICON_SMALL
	SendMessage,0x80,1,(B64Reg=""?   HiconD(Icon_Path,SM_CXICON)   : b64_2_hicon(B64Reg)),,ahk_id %hWndl% ;WM_SETICON,ICON_LARGE
	Gdip_shutdown(Token)
	return,ErrorLevel 
}

HiconD(Ico_Path,dim) {
	local
	listlines,off
	pBitmap:= Gdip_CreateBitmapFromFile(Ico_Path,"",dim)
	pImage:= Gdip_CreateBitmap(dim,dim), G2:= Gdip_GraphicsFromImage(pImage)
	Gdip_DrawImage(G2,pBitmap,0,0,dim,dim,0,0,dim,dim)
	Gdip_SetInterpolationMode(G2,1), Gdip_SetSmoothingMode(G2,1)
	hicon2:= Gdip_CreateHICONFromBitmap(pBitmap)
	DllCall("Gdiplus.dll\GdipDisposeImage","Ptr",pBitmap)
	Gdip_DeleteGraphics(g2)
	Gdip_DisposeImage(pImage)	
	return,byref hicon2
}