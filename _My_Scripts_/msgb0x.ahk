;Msgb0X("MsgStr","","","","C:\Icon\256\Autism5.ico")
 Msgb0X(title="",MsgStr="",timeout="",flags="",NoModality="",icon="") { ; (!MATTHEW JAMES WOLFF 1980)
	(!MsgStr?(MsgStr:=title,TITLE:=""))                                 ; (!timeout ? timeout := 989)
	;((MsgStr is integer)? msgbox) ;not working yet
	;&&(!flags)&&(!timeout))?(timeout:=MsgStr)) 
	(!flags)?(flags:=0x43040):(),(!title)?(title:="Attention")  		;   NoTitle ? NoProbs
	(!NoModality="")?(Gui(gui:="_",command   :=  "+OwnDialogs"))        ;     modal ?
	(!icon="")?(SendWM_CoPYData(("mb" . ico2hicon(ICON))                ;    !sane  ? sleep,  timeout
	,"WinEvent.ahk ahk_class AutoHotkey")):("")                         ;           ? headless 
	msgbox,% flags,% title,% MsgStr,% timeout	                        ;  Msg in pissbottle. BoWtZ
	(!NoModality="")?(Gui(gui:="_",  command := "Destroy"))             ; (MW:2022)(MW:2022)(MW:2022)
	return,MsgStr                                                       ; KUNAI:2022:KUNAI:2022:KUNAI
} ; param 2 not a string ? param 1,2 swap ;                                                                 