﻿#noEnv
#MenuMaskKey vkE8
#singleInstance,Force
#UseHook On
#InstallMouseHook
#InstallKeybdHook
SetControlDelay,-1
SetKeyDelay,-1
;SetStoreCapsLockMode,OFF
;#WinActivateForce
;#KeyHistory,	10
;  ListLines,	off
#maxhotkeysPerInterval,1440
#maxThreadsPerhotkey,	1
DetectHiddenText, 		On
DetectHiddenWindows, 	On
settitlematchmode,		2 
settitlematchmode,		slow
#IfTimeout 120
;setbatchlines,		-1
SetWinDelay,		-1
global lf,offset,r,IM

;	global ICONMETRICS:="
;	(
	; UINT cbSize;
	; INT iHorzSpacing;
	; INT iVertSpacing;
	; INT iTitleWrap;
	; hFont lf;
;	)"

msgbox,% "LOGFONT SZ: " LOGFONTSize:= 46 *(A_IsUnicode? 2:1)
 
; ICONMETRICSW_STRUCT
VarSetCapacity(IM,108) 
NumPut(108,IM,0,"uInt") 
success:= DllCall("SystemParametersInfoW","UInt",0x002D,"UInt",108,"uint",&IM,"uint",0,"Uint") ; Enable
offset:= 42 ;msgbox,% NumGet(lfw,28 + a_index,"uChar")
loop,parse,% "Continuum Light"
	numput(asc(a_loopfield),IM,offset+=1,"char")
success:= DllCall("SystemParametersInfoW","UInt",0x002E,"UInt",108,"uint",&IM,"uint",1,"Uint") ; Enable
VarSetCapacity(IM,108)
NumPut(108,IM,0,"uInt") 
	success:= DllCall("SystemParametersInfoW","UInt",0x002D,"UInt",108,"uint",&IM,"uint",0,"Uint") ; Enable
offset:= 42, n00s:= ""
 While (offset < 108){
	ad:= chr(NumGet(IM,offset += 1,"Char") )
	n00s.= ad ;msgbox % offset "`n" ad
	aa:= a_index
}
msgbox,% "resul! " n00s "`n" aa
sizeT:= 96 ;spihFont:= NumGet(&IM,16,92)
;VarSetCapacity(LF,LOGFONTSize,0)
 VarSetCapacity(lf,LOGFONTSize)
NumPut(spihFont,lfw,0,"uInt")
numput(-22,	&LF,0,"long")	;Height
numput(0,	&LF,4,"long")	;Width
numput(0,	&LF,8,"long")	;Escapement
numput(0,	&LF,12,"long")	;Orientation
numput(400,	&LF,16,"long")	;Weight
offset:= 16 ; msgbox,% NumGet(&LF,16,"long")
; Of Type BYTE
numput(0,&LF,7	+offset,"byte")		;Italic Verified
numput(0,&LF,8	+offset,"byte")		;Underline Verified
numput(0,&LF,9	+offset,"byte")		;StrikeOut Verified
numput(1,&LF,10	+offset,"byte")		;CharSet
numput(1,&LF,11	+offset,"byte")		;OutPrecision
numput(0,&LF,5	+offset,"byte")		;ClipPrecision
numput(0,&LF,6	+offset,"byte")		;Quality
numput(144,&LF,4+offset,"byte")	PitchAndFamily
offset:=27 ; r:="g"
loop,parse,% "Continuum Light",
	numput(asc(a_loopfield),&LF,offset+=1,"char")
offset:= 27, n00s:= ""
While(offset<LOGFONTSize) {
	  ad:=chr(NumGet(&lf,offset+=1,"Char"))
	n00s.=ad
}
msgb0x(n00s " fin") 
return,

; CNT:= a_index 
; loop %CNT% {
  ; r:= chr(NumGet(LF,15 +a_index,"uChar"))
	; a:= a . r
 ; }
 ; msgbox % a ; RegExReplace(a,"[^a-zA-Z]") 
 ; While (offset<sizeT){
			; this.FaceName.=Chr(NumGet(buff,offset+=1,"Char"))
		; }
; numput("Continuum Light",LF,71 +offset,"str") ;FaceName
; 4 *0 +offset +72

^#c::
winget,rg,id,ahk_class RegEdit_RegEdit
MouseGetPos,x,y,win
WinGet,ActiveControlList,ControlListhWnd,ahk_id %win%
; msgbox,% chr(NumGet(font0.hFont,28 +a_index,"uChar"))
Loop,Parse,ActiveControlList,`n
{
	SendMessage,0x0030,&lf,1,,ahk_id %A_LoopField% ; SCI_STYLEGETFONT,STYLE_DEFAULT
	sleep,2000
	SendMessage,0x0030,0,1,,ahk_id %A_LoopField% ; SCI_STYLEGETFONT,STYLE_DEFAULT
	; font0 := New LOGFONT(A_LoopField)
	; MsgBox,% "W`tH`n" n00s:= RegExReplace(font0.FaceName,"[^a-zA-Z ]") 
	; 0x0030
	; MsgBox,% "Some LOGFONT Values`n`n" font0.Print()
	; MsgBox,% "Test of UpdateFont`n`n" var "`n`n`n" "W`tH`n" font0.print()
}
exit,
	
WinGet,ActiveControlList,ControlListhWnd,ahk_id %rg%
Loop,Parse,ActiveControlList,`n
{
	SendMessage,0x0030,&font0.hFont,1,,ahk_id %A_LoopField% ; SCI_STYLEGETFONT,STYLE_DEFAULT
	msgbox,% eRrOrLeVeL
}
;	SendMessage,0x31,0,0,,ahk_id %hWnd% ; WM_GETFONT
;	thhFont:= DllCall("SendMessage","Ptr",rg,"UInt",&font0,"Ptr",1,"Ptr")
exit,
Gui,Font,s15,Klingon
GuiControl,Font,%hWnd0%
font0.UpdateFont() 
MsgBox,% "Test of UpdateFont`n`n" var "`n`n`n" "W`tH`n" font0.print()
return,

; -Continuum Light-
; Height:		-22
; Width:		0
; Escapement:	0
; Orientation:	0
; Weight:		400
; Italic:		0
; Underline:		0
; StrikeOut:		0
; CharSet:		1
; OutPrecision:	1
; ClipPrecision:	0
; Quality:		0
; PitchAndFamily:	144

; VarSetCapacity(LF,96,0)
; numput(-22,LF,1 * 0,"Int") ;Height
; numput(0, LF,1 * 1,"Int") ;Width
; numput(0, LF,1 * 2,"Int") ;Escapement
; numput(0, LF,1 * 3,"Int") ;Orientation
; numput(400,LF,1 * 4,"Int") ;Weight
; ; a_ptrsize
; offset := 4 * 4

;Of Type BYTE
; numput(1,LF,1 * 1 + offset,"UChar") ;OutPrecision
; numput(0,LF,1 * 2 + offset,"UChar") ;ClipPrecision
; numput(0,LF,1 * 3 + offset,"UChar") ;Quality
; numput(0,LF,1 * 4 + offset,"UChar") ;Italic Verified
; numput(0,LF,1 * 5 + offset,"UChar") ;Underline Verified
; numput(0,LF,1 * 6 + offset,"UChar") ;StrikeOut Verified
; numput(1,LF,1 * 7 + offset,"UChar") ;CharSet
; numput(144,LF,1 * 0 + offset,"UChar") ;PitchAndFamily
; numput("Continuum Light",LF,4 * 0 + offset,"Ustr") ;FaceName
;4 * 0 + offset +72

HIWORD(Dword,Hex=0){
	BITS:=0x10,WORD:=0xFFFF
	return,(!Hex)?((Dword>>BITS)&WORD):Format("{1:#x}",((Dword>>BITS)&WORD))
}

LOWORD(Dword,Hex=0){
	WORD:= 0xFFFF
	return,(!Hex)?(Dword&WORD):Format("{1:#x}",(Dword&WORD))
}

MAKELONG(LOWORD,HIWORD,Hex=0){
	BITS:= 0x10,WORD:= 0xFFFF
	return,(!Hex)?((HIWORD<<BITS)|(LOWORD&WORD)):Format("{1:#x}",((HIWORD<<BITS)|(LOWORD&WORD)))
}

GetFont() {
	FontName:= FontSize:= FontStyle:= ""

	Wingetclass Class,ahk_id %g_hWnd%
	If (Class=="Scintilla") {
		FontName:= Scintilla_GetFont(g_hWnd)
		FontSize:= SendMsg(2485,32) ; SCI_STYLEGETSIZE,STYLE_DEFAULT
	} Else {
		Control_GetFont(g_hWnd,FontName,FontSize,FontStyle)
		If(FontName=="" || FontSize>1000) {
			return,"System default"
	}	}

	FontInfo := FontName . ", " . Format("{:d}",FontSize)
	If (FontStyle!="")
		FontInfo.=", " . FontStyle
	return,FontInfo
}

Control_GetFont(hWnd,ByRef Name,ByRef Size,ByRef Style,IsGDIFontSize:=0) {
	SendMessage,0x31,0,0,,ahk_id %hWnd% ; WM_GETFONT
	If(eRrOrLeVeL=="FAIL")
		return,

	hFont:= eRrOrLeVeL
	VarSetCapacity(LOGFONT,LOGFONTSize:= 60*(A_IsUnicode? 2:1))
	DllCall("GetObject","Ptr",hFont,"Int",LOGFONTSize,"Ptr",&LOGFONT)
	Name:=DllCall("MulDiv","Int",&LOGFONT+28,"Int",1,"Int",1,"Str")
	Style:= Trim((Weight:= NumGet(LOGFONT,16,"Int"))==700? "Bold" : (Weight==400)? "" : "w" . Weight
	. (NumGet(LOGFONT,20,"UChar")?" Italic "  :"")
	. (NumGet(LOGFONT,21,"UChar")?" Underline ":"")
	. (NumGet(LOGFONT,22,"UChar")?" Strikeout ":""))
	Size:=IsGDIFontSize?-NumGet(LOGFONT,0,"Int"):Round((-NumGet(LOGFONT,0,"Int")*72)/A_ScreenDPI)
}

Scintilla_GetFont(hWnd) {
	WinGet PID,PID,ahk_id %hWnd%
	If !(hProc:= DllCall("OpenProcess","UInt",0x438,"Int",False,"UInt",PID,"Ptr"))
		return,
	Address:=DllCall("VirtualAllocEx","Ptr",hProc,"Ptr",0,"UPtr",32,"UInt",0x1000,"UInt",4,"Ptr")    
	SendMessage,2486,32,Address,,ahk_id %hWnd% ; SCI_STYLEGETFONT,STYLE_DEFAULT ; LF_FACESIZE := 32
	If(eRrOrLeVeL!="FAIL") {
		VarSetCapacity(FontName,32,0)
		DllCall("ReadProcessMemory","Ptr",hProc,"Ptr",Address,"Ptr",&FontName,"UPtr",32,"Ptr",0)
		FontName:= StrGet(&FontName,"UTF-8")
	}
	DllCall("VirtualFreeEx","Ptr",hProc,"Ptr",Address,"UPtr",0,"UInt",0x8000) ; MEM_RELEASE
	DllCall("CloseHandle","Ptr",hProc)
	return,FontName
}

SendMsg(Message,wParam:=0,lParam:=0) {
	SendMessage,% Message,% wParam,% lParam,,ahk_id %g_hWnd%
	Return,eRrOrLeVeL
}

Class LOGFONT{
	Static WM_GETFONT:= 0x31, LONG:= 4, BYTE:= 1, hFont:= 0, hWnd, Height:= 0, Width:= 0
	, Escapement:= 0, Orientation:= 0, Weight:= 0
	Italic:=0, Underline:= 0, StrikeOut:= 0, CharSet:= 0, OutPrecision:= 0
	, ClipPrecision:= 0, Quality:= 0, PitchAndFamily:= 0
	FaceName:=""

	__New(hWnd){
		this.hWnd:=hWnd
		this.UpdateFont()
	}

	UpdateFont(){
		this.hFont:= DllCall("SendMessage",	"Ptr",this.hWnd, "UInt",this.WM_GETFONT,"Ptr",0,"Ptr",0,"Ptr")
			amount:= DllCall("GetObject",	"Ptr",this.hFont,"Int",0,"Ptr",0)
		VarSetCapacity(buff,amount)
			amount:= DllCall("GetObject",	"Ptr",this.hFont,"Int",amount,"Ptr",&buff)
		this.GetData(buff,amount)
	}	; ---------------------------	;----------------------------; hf0nt := "￪c0"

	GetData(ByRef buff,amount){	; ---------------------------		; Of Type LONG ;msgbox % this.LONG
		this.Height		:= NumGet(buff,this.LONG * 0,"Int") ; Verified 
		this.Width		:= NumGet(buff,this.LONG * 1,"Int")
		this.Escapement := NumGet(buff,this.LONG * 2,"Int")
		this.Orientation:= NumGet(buff,this.LONG * 3,"Int")
		this.Weight		:= NumGet(buff,this.LONG * 4,"Int") ; Verified.
		offset := this.byte * 4 ; Of Type BYTE		;msgbox % aa:=(this.BYTE * 4 + offset)
		this.Italic			:= NumGet(buff,this.BYTE * 4 + offset,"UChar") ; Verified
		this.Underline		:= NumGet(buff,this.BYTE * 5 + offset,"UChar") ; Verified
		this.StrikeOut		:= NumGet(buff,this.BYTE * 6 + offset,"UChar") ; Verified
		this.CharSet		:= NumGet(buff,this.BYTE * 7 + offset,"UChar")
		this.OutPrecision	:= NumGet(buff,this.BYTE * 1 + offset,"UChar")
		this.ClipPrecision	:= NumGet(buff,this.BYTE * 2 + offset,"UChar")
		this.Quality		:= NumGet(buff,this.BYTE * 3 + offset,"UChar")
		this.PitchAndFamily := NumGet(buff,this.BYTE * 0 + offset,"UChar")
		offset += this.BYTE * 7 - 1
		this.FaceName:=""
		While,(offset<amount) ;	Of Type Char Array
			this.FaceName.=Chr(NumGet(buff,offset+=1,"Char"))
	}

	PixelWidth(str){
		return,this.GetDimensionsInPixels(str)["w"]
	}

	PixelHeight(str){
		return,this.GetDimensionsInPixels(str)["h"]
	}

	GetDimensionsInPixels(str){
		hDC:= DllCall("GetDC","Uint",this.hWnd)
		hFold:= DllCall("SelectObject","Uint",hDC,"Uint",this.hFont)
		DllCall("GetTextExtentPoint32","Uint",hDC,"str",str,"int",StrLen(str),"int64P",nSize)
		DllCall("SelectObject","Uint",hDC,"Uint",hFold)
		DllCall("ReleaseDC","Uint",this.hWnd,"Uint",hDC)
		nWidth := nSize &0xFFFFFFFF
		nHeight:= nSize >> 32 &0xFFFFFFFF
		return,{"w" : nWidth,"h" : nHeight}
	}

	Print(){
		LONG:= "Height:`t`t" this.Height "`nWidth:`t`t" this.Width "`nEscapement:`t" this.Escapement "`nOrientation:`t" this.Orientation "`nWeight:`t`t" this.Weight
		BYTE:= "Italic:`t`t" this.Italic "`nUnderline:`t`t" this.Underline "`nStrikeOut:`t`t" this.StrikeOut "`nCharSet:`t`t" this.CharSet "`nOutPrecision:`t" this.OutPrecision "`nClipPrecision:`t" this.ClipPrecision "`nQuality:`t`t" this.Quality "`nPitchAndFamily:`t" this.PitchAndFamily
		return,"-" RegExReplace(this.FaceName,"[^a-zA-Z ]") "-`n" LONG "`n" BYTE
}	}

GuiClose:
ExitApp