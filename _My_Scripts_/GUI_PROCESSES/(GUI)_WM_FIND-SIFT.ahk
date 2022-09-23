#noenv
SetBatchLines,	-1
SetWinDelay,	-1
SetControlDelay,-1
CoordMode,tooltip,Screen
Coordmode,Mouse,Screen
menu,tray,icon,% "C:\Icon\40_20 Ribbon\search144.ico"
SetWorkingDir,% (ahkexe:= splitpath(A_AhkPath)).dir
global MainGuititle:= "WM_FIND-SIFT"
global rect,G_hWnd,lvhwnd,dd,TrigG,LbD,button_cooldown,TrigG,Hmain 
global sizemaxx:=1144,	sizeminx:=140

 OnMessage(0x0047,"WM_WINDOWPOSCHANGED")
 OnMessage(0x0201,"WM_LrBUTTONDOWN")
 OnMessage(0x0204,"WM_lRBUTTONDOWN") 
 OnMessage(0x0202,"WM_LrBUTTONUP")
 OnMessage(0x0205,"WM_lrBUTTONUP")
 OnMessage(0x0101,"WM_KEYUP")

fileread,constants,lib\_const\const.csv
Loop,Parse,constants,","
	data.= data ? "`n" A_LoopField : A_LoopField
 Display:= data
 Options:= "in" 
 col:= {}, colw:= ((c1:= 238)+(c2:= 60)+(c3:= 76) + nuffer:= 25)
 col:= ({1 : c1 , 2 : c2 ,3 : c3 , "W" : colw })

gui,m:New,-dpiscale +hwndG_hWnd
gui,m:Add,Edit,x88 y+0 w161 h25 vQueryText gQuery +hwndedithwnd ;+e0x8,
ww:=("w" . col.w),	wt:=("w" . col.w+4),	wz:=col.w
gui,m:Add,ListView,grid x0 y6 %wW% h600 r20 gLVGlabl vLVGlabl +hwndlvhwnd +e0x00224008, wMsg | Dec | Hex ;w380
SendMessage, 0x1036, 0, 0x14031,, ahk_id %lvhwnd% ;stylex
LV_ModifyCol(1,	"text "  . col.1) ; change width of alphanum  field
LV_ModifyCol(2,	"right " . col.2)
LV_ModifyCol(3,	"Left "  . col.3)
Loop,Parse,Data,`n
{
	rows++ 
	Array1:= StrSplit(A_Loopfield, ",")
	LV_Add("",Array1[1],Array1[3],Array1[2])
}
gui,m:+Resize +MaxSize%wz%x%sizemaxx% +MinSize%wz%x%sizeminx%
gui,m:Show,%wt% Center,% MainGuititle
gpos:= wingetpos(g_hwnd)
Hmain:= gpos.h
return

Query:
gui,m:Submit,NoHide
Display:= Sift_Regex(Data, QueryText, Options)
displayRows:= 0
Loop,Parse,Display,`n
{
	displayRows++
	displayRow%a_index%:= a_loopfield
}
loop,% rows {
	if (a_index<=displayRows) {
		Array2:= StrSplit(displayRow%a_index%,",")
		LV_Modify(a_index,,Array2[1],Array2[2],Array2[3])
	} else,LV_Modify(a_index,,"","","")
}
return,

WM_WINDOWPOSCHANGED(){
	global lvhwnd,g_hwnd
	sleep,4
	Hmain:=(gpos:=wingetpos(g_hwnd)).h
	if !(inith=gpos.h) {
		dd:=Hmain -55
		guiControl, Move,% lvhwnd, h%dd%
		inith:=Hmain
	}
}

LVGlabl:
if (A_guiControlEvent == "R") {
	LV_GetText(name,A_EventInfo,1)
	tt("Constant name: " clipboard:= name "`r`n(on clipboard also")
	return,
}

if (A_guiControlEvent == "DoubleClick") {
	LV_GetText(number,A_EventInfo,2)
	tt("Constant integer value: " 	clipboard:= number "`r`n(on clipboard also")
	return
}
return

~Escape::
guiClose:
ExitApp,

WM_lrBUTTONDOWN(byref wParam,byref lParam) {
	global lbutton_cooldown, lbd, gpos, TrigG:= false
	static rDPI:= A_ScreenDPI/96
	static rECT:= VarSetCapacity(RECT,16)
	Coordmode,Mouse,window
	mousegetpos,mx,my
	
	timer("grace",-20)
	
	ys:= hiword(lParam),	xs:= loword(lParam),	gpos:= wingetpos(g_hwnd)
	
	While LbD:=GetKeyState("lbutton","P") {
		DllCall("GetCursorPos","Uint",&RECT)
		vWinX:= NumGet(&RECT,0,"Int")-mx,	vWinY:= NumGet(&RECT,4,"Int")-my
		(!TrigG? timer("disgrace",-150))
		win_move(g_hWnd,vWinX,vWiny,gpos.w,gpos.h,0x4001)
	}

	if TrigG
		return
	return,1

	disgrace:
	   grace:
	   TrigG:= instr(a_thislabel,"dis")? false : true
	return,
}

WM_lrBUTTONup(wParam="", lParam="") { 	;toggles maximise fill
	global TrigG,LbD:=""
	 (!TrigG)?	return	: ()
}

WM_KEYUP(wParam, lParam){
	static pp0:=MAKELONG(loword(36),hiword(62)) 

	global hWnd_Par
	switch wParam {
		case "27 ": ;esc
			settimer,guiclose,-1
			return,
		case "13": ;enter
			gui,m: submit,nohide
			guiControl, Show,% lvhwnd
			; goSub("editx")
			; goSub("edity")
			; goSub("Timertest2")
			send,{tab}
			sleep,70
			send,^{home}
			sleep,70
			loop,2
				sendmessage, 0x0200,0,%pp0%, SysHeader321,ahk_id %lvhwnd%
		default:
			tt(wParam "`n" Format("{1:#x}",lParam))
	}
}

menu(){
	menu,new,add, cunts, donothing
	menu,new,show
}

HiWord(Dword,Hex=0){
	BITS:=0x10,WORD:=0xFFFF
	return,(!Hex)?((Dword>>BITS)&WORD):Format("{1:#x}",((Dword>>BITS)&WORD))
}

LoWord(Dword,Hex=0){
	WORD:=0xFFFF
	return,(!Hex)?(Dword&WORD):Format("{1:#x}",(Dword&WORD))
}

MAKELONG(LOWORD,HIWORD,Hex=0){
	BITS:=0x10,WORD:=0xFFFF
	return,(!Hex)?((HIWORD<<BITS)|(LOWORD&WORD)):Format("{1:#x}",((HIWORD<<BITS)|(LOWORD&WORD)))
}

donothing:
return,

;{ Sift
; Fanatic Guru; 2015 04 30; Version 1.00;; LIBRARY to sift through a string or array and return items that match sift criteria.
;
; Functions: ; Sift_Regex(Haystack, Needle, Options, Delimiter)
;
;   Parameters:;   1) {Haystack}	String or array of information to search, ByRef for efficiency but Haystack is not changed by function
;
;   2) {Needle}		String providing search text or criteria, ByRef for efficiency but Needle is not changed by function
;
;	3) {Options}
;			IN		Needle anywhere IN Haystack item (Default = IN)
;			LEFT	Needle is to LEFT or beginning of Haystack item
;			RIGHT	Needle is to RIGHT or end of Haystack item
;			EXACT	Needle is an EXACT match to Haystack item
;			REGEX	Needle is an REGEX expression to check against Haystack item
;			OC		Needle is ORDERED CHARACTERS to be searched for even non-consecutively but in the given order in Haystack item 
;			OW		Needle is ORDERED WORDS to be searched for even non-consecutively but in the given order in Haystack item
;			UC		Needle is UNORDERED CHARACTERS to be search for even non-consecutively and in any order in Haystack item
;			UW		Needle is UNORDERED WORDS to be search for even non-consecutively and in any order in Haystack item
;
;			If an Option is all lower case then the search will be case insensitive
;
;	4)  {Delimiter}	Single character Delimiter of each item in a Haystack string (Default = `n)
;
;	Returns: 
;		If Haystack is string then a string is returned of found Haystack items delimited by the Delimiter
; 		If Haystack is an array then an array is returned of found Haystack items
;
; 	Note:
;		Sift_Regex searchs are all RegExMatch seaches with Needles crafted based on the options chosen
;
; Sift_Ngram(Haystack, Needle, Delta, Haystack_Matrix, Ngram Size, Format)
;
;	Parameters:
;	1) {Haystack}		String or array of information to search, ByRef for efficiency but Haystack is not changed by function
;
;   2) {Needle}			String providing search text or criteria, ByRef for efficiency but Needle is not changed by function
;
;	3) {Delta}			(Default = .7) Fuzzy match coefficient, 1 is a prefect match, 0 is no match at all, only results above the Delta are returned
;
;	4) {Haystack_Matrix} (Default = false)	
;			An object containing the preprocessing of the Haystack for Ngrams content
;			If a non-object is passed the Haystack is processed for Ngram content and the results are returned by ByRef
;			If an object is passed then that is used as the processed Ngram content of Haystack
;			If multiply calls to the function are made with no change to the Haystack then a previous processing of Haystack for Ngram content 
;				can be passed back to the function to avoid reprocessing the same Haystack again in order to increase efficiency.
;	5) {Ngram Size}		(Default = 3) The length of Ngram used.  Generally Ngrams made of 3 letters called a Trigram is good
;	6) {Format}			(Default = S`n)
;			S				Return Object with results Sorted
;			U				Return Object with results Unsorted
;			S%%%			Return Sorted string delimited by characters after S
;			U%%%			Return Unsorted string delimited by characters after U
;								Sorted results are by best match first
;	Returns:
;		A string or array depending on Format parameter.
;		If string then it is delimited based on Format parameter.
;		If array then an array of object is returned where each element is of the structure: {Object}.Delta and {Object}.Data
;			Example Code to access object returned:
;				for key, element in Sift_Ngram(Data, QueryText, NgramLimit, Data_Ngram_Matrix, NgramSize)
;						Display .= element.delta "`t" element.data "`n"
;	Dependencies: Sift_Ngram_Get, Sift_Ngram_Compare, Sift_Ngram_Matrix, Sift_SortResults
;		These are helper functions that are generally not called directly.  Although Sift_Ngram_Matrix could be useful to call directly to preprocess a large static Haystack
; 	Note:
;		The string "dog house" would produce these Trigrams: dog|og |g h| ho|hou|ous|use
;		Sift_Ngram breaks the needle and each item of the Haystack up into Ngrams.
;		Then all the Needle Ngrams are looked for in the Haystack items Ngrams resulting in a percentage of Needle Ngrams found
;
;
Sift_Regex(ByRef Haystack, ByRef Needle, Options := "IN", Delimit := "`n")
{
	Sifted := {}
	if (Options = "IN")		
		Needle_Temp := "\Q" Needle "\E"
	else if (Options = "LEFT")
		Needle_Temp := "^\Q" Needle "\E"
	else if (Options = "RIGHT")
		Needle_Temp := "\Q" Needle "\E$"
	else if (Options = "EXACT")		
		Needle_Temp := "^\Q" Needle "\E$"
	else if (Options = "REGEX")
		Needle_Temp := Needle
	else if (Options = "OC")
		Needle_Temp := RegExReplace(Needle,"(.)","\Q$1\E.*")
	else if (Options = "OW")
		Needle_Temp := RegExReplace(Needle,"( )","\Q$1\E.*")
	else if (Options = "UW")
		Loop, Parse, Needle, " "
			Needle_Temp .= "(?=.*\Q" A_LoopField "\E)"
	else if (Options = "UC")
		Loop, Parse, Needle
			Needle_Temp .= "(?=.*\Q" A_LoopField "\E)"
	if Options is lower
		Needle_Temp := "i)" Needle_Temp

	if IsObject(Haystack)
	{
		for key, Hay in Haystack
			if RegExMatch(Hay, Needle_Temp)
				Sifted.Insert(Hay)
	}
	else
	{
		Loop, Parse, Haystack, %Delimit%
			if RegExMatch(A_LoopField, Needle_Temp)
				Sifted .= A_LoopField Delimit
		Sifted := SubStr(Sifted,1,-1)
	}
	return Sifted
}

Sift_Ngram(ByRef Haystack, ByRef Needle, Delta := .7, ByRef Haystack_Matrix := false, n := 3, Format := "S`n" )
{
	if !IsObject(Haystack_Matrix)
		Haystack_Matrix := Sift_Ngram_Matrix(Haystack, n)
	Needle_Ngram := Sift_Ngram_Get(Needle, n)
	if IsObject(Haystack)
	{
		Search_Results := {}
		for key, Hay_Ngram in Haystack_Matrix
		{
			Result := Sift_Ngram_Compare(Hay_Ngram, Needle_Ngram)
			if !(Result < Delta)
				Search_Results[key,"Delta"] := Result, Search_Results[key,"Data"] := Haystack[key]
		}
	}
	else
	{
		Search_Results := {}
		Loop, Parse, Haystack, `n, `r
		{
			Result := Sift_Ngram_Compare(Haystack_Matrix[A_Index], Needle_Ngram)
			if !(Result < Delta)
				Search_Results[A_Index,"Delta"] := Result, Search_Results[A_Index,"Data"] := A_LoopField
		}
	}
	if (Format ~= "i)^S")
		Sift_SortResults(Search_Results)
	if RegExMatch(Format, "i)^(S|U)(.+)$", Match)
	{
		for key, element in Search_Results
			String_Results .= element.data Match2
		return SubStr(String_Results,1,-StrLen(Match2))
	}
	else
		return Search_Results
}

Sift_Ngram_Get(ByRef String, n := 3)
{
	Pos := 1, Grams := {}
	Loop, % (1 + StrLen(String) - n)
		gram := SubStr(String, A_Index, n), Grams[gram] ? Grams[gram] ++ : Grams[gram] := 1
	return Grams
} 

Sift_Ngram_Compare(ByRef Hay, ByRef Needle)
{
	for gram, Needle_Count in Needle
	{
		Needle_Total += Needle_Count
		Match += (Hay[gram] > Needle_Count ? Needle_Count : Hay[gram])
	}
	return Match / Needle_Total
}

Sift_Ngram_Matrix(ByRef Data, n := 3)
{
	if IsObject(Data)
	{
		Matrix := {}
		for key, string in Data
			Matrix.Insert(Sift_Ngram_Get(string, n))
	}
	else
	{
		Matrix := {}
		Loop, Parse, Data, `n
			Matrix.Insert(Sift_Ngram_Get(A_LoopField, n))
	}
	return Matrix
}

Sift_SortResults(ByRef Data)
{
	Data_Temp := {}
	for key, element in Data
		Data_Temp[element.Delta SubStr("0000000000" key, -9)] := element
	Data := {}
	for key, element in Data_Temp
		Data.InsertAt(1,element)
	return
}