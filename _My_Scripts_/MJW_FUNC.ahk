;	_MJW_	;	(!MATTHEW JAMES WOLFF 1980)		;

Msgb0X(title="",MsgStr="",timeout="",flags="",NoModality="",icon="") {		; (!MATTHEW JAMES WOLFF 1980)
	(!MsgStr? (MsgStr:=title, TITLE:="")) 	                                ; (!timeout ? timeout := 989)
	(_path(timeout)? icon:=timeout)
	, (_path(flags)? icon:=flags)
	, (_path(NoModality)? icon:=NoModality)
	(_int(MsgStr)&&(!flags)&&(!timeout)? (timeout:=MsgStr
	,MsgStr:=title,title:="")) 
	(!flags)? (flags:= 0x43040) : (),(!title)? (title:= "Attention") 	    ;   NoTitle ? NoProbs
	(!NoModality= "")? (Gui(gui:= "_",command:= "+OwnDialogs")) 	        ;     modal ?
	(!icon="")? (SendWM_CoPYData(("mb" . ico2hicon(ICON)) 	                ;    !sane  ? sleep,  timeout
	,"WinEvent.ahk ahk_class AutoHotkey")) : ("") 	                        ;           ? headless 
	msgbox,% flags,% title,% MsgStr,% timeout 	                            ;  Msg in pissbottle. BoWtZ
	(!NoModality="")? (Gui(gui:= "_",  command:= "Destroy")) 	            ; (MW:2022)(MW:2022)(MW:2022)
	return,MsgStr 	                                                        ; KUNAI:2022:KUNAI:2022:KUNAI
} ; param 2 not a string ? swap param 1,2 

icon2msgb0x(path="") { ; STM_SETICON=0x0170 STM_GETICON=0x0171 STM_SETIMAGE=0x0172 STM_GETIMAGE=0x0173
	global hparent,i_handle,sss,ss
	WinGet,LL,List,ahk_class #32770 
	loop,    %LL%    {
		i_handle := LL%a_index%
		winget,Pn, processname, ahk_id %i_handle%
		if instr(pn,"AutoHot") {
			ControlGet,hParent,hWnd,,Static1,ahk_id %i_handle%	
			Icon_1:= ico2hicon("C:\Icon\256\Oxygeclose.ico") ; test
			Icon_2:= ico2hicon("C:\Icon\256\Oxygen-Icons.org-Oxygen-Actions-dialog-close.ico")
			settimer,Fn__iCOCK(ss,sss,hParent,i_handle),20
			return,(hParent ";" i_handle)
}	}	}	

	Fn__iCOCK(icoUnc1, icoUnc2, Pwnd, Iwnd){  ; upgrade to a class system or something
		SendMessage,0x0170,%icoUnc1%,,,ahk_id %Pwnd%
		sleep,88
		SendMessage,0x0170,%icoUnc2%,,,ahk_id %Pwnd%
		sleep,88	
		 if !winexist("ahk_id " . Iwnd)
			settimer, Fn__iCOCK, off
	}

StyLeCOmp(hwnd,styl,    xstyl, asBinary:=False)  {                              ;StyLCOmp(hwnd,styl,xstyl,returnbinary:=False){
	winget,   style,    style,  ahk_id %hwnd%                                  	;winget,  style,        style,   ahk_id %hwnd%
	winget,  exstyle,  exstyle, ahk_id %hwnd%                                  	;winget, exstyle,      exstyle,  ahk_id %hwnd%
	(!((style)  = (styl))? (sm1:=False) : (sm1:=True))                            	;(!(style  = styl) ?(sm1:=False) :(sm1:=True))
	(!((exstyle)=(xstyl))? (sm2:=False) : (sm2:=True))                            	;(!(exstyle=xstyl) ?(sm2:=False) :(sm2:=True))
	if (!asBinary) {     ; Ternary me  baby!                                 	;if !returnbinary {
		WinGetTITLE,	tTL,	ahk_id %hwnd%                                   ;	return,  _:= (!(sm1="") ? "Style Match" : "Style Mismatch" ) 
		(!(tTL=""))? (((tl:=strlen(tTL))>25)? (f:=SubStr(tTL,1,25)) : (f:=ttl)):() 	;	. " - "   .  (!(sm2="") ?"ExStyle Match":"ExStyle Mismatch")
		WinGetText,		txt,	ahk_id %hwnd%                                   	;} else, 
		(!(txt=""))? (((tl:=strlen(txt))>25)? (t:=SubStr(txt,1,25)) : (t:=txt)):() 	;return, _:=( (!(sm1="")&&(!(sm2="")))  ? True:False) }  
		(t? (t:=t . "`n"):(t:="")), (f? (f:=f . "`n"):(f:=""))                      
		(sm1=False)? (ret1:="     Style Mismatch") : (ret1:="    Style Match")
		(sm2=False)? (ret2:="exStyle Mismatch"   ) : (ret2:="exStyle Match"  )	
	  return,% (t f "    style  :  " style " : " ret1 "`neXstyle  :  " exStyle " : " ret2)
	} else,              ; U know U wanna
	  return,% ((sm1="")&&(sm2=""))? ( ret:=False ) : ( ret:=True )
}

key2hwnd(key="", hwnd="", cnt_name="") { 			; nohwnd ==> means Active Windpw	;	Accepts "string" keyname.
	static h:=(hwnd?hWnd:winexist("A")) 			; +f1::	;	WM_KEYDOWN=0x0100 f5=03F
(!key?static Key:="F5"),
 !cnt_name?static cnt_name:="SysListView321"
	vk:= GetKeyVK(key) 								; if !down {
	loop 2 {   ; GetKeySC(Key) l GetKeyName(Key)	; mousegetpos,x,y,hwnd
		switch a_index {                        	; PostMessage, 0x0100, 0x074,0,,ahk_id %hwnd%
			case "1":                           	;tt(lasterror(),2000)    
				wm:=0x0101                      	; down:=true
			case "2":                           	; } else,sleep,50
				sleep,20                        	; return,
				wm:=0x0100                      			
		}                                       	; +f1 up::	;	WM_KEYUP=0x0101 f5=0x074 VK NOT SC
		PostMessage,%wm%,%vk%,0,%cnt_name%,ahk_id %h%     ; if down {
	}                                           	; PostMessage, 0x0101, 0x074,0,%mctl%, ahk_id %hwnd% 
	return,lasterrOr()                         		;tt("Up " lasterror())
}                                               	; down:=False ; }

SendKi(Ki,Down_Up=""){    ;     -==-  (!d_u = =-=-=-= - -assuming-click-1'ce)
	((down_up="D")?down_up:="Down":((down_up="U")?down_up:="Up":down_up:=""))
	Send,   {%ki% %down_up%} ;-=-=-=^^^@::@::@^^^-==-=-=-=
	return,   ~eRrOrLeveL
} ;-==-=-=-=-=-==-=-=-=-=-==-=-=-=-=-==-=-=-=-=-==-=-=-=-=-==-=-=-=-=-==-=-=-=-=-=-=

sndMsg(Message, hwnd = "", wParam := 0, lParam := 0) {               
    SendMessage,% Message,% wParam,% lParam,,% !hwnd  ?               
	, x:=""  :  x:=("ahk_id " . hwnd)	                              
    Return, ErrorLevel                                                
}                 

gUi(byref guiname="",byref command1="",byref command2="") {	
	global
	( !command1 ? command1 := guiname : guiname := "_")
	(  !guiname  ?  guiname := "_" : ("") )
	gui,% guiname ": " command1 (!(command2="")?(,command2:="_"):(""))
	return, 
}

TT(TxT="ToolTip",x="",y="",dur="",inst:=1) { 		;tooltip wrap can also be called with 1 or 2 params, guess which.
	(!y&&!dur?dur:=(x?x:-670)) 						;default timeout 670ms (timeout can bput2 param.2 (int or str))
	((dur&&!dur=0)?(dur<100&&dur>-100)?(dur*=1000))
	(x="center"?Dur:=y, x:=(A_screenwidth*0.5)-80
	, y:=(A_screenheight*.5)-35,) 					; (y="center"?y:=(A_screenheight*.5)-35)
	ToolTip,% TxT,% (x&&y?x:""),% (x&&y?y:""), 1	;SetTimer,Timeout,% ((instr(dur,"-")||dur<0)?dur:("-" . dur))
	Timer("TTTo(inst)"),% ((instr(dur,"-")||dur<0)?dur:("-" . dur))
	return,~errOrlevel
}		

TTTo(instance:=1) {
	tooltip,%"",,,% instance
	return, 
}

LastError() {
	return,(global A_LastError?(runwait1("C:\Windows\System32\Err_6.4.5.exe " A_LastError))
	: errorlevel ? (ret:=errorlevel) : (ret:="No Errors"))
}

_Title(ahkidtype="") {	
  ((ahkidtype="") ? (ahkidtype:="A"):()) ; (IfNone, AssumeTarget=ActiveWin)
	wingettitle,_T,% ahkidtype
	return,% (_T ? retval:=_T : retval:="Untilted")
}

_class(wTtl="") {
	(!wTtl || wTtl="A") ? wC:="A" : (!(instr(wTtl, "ahk_exe ") || instr(wTtl,"ahk_pid "))? wTtl:="ahk_ID " . hWnd )
	WinGetClass,wclass,%  wTtl
	return,wclass
}

mCnThWnd(CntTl="") { ; mOuse2controlhwnd  ; iF((CntTl="m2")||(CntTl=""))
	mOuseGetPos,x,y,hWnd,mmCNT,2 ;eLSe,
	if CntTl
		ControlGet,CNT,hWnd,,%CntTl%,ahk_id %hWnd%
	return,% ret:=(CntTl?mmCNT:(CNT?CNT:0))
} ; rEturn,ret:=(CNT?ret:=CNT:ret:=mmCNT)

RUN(CommandStr, onPath="",pid="", dontHide="") {
(!dontHide?3z:="Hide")
	run,% CommandStr,% (onPath?2z:=onPath),% (pid_:=pid), %3z%
	if errorlevel
		msgb0x(lasterrOr())	
	if pid  ; ( pid ? pid:=quote(pid) )
		return,% (pid_?byref pid_:ret:=1)
}

runCMD(CommandStr, onPath="", pid="", dontHide="") {
	run,% (comspec " /C " CommandStr),% (onPath?2z:=onPath),% (!dontHide?3z:="hide"), %pid% ; remov 
	if errorlevel
		msgb0x(lasterrOr())
	return,(pid?byref pid:1) ; (pid ? a:=pid : a:="")
}

_INT(input) {
 if input is integer 
	 return,1
; else, return,0
}

_path(isUNC){
	return,regexmatch(isUNC,"(\:\\)|(\\_)")?1:0
}

_dir(path) {
	return,((fileexist(path))="D")?1:0
}

isContainingPathopen(FullPath) { ; check containing folder of target, if target is folder result is the folders parent,
	winget,Flist,List,ahk_Class CabinetWClass
	  if  !Flist
	   return,0
	SplitPath,FullPath,,OutDir
	loop,%Flist% {
		id:=Flist%a_index%
		ControlGetText, Txt,ToolbarWindow323,AHK_ID %id% ; explorer crumbs			
		msgbox % p:=( strReplace(Txt,"Address: ") )
		if (p=OutDir)  ; msgbox % p
			return,id
	} 
	return,0
}

OpenContaining(Target_Path, HighlightDisabledonFile="") { ;-==-=-=-=-=^^^@::@::@^^^
	if !Target_Path 
		return, 0 ;"no file passed" ; else,TT("starting opencon:") } else,
	if (fileExist(Target_Path)) {
		SplitPath,Target_Path,OutFileName   ;,OutDir,OutExtension 
		(!HighlightDisabledonFile? highlight_file := "/select, ") 
		if (FoundhWnd:=isContainingPathopen(Target_Path)) { ; TargetsParentWindow isOpen
			If !(winactive( "ahk_id " %FoundhWnd%))
				 winactivate,ahk_id   %FoundhWnd% 
			try, { 
				ControlGet, cc,selected  , , , ahk_id %FoundhWnd%
				FileSselect(FoundhWnd,OutFileName)
				SendKi("f5")                   ; send,{f5} ;
				return,FoundhWnd
			}
		} else {
			d:=( "cmd.exe /C explorer.exe /select, " . quote(Target_Path))
			tt("Not found in existing windows`nLaunching new Explorer.exe...,",800)
			run,% d,,hide
			try, {
				FileSselect(FoundhWnd:=winexist(),OutFileName) 
				SendKi("f5")
				return,1  ; wingettitle,Title,ahk_id %FoundhWnd%
			} ;; (((OutDir=Title)&&(DllCall("IsWindowVisible","Ptr",FoundhWnd)))?(try,SendKi("f5",""))) ;;
		}
	} else, return,0 ;"Path?";
} 

mousepos(byref X="", byref Y="") {
	VarSetCapacity(POINT,A_ptrsize)
	static POINT 
	dllCall("GetCursorPos","UInt",&POINT,"Ptr")
	X:=numget(POINT,0,"Uint"), Y:=numget(POINT,A_ptrsize *0.5,"Uint")
	return,1 ; test-func not efficient 
}

RUN(CommandStr, onPath="", dontHide="",byref pid="") {
	try,run,% CommandStr,% (onPath?2z:=onPath),% (!dontHide?3z:="Hide"),%pid%
	catch, 
		msgb0x(lasterrOr())	
	if pid  ; (pid ? pid:=quote(pid))
		return,(pid?byref pid:1)
	else 
}

runCMD(CommandStr, onPath="", dontHide="", byref pid="") {
	try,run,% (comspec " /C " CommandStr),% (onPath?2z:=onPath),% (!dontHide?3z:="hide"), %pid% ; remov 
	catch, 
		msgb0x(lasterrOr())	
	return,(pid?byref pid:1) ; (pid ? a:=pid : a:="")
}

lastErrOr() {
	return,(global A_LastError?(RunWait1("C:\Windows\System32\Err_6.4.5.exe " A_LastError))
	: errorlevel?(ret:=errorlevel):(ret:="NoErr"))
}

quote(input){
	return,(chr(34) . input . chr(34))
}

exit() {  ;gui _: +OwnDialogs
	msgbox("Thread","Exiting thr3ad...",2.5, 0x43040, True)
	exit, ;gui _: Destroy
}

_n := "`n"

/* class tt {   ; Like Tts in falling rain...
	 ;;         t  :=   ; This.Timer := ObjBindMethod(this, "Tick")
	 i:=this.tt := this.Tick.Bind(this)
	
	coordMode mouse, screen
	coordMode Pixel, screen
		 
	__New(ttt=1000) {
		this.count := tooltipsA
		this.timeout := ttt
		
		 NUM="")  { ; tooltip function with a default timeout count of 400ms (timeout can be provided as UINT as 2nd param)
(num="")?
  (tooltips="")?(num:=1):(num:=tooltips++)
	TT(TxT="", Ti=0, NUM="")  { ; tooltip function with a default timeout count of 400ms (timeout can be provided as UINT as 2nd param)
(num="")?
  (tooltips="")?(num:=1):(num:=tooltips++)
	tooltip,% TxT,,,% num
	if !ti {
		if !Tcnt
			Tcnt := -400
		settimer, TT_O, % Tcnt
	} else {
		if !(instr(Ti, "-"))
			TI := "-" . TI  ;  negative time ( / onetime timer) by concatenating a prefix "-" 
		settimer, TT_O,% TI
	}
}	 */