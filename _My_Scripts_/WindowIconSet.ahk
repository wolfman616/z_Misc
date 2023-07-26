WindowIconSet(hWndl,Icon_Path,Index := 0,b64small="",b64reg="")  {
	global
	local Token
	listlines,off
	Token:= (!pToken? Gdip_Startup() : pToken)
	static SM_CXSMICON,SM_CXICON

	if(!SM_CXICON) {	; init the icon metric values for regular and small icon pixel spans.
		;sysget,SM_CXSMICON,49;	sysget,SM_CXICON,12
		SM_CXICON:= DllCall("GetSystemMetrics", "Int",11)
		SM_CXSMICON:= DllCall("GetSystemMetrics", "Int",49)	
		}

	SendMessage,0x80,0,HiconD(Icon_Path,SM_CXSMICON),,ahk_id %hWndl% ;WM_SETICON,ICON_SMALL
	SendMessage,0x80,1,HiconD(Icon_Path,SM_CXICON),,ahk_id %hWndl% ;WM_SETICON,ICON_LARGE
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
	return,byref hicon2
}