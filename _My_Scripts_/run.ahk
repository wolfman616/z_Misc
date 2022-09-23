Run(CommandStr, onPath="", dontHide="",byref ppid="") {
	(!dontHide?3z:="Hide")
	run,% CommandStr,% (onPath?2z:=onPath), ppid, %3z%
	;ppid? pid:= ppid)	 ; ( pid ? pid:=quote(pid) )
	return,byref ppid
}

; RUN(CommandStr, onPath="", dontHide="",byref pid="") {
	; run,% CommandStr,% (onPath?2z:=onPath),% (!dontHide?3z:="Hide"),ppid
	;;catch, 
		;;msgb0x(lasterrOr())	
	 ; if ppid  ; ( pid ? pid:=quote(pid) )
	 ; pid:=ppid	
	; return, byref pid
; }

; runCMD(CommandStr, onPath="", dontHide="", byref pid="") {
	; try,run,% (comspec " /C " CommandStr),% (onPath?2z:=onPath),% (!dontHide?3z:="hide"), %pid% ; remov 
	; catch,
		; msgb0x(lasterrOr())
	; return,(pid?byref pid:1) ; (pid ? a:=pid : a:="")
; }