
isdir(path) {
	return,% (((fileexist(path))="D")?1:0)
}

isContainingPathopen(FullPath) { 
	winget,Flist,List,ahk_Class CabinetWClass
	  if  !Flist
	   return,0
	SplitPath,FullPath,,OutDir
		loop,%Flist%
		{
			id:=Flist%a_index%
			ControlGetText, Txt,ToolbarWindow323,AHK_ID %id%
			p:=( strReplace(Txt,"Address: ") )
			if (p=OutDir)
			{
			
				return,id
			}
		} 
	return,0
}

Filezelect(hwndt, paths) {   ; SelectList := "Windows,Program Files,Documents and Settings"
	;if instr(paths, "\")
	;SplitPath,Paths,FileName   ;,OutDir,OutExtension 

	SelectList:= Paths
	for window in ComObjCreate("Shell.Application").Windows
	{
		if !(window.HWND=hwndt)
			continue
		sfv := window.Document
		items := sfv.Folder.Items
		for item in items
		{
		;msgbox % item.path
		   if (item.path=paths)
		   {
				 sfv.SelectItem(item,true)
				 }
			else,sfv.SelectItem(item,false)
			}
		item  := ""
		items := ""
		sfv   := ""
	}
	window    := ""
	return,1
}

OpenContaining(Target_Path, HighlightDisabledonFile="") { ;-==-=-=-=-=^^^@::@::@^^^
	if !Target_Path 
		return, 0 ; "no file passed" ; else,TT("starting opencon:") } else,
	if (fileExist(Target_Path)) {
		SplitPath,Target_Path,OutFileName,,,filenoext   ;,OutDir,OutExtension 
		(!HighlightDisabledonFile? highlight_file := "/select, ") 
		if (FoundhWnd:=isContainingPathopen(Target_Path)) { 
			If !(winactive( "ahk_id " %FoundhWnd%)) ; TargetsParentWindow isOpen
				 winactivate,ahk_id   %FoundhWnd% 
				try		Filezelect(FoundhWnd,Target_Path)
				try PostMessage,0x0100,0x074,0,DirectUIHWND3,ahk_id %FoundhWnd%     ; if down {
				sleep 50
				try PostMessage,0x0101,0x074,0,DirectUIHWND3,ahk_id %FoundhWnd%     ; if down {
				return,FoundhWnd			
		} else {
			d:=("cmd.exe /C explorer.exe /select, " . quote(Target_Path))
				run,% d,,hide7 ; tt("Not found in existing windows`nLaunching new Explorer.exe...,",800) 
				tt("Opening Container..,",1100) ;winwait,ahk_Class CabinetWClass,,10 
			try,  ; if errOrlevel ; return,0 ; FoundhWnd:=winexist() ;
				Filezelect(FoundhWnd:=winexist(),OutFileName) 
				sleep 20
			try PostMessage,0x0100,0x074,0,DirectUIHWND3,ahk_id %FoundhWnd%     ; if down {
				sleep 50
			try	PostMessage,0x0101,0x074,0,DirectUIHWND3,ahk_id %FoundhWnd%     ; if ;SendKi("f5")
			return,1  ; wingettitle,Title,ahk_id %FoundhWnd%
		} ;; (((OutDir=Title)&&(DllCall("IsWindowVisible","Ptr",FoundhWnd)))?(try,SendKi("f5",""))) ;;
	} else, return,0 ;"Path?";
} 

RUN(CommandStr, onPath="",pid="", dontHide="") {
(!dontHide?3z:="Hide")
	try,run,% CommandStr,% (onPath?2z:=onPath),% (pid_:=pid), %3z%
	catch, 
		msgb0x(lasterrOr())	
	if pid  ; ( pid ? pid:=quote(pid) )
		return,% (pid_?byref pid_:ret:=1)
}

runCMD(CommandStr, onPath="", pid="", dontHide="") {
	try,run,% (comspec " /C " CommandStr),% (onPath?2z:=onPath),% (!dontHide?3z:="hide"), %pid% ; remov 
	catch,
		msgb0x(lasterrOr())
	return,(pid?byref pid:1) ; (pid ? a:=pid : a:="")
}

; OpenContaining(target_uncpath, HighlightDisabledonFile="") { ;-==-=-=-=-=^^^@::@::@^^^
	; if (fileExist(target_uncpath)) {  ; if !OutExtension 
		; SplitPath, target_uncpath, OutFileName, OutDir, OutExtension
		; P:=OutDir ; (isdir(target_uncpath) ? P:=OutDir : P:=FullPath)
		; (!HighlightDisabledonFile ? highlight_file := "/select ") 
		; if (found:=isContainingopen(P)) {
			; winactivate,ahk_id %found% 			; WinWaitActive 
			; Filezelect(found,OutFileName) ; not working
		; }
		; else,run,% comspec " /C explorer.exe " . highlight_file . target_uncpath,, hide
		; e:=eRrOrLeVeL
		; winwait, ahk_Class CabinetWClass
		;;;;found:=winexist() ; not working ; wingettitle,Title,ahk_id %found% ; (((OutDir=Title) && (DllCall("IsWindowVisible", "Ptr",found))) ? (try,SendKi("f5","")))
		; Filezelect(found,OutFileName) 
	; }
	; return,"Path?"
; }

; dir(path) {
	; return,% (((fileexist(path))="D")?1:0)
; }

; isContainingopen(FullPath) { ; check containing folder of target, if target is folder result is the folders parent,
	; winget,Flist,list,ahk_Class CabinetWClass
	  ; if  !Flist
	   ; return,0
	; SplitPath,FullPath,,OutDir
	  ; ( dir(FullPath) ? P:=OutDir : P:=FullPath )
		; loop,%Flist% {
		; id:=( Flist%a_index% )
		; ControlGetText, Txt,ToolbarWindow323,AHK_ID %id% ; explorer crumbs			
		; if(p=strReplace(Txt,"Address: "))					
			; return,id
		; } 
	; return,0
; } 

; Filezelect(hwndt, filenames) {    ; SelectList := "Windows,Program Files,Documents and Settings"
	               ; filenames .= "," ; include delim with every member
	; for Win in ComObjCreate("Shell.Application").Windows
	; {
		; if !(Win.HWND=hwndt)
			; continue ; 2 next iter8 ; else -> target hWnd found
		; sfv  :=Win.Document 
		; items:=sfv.Folder.Items
		; for item in items
		   ; if instr(filenames, (item.Name . ",")) 
				      ; sfv.SelectItem(item,true)
				; else,  sfv.SelectItem(item,false) ;return,1
		; return,0 ; item:=items:=sfv:="" 
; }	}    