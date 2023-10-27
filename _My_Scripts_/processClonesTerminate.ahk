;Singleton library funcs

processClonesTerminate(hwnd="") { ;call without argument to destroy this processes clones
	local
	targetPid:= (hwnd="")? DllCall("GetCurrentProcessId") :	PidFromHwnd(hwnd)
	if(procs:= ProcessClonesDetect(targetPid))
		for,i in procs
			if(procs[i].pid!=targetPid){
				if(procs[i].pid)
					process,close,% procs[i].pid
			}
}

ProcessClonesDetect(hwnd="") { ; accepts hWnd or PID or leave blank to check own process
	local
	static pid_
	global oldMatchMode, oldMatchSpeed, oldDetectTxt, oldDetectWin

	(id="")? pid_:= DllCall("GetCurrentProcessId") : !winexist("ahk_pid " hwnd)? winexist("ahk_id " hwnd)?	pid_:= PidFromHwnd(hwnd) : () : ()

	object1:= {}

	DetectHiddenChk()
	loop,% count:= (object1:= HWNDlistGet(A_ScriptName . " - AutoHotkey ahk_class AutoHotkey")).count {
		winget,the_pid,pid,% "ahk_id " object1[a_index]
		(the_pid!=pid_? found_clone:= True)
	}	DetectHiddenRestore()

	return,% object1
}

DetectHiddenChk() { ;modify detection settings if needed
	global oldMatchMode, oldMatchSpeed, oldDetectTxt, oldDetectWin
	if(A_DetectHiddenWindows= "off"){
		oldDetectWin:= "off"
		DetectHiddenWindows,On
	}	if(A_DetectHiddenText= "off") {
		oldDetectTxt:= "off"
		DetectHiddenText,On
	} if(A_TitleMatchMode!=2){
		oldMatchMode:= A_TitleMatchMode
		SetTitleMatchMode,2
	} if(A_TitleMatchModeSpeed!="slow"){
		oldMatchSpeed:= A_TitleMatchModeSpeed
		SetTitleMatchMode,Slow
	}	return,byref oldMatchMode,byref oldMatchSpeed,byref oldDetectTxt,byref oldDetectWin
}

DetectHiddenRestore() { ;reset any modified detection settings
	global
	if(oldMatchMode)
		SetTitleMatchMode,% oldMatchMode
	if(oldMatchSpeed)
		SetTitleMatchMode,% oldMatchSpeed
	if(oldDetectWin)
		DetectHiddenWindows,off
	if(oldDetectTxt)
		DetectHiddenText,off
}

PidFromHwnd(hwnd=""){
	local
	winget,pid,pid,ahk_id %hwnd%
	return,pid
}