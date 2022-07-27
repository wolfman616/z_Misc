#Persistent
#NoEnv
#notrayicon
SetKeyDelay, -1, -1
SetWorkingDir %A_ScriptDir%	
#SingleInstance Off ; This same script is launched multiple times
#UseHook Off
#Include    <LogonDesktop> 
#Include *i <RegisterSyncCallback> ; Used by TermWait for a thread-safe RegisterCallback.
#Include *i <TermWait> ; Used to implement diewithParent.
global h, z 
clientSwitch    :=   " /userPipeName:"
pipeprefix      :=   "AHK_LogonMediaKeys_" ; + sessionId
C_Ahk	        :=   "ahk_class AutoHotkey"
WMPMATT 	    :=   ("wmp_Matt.ahk " . C_Ahk)
YTScript 	    :=	 ("YT.ahk " .       C_Ahk)
z			    :=   77.01298591796062
h               :=   z*z
diewithParent   :=   True ; quick-n-dirty way to have all children exit when the session 0 script gets stopped
parentHndprefix :=   " /parentHandle:"
w_logSessionIDs :=   [] ; Used by the session 0 instance of this script to store the child sessions another instance of itself is running in
wm_allow()
ReadIni()
main() 
return,

main() {
	if (!A_IsUnicode)	; LogonDesktop assumes a Unicode build of AutoHotkey throughout. Sorry.
		ExitApp 1
	DllCall("SetErrorMode", "UInt", DllCall("GetErrorMode", "UInt") | 0x0002, "UInt") ; AND SEM_NOGPFAULTERRORBOX to stop Windows from throwing up WER dialog boxes in case of error

	OnExit("AtExit")

	global diewithParent, parentHndprefix
	if (diewithParent) {
		fnTermWait_WaitForProcTerm := Func("TermWait_WaitForProcTerm")
		if (!fnTermWait_WaitForProcTerm) {
			diewithParent := False ; No point in enabling if the function to wait on a process's termination isn't there...
		} else {
			global hDupProc
			if (!DllCall("DuplicateHandle", "Ptr", LogonDesktop_GetCurrentProcess(), "Ptr", LogonDesktop_GetCurrentProcess(), "Ptr", LogonDesktop_GetCurrentProcess(), "Ptr*", hDupProc, "UInt", 0x00100000, "Int", True, "UInt", 0)) ; Duplicate the psuedo handle returned by GetCurrentProcess() to obtain a real handle for this process and mark it as inheritable
				diewithParent := False
			cmdLine := DllCall("GetCommandLineW", "WStr")
			if (InStr(cmdLine, parentHndprefix)) { ; if there was a handle passed to this process, enable watching for its termination now.
				MSGID := 0x8500
				OnMessage(MSGID, "AHK_TERMNOTIFY")
				fnTermWait_WaitForProcTerm.Call(A_ScriptHwnd, MSGID, StrSplit(cmdLine, parentHndprefix, " """"")[2],,, True)
	}	}	}

	if (LogonDesktop_IsScriptProcessSYSTEM()) {
		global scriptSessionId
		if (!LogonDesktop_ProcessIdToSessionId(LogonDesktop_GetCurrentProcessId(), scriptSessionId))
			ExitApp 1
		DllCall("SetProcessShutdownParameters", "UInt", 0, "UInt", 0) ; Make us one of the last things to shutdown - done so that my accent colour is retained...
		if (scriptSessionId == 0)
			 HandleSessionZeroScriptInitialisation()
		else HandleSessionsWinlogonDesktopInitialisation()
	} else   HandleUserDefaultDesktopInstance()
}

AHK_TERMNOTIFY(wParam, lParam) { ; Simply put: die if our parent process dies and diewithParent is enabled
	Func("TermWait_StopWaiting").Call(lParam)
	ExitApp
}

AtExit() {
	Critical 1000
	global wtsHandle, hDupProc, watchForColourChange, SaveSetColoursFunc
	OnExit(A_ThisFunc, 0)
	if (watchForColourChange) {
		watchForColourChange := False
		PostMessage, 0x0000,,,, ahk_id %A_ScriptHwnd% ; WM_NULL
		SetTimer, SetupColourChange, Off
		SaveSetColoursFunc.Call(True, False)
	}
	if (wtsHandle) {
		if (OnMessage(0x2B1, ""))
			DllCall("wtsapi32.dll\WTSUnRegisterSessionNotification", "Ptr", A_ScriptHwnd)
		LogonDesktop_UnloadWtsApi(wtsHandle), wtsHandle := 0
	}
	if (hDupProc)
		LogonDesktop_CloseHandle(hDupProc), hDupProc := 0
	Critical Off
	return 0
}
HandleSessionZeroScriptInitialisation(){ ; --- functions used when script running as LocalSystem; Here we perform the initialisation needed when this script is the first instance of itself, running in the services session --
	global wtsHandle ;	if (LogonDesktop_AllUsersCanWriteToThisScript()) ;		OutputDebug % A_ScriptName . ": [LogonDesktop] WARNING: it's seemingly possible for Everyone and/or all Users to modify this script"
	if (!LogonDesktop_WaitForTermSrvInit()) ; Probably redundant since Task Scheduler starts this script so late, and probably checks itself...
		ExitApp 1
	if (!(wtsHandle := LogonDesktop_LoadWtsApi()))	; wtsapi32.dll isn't loaded by default. For the notifications to actually work, we must load it ourselves
		ExitApp 1
	EnumerateSessionsAndLaunchWinlogonClient()	; In session zero, watch for new sessions and launch the Winlogon instances of this script in each newly-created session
	if (DllCall("wtsapi32.dll\WTSRegisterSessionNotification", "Ptr", A_ScriptHwnd, "UInt", 1)) ; NOTIFY_FOR_ALL_SESSIONS
		OnMessage(0x2B1, "WM_WTSSESSION_CHANGE")
}

HandleSessionsWinlogonDesktopInitialisation() { ;  script is running on the Winlogon desktop of a non-service session, then:
	if ((!LogonDesktop_GetThreadDesktopName(desktopName)) || desktopName != "Winlogon")
		ExitApp 1
	Process, Priority,, A	; Raise the process's priority, As we're on the Winlogon desktop, where the logon/lock screen actually displays itself, let's now register the hotkeys. 
	; Done here because including them in the normal AHK way would mean that they're registered in the services session and on the Default desktop of a user's session...
	for _, key in ["Volume_Mute", "Volume_Up", "Volume_Down", "^PrintScreen", "#e","#r","#!Del", "<^>!PgDn"]
		Hotkey, %key%, _HKEYS_LogonSide, UseErrorLevel On
	for _, key in ["Media_Prev", "Media_Next", "Media_Play_Pause", "<^>!Space", "<^>!Del", "<^>!Right", "<^>!Left", "^Enter"]
		Hotkey, %key%, _HKEYS_UserSide,  UseErrorLevel On
	if (true) {	; ignore. this section is for my personal tasks
		if (IsFunc("SaveSetColours")) {
			if (!SetupColourChange()) { ; if we're not started when logged on, this will fail - as expected. Can't get logon token of a user that's not logged on...
				global wtsHandle := LogonDesktop_LoadWtsApi() ; so monitor for logons ourselves if needed
				if (wtsHandle && DllCall("wtsapi32.dll\WTSRegisterSessionNotification", "Ptr", A_ScriptHwnd, "UInt", NOTIFY_FOR_THIS_SESSION := 0))
					OnMessage(0x2B1, "WM_WTSSESSION_CHANGE")
}	}	}	}

WM_WTSSESSION_CHANGE(wParam, lParam) {
	Critical
	global w_logSessionIDs, scriptSessionId, watchForColourChange
	if (scriptSessionId == 0) {
		if (wParam == 6) ; user logged out. Typically speaking, this means the session will be deleted
			w_logSessionIDs.Delete(lParam)
		else if (wParam == 1) ; WTS_CONSOLE_CONNECT - new sessions are created just to show a logon window on them, which is why WTS_SESSION_LOGON doesn't work
			SetTimer, EnumerateSessionsAndLaunchWinlogonClient, -1000
	} else {
		if (wParam == 5) { 
			LaunchUserPipeServerInSameSessionAsWinlogonScript()
			if (!watchForColourChange)
				SetTimer, SetupColourChange, -1000 ; now try again to set the colour settings
	}	}
	Critical Off
}

EnumerateSessionsAndLaunchWinlogonClient() { ; This function's aim is to go through all the present sessions, seeing which ones do not have a Winlogon instance of this script running on them
	global w_logSessionIDs, diewithParent, parentHndprefix, hDupProc
	static cbWTS_SESSION_INFO_1 := A_PtrSize == 8 ? 56 : 32, WTSEnumerateSessionsExW, WTSFreeMemoryExW := 0, cmdLine := 0
	
	if (!WTSFreeMemoryExW) {
		global wtsHandle
		WTSFreeMemoryExW        := DllCall("GetProcAddress", "Ptr", wtsHandle, "AStr", "WTSFreeMemoryExW",        "Ptr")
		WTSEnumerateSessionsExW := DllCall("GetProcAddress", "Ptr", wtsHandle, "AStr", "WTSEnumerateSessionsExW", "Ptr")
	}
	if (!cmdLine) {
		cmdLine := DllCall("GetCommandLineW", "WStr")
		for _, switch in [" /force", " /restart"] {
			if (!InStr(cmdLine, switch))
				cmdLine   .=    switch
		}
		if (diewithParent) {
			if (!InStr(cmdLine, parentHndprefix))
				cmdLine   .=    parentHndprefix . hDupProc
	}	}
	if (DllCall(WTSEnumerateSessionsExW, "Ptr", 0, "UInt*", 1, "UInt", 0, "Ptr*", pSessionInfo, "UInt*", wtsSessionCount)) { ; WTS_CURRENT_SERVER_HANDLE ; WTS_CONNECTSTATE_CLASS := {0: "WTSActive", 1: "WTSConnected", 2: "WTSConnectQuery", 3: "WTSShadow", 4: "WTSDisconnected", 5: "WTSIdle", 6: "WTSListen", 7: "WTSReset", 8: "WTSDown", 9: "WTSInit"}
		Loop % wtsSessionCount {
			currSessOffset := cbWTS_SESSION_INFO_1 * (A_Index - 1) ;, ExecEnvId := NumGet(pSessionInfo+0, currSessOffset, "UInt")
			currSessOffset += 4, State     := NumGet(pSessionInfo+0, currSessOffset, "UInt")
			currSessOffset += 4, SessionId := NumGet(pSessionInfo+0, currSessOffset, "UInt")
			if (SessionId) {
				if (State  == 0 || State == 1) { ; active / connected
					; check to see if we already launched a Winlogon instance in that session
					foundSessionId := False
					for _, s in w_logSessionIDs {
						if (s == sessionId)     {
							foundSessionId := True
							break
					}	}
					if (!foundSessionId)        {
						if (LogonDesktop_LaunchOnWinlogonDesktop(cmdLine, sessionId,, diewithParent))
							w_logSessionIDs.Push(sessionId)
		}	}	}	}
		DllCall(WTSFreeMemoryExW, "UInt", 2, "Ptr", pSessionInfo, "UInt", wtsSessionCount) ; WTSTypeSessionInfoLevel1
	}
}

SetupColourChange() {
	;global SaveSetColoursFunc := Func("SaveSetColours"), watchForColourChange
	ret := False
	;if (SaveSetColoursFunc) { ; does SaveSetColours() exist? Great, get a function object pointing to it
		;if (GetColourSettingsForLoggedOnUser()) { ; did we get the profile colours of the logged in user? great:
			ret := watchForColourChange := True
			while (watchForColourChange) {
				if (LogonDesktop_WaitForDesktopSwitchSync() && _OnWinLogonDesktop()) ; now the script waits for the desktop to be switched back to WinSta0\Winlogon
					Loop 3
						SaveSetColoursFunc.Call(True, False) ; and if so, set our retained colours
	}	;}	;}
	return ret
}

SetupColourChange:
SetSysColors()
SetTimer, SetupColourChange, Off
return,

GetColourSettingsForLoggedOnUser() {
	global scriptSessionId, SaveSetColoursFunc
	ret := False
	if (IsObject(SaveSetColoursFunc) && IsFunc(SaveSetColoursFunc)) {
		if (LogonDesktop_AdjustThisProcessPrivileges({"SeTcbPrivilege": True, "SeImpersonatePrivilege": True}, PreviousState)) {
			Critical 1000 ; don't allow this to be interrupted
			; wait until Explorer signals Winlogon's event to tell it to switch to the desktop
			if ((ShellDesktopSwitchEvent := DllCall("OpenEventW", "UInt", 0x00100000, "Int", False, "WStr", "ShellDesktopSwitchEvent", "Ptr"))) { ; SYNCHRONIZE
				DllCall("WaitForSingleObject", "Ptr", ShellDesktopSwitchEvent, "UInt", -1)
				LogonDesktop_CloseHandle(ShellDesktopSwitchEvent)
			}
			Loop 120 {
				DllCall("Sleep", "UInt", 500) ; wait before trying again
				if (LogonDesktop_WTSEnumerateProcessesEx(sessionProcesses,, scriptSessionId)) ; get only processes in our session
					for _, proc in sessionProcesses
						if (proc.ProcessName = "explorer.exe")
							break 2
			}
			DllCall("Sleep", "UInt", 1750)
			if (DllCall("advapi32\RegDisablePredefinedCache") == 0) { ; force WinAPI registry functions to read HKEY_CURRENT_USER of the user by default,
				if (LogonDesktop_WTSQueryUserToken(scriptSessionId, hToken)) {
					if (DllCall("advapi32\ImpersonateLoggedOnUser", "Ptr", hToken)) { ; make this thread impersonate as the logged on user
						SaveSetColoursFunc.Call() ; get the user colour settings  
						ret := True
						if (!DllCall("advapi32\RevertToSelf")) ; go back to being SYSTEM
							DllCall("TerminateProcess", "Ptr", LogonDesktop_GetCurrentProcess(), "UInt", 1) ; if that fails, bail
					}
					LogonDesktop_CloseHandle(hToken)
			}	}
			LogonDesktop_AdjustThisProcessPrivileges(0, PreviousState)
			Critical Off
	}	}
	return ret
}

_HKEYS_UserSide() { ; handles when the keys are pressed in the Winlogon script instance
	static pipe_name := 0, CreateFileW := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandleW", "WStr", "kernel32.dll", "Ptr"), "AStr", "CreateFileW", "Ptr"), WaitNamedPipe := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandleW", "WStr", "kernel32.dll", "Ptr"), "AStr", "WaitNamedPipeW", "Ptr")
	if (!pipe_name) {
		global pipeprefix, scriptSessionId
		pipe_name := "\\.\pipe\" . pipeprefix . scriptSessionId
	}	; wait to see if the pipe  exists
	if (!DllCall(WaitNamedPipe, "WStr", pipe_name, "uint", 1000)) {
		if (A_LastError != 2) ; ERROR_FILE_NOT_FOUND
			return		; if not, launch the pipe server on the user's desktop
		Critical 		; don't allow this function to try starting the server as many times as a media key is pressed
		LaunchUserPipeServerInSameSessionAsWinlogonScript()
		DllCall("Sleep", "UInt", 250)
		Critical Off
	}	; open handle to named pipe. Use CreateFile because it allows us to prevent the pipe server from impersonating us when we connect
	hPipe := DllCall(CreateFileW, "WStr", pipe_name, "UInt", 0x40000000, "UInt", 0, "Ptr", 0, "UInt", 3, "UInt", 0x00100000, "Ptr", 0, "Ptr") ; GENERIC_WRITE, OPEN_EXISTING, SECURITY_SQOS_PRESENT | SECURITY_ANONYMOUS(0)
	if (hPipe != -1) { ; INVALID_HANDLE_VALUE
		if ((media_pipe := FileOpen(hPipe, "h", "UTF-16-RAW")))
			media_pipe.Write(A_ThisHotkey), media_pipe := ""
		LogonDesktop_CloseHandle(hPipe)
}	} ; this is easier. As long as we're in the same session, Windows Audio can be controlled normally regardless of the current desktop

_HKEYS_LogonSide() {
	switch A_ThisHotkey {
		case "Volume_Mute","<^>!PgDn":
			SoundSet +1,, Mute	
		case  "Volume_Down":
			SoundSet -2
		case "Volume_Up":
			SoundSet +2
		case "^PrintScreen":
			send % h
		case "#e":
			run,% "C:\Script\AHK\- Script\syscolors.ahk"
			run,% "explorer shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
		case "#r":
			run, regedit.exe
		case "#!Del":	
			run, C:\Apps\Ph\processhacker\x64\Pr0c355_h4X4r.exe
}	}

LaunchUserPipeServerInSameSessionAsWinlogonScript() {
	ret := False
	global clientSwitch, pipeprefix, scriptSessionId, diewithParent, parentHndprefix, hDupProc
	pipe_name := pipeprefix . scriptSessionId
	if (LogonDesktop_AdjustThisProcessPrivileges({"SeTcbPrivilege": True, "SeImpersonatePrivilege": True, "SeAssignPrimaryTokenPrivilege": True, "SeIncreaseQuotaPrivilege": True}, PreviousState)) { ; usually enabled by default when SYSTEM, but just in case...
		if (LogonDesktop_WTSQueryUserToken(scriptSessionId, hToken)) { ; get token for the user in the same session the Winlogon script is running on
			if (LogonDesktop_DuplicateTokenEx(hToken, 0x02000000, 0, 1, 1, hUserToken)) { ; Duplicate it to get a token we can use with CreateProcess. MAXIMUM_ALLOWED, SecurityIdentification, TokenPrimary ; I don't want to run the pipe server elevated, but if Spotify for whatever reason is, run with the uiAccess attribute set to ensure there's no problems
				LogonDesktop_SetUiAccessToken(hUserToken, LogonDesktop_DoesTokenContainAdminGroupDirectlyOrNot(hToken, True)) ; need to know if the user logged on is an admin to set the right higher integrity level
				extra := diewithParent ? parentHndprefix . hDupProc : ""
				ret := LogonDesktop_EasyCreateProcessUsingToken(hUserToken, """" . A_AhkPath . """" . " /force /restart " . """" . A_ScriptFullPath . """" . clientSwitch . pipe_name . extra, "WinSta0\Default", True, diewithParent)
				LogonDesktop_CloseHandle(hUserToken)
			}
			LogonDesktop_CloseHandle(hToken)
		}
		LogonDesktop_AdjustThisProcessPrivileges(0, PreviousState)
	}
	return ret
}

; --- These functions are used in pipe server mode, running on the user's Default desktop
HandleUserDefaultDesktopInstance() {
	global clientSwitch, hDupProc
	cmdLine := DllCall("GetCommandLineW", "WStr")
	if (InStr(cmdLine, clientSwitch)) { ; if the name of the pipe to create is specified on the command line (which it will be when started by the Winlogon instance)
		if (hDupProc)
			LogonDesktop_CloseHandle(hDupProc), hDupProc := 0 ; we don't spawn any further scripts from the pipe server instance
		pipe_name := StrSplit(cmdLine, clientSwitch, " """"")[2]
		if ((spaceChrPos := InStr(pipe_name, " "))) ; the quick-and-dirty C way of replacing a character
			NumPut(0, pipe_name, (spaceChrPos - 1) * 2, "UShort"), VarSetCapacity(pipe_name, -1)
		RunPipeServer(pipe_name)
	} else {                   ; Assume this script was started by double-clicking it by the user
		if (A_IsAdmin) {       ; if we are elevated
			if (LogonDesktop_PossiblyDetermineIfUnelevatedUserCanWriteToScript())
				OutputDebug % A_ScriptName . ": [LogonDesktop] WARNING: unelevated you has the right to edit this script. Consider fixing that."
			LogonDesktop_AddTask(True, True) ; run on startup and start session zero instance of this script now
		} else Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%",, UseErrorLevel ; ask for elevation and run ^
	}
	ExitApp
}

RunPipeServer(pipe_name) {      ; we create this named pipe because SetThreadDesktop isn't really possible in AutoHotkey,
	if (!pipe_name || FileExist("\\.\pipe\" . pipe_name)) ; if there is no pipe to create, or if it already exists (another pipe server script running?), then exit
		ExitApp 1
	lpSECURITY_ATTRIBUTES := 0	; default DACL on the pipe allows for all users to send messages to the pipe. Use a subset of the default rules: only SYSTEM and the user who created the pipe has full control; the rest are denied any access to it
	if (LogonDesktop_OpenProcessToken(LogonDesktop_GetCurrentProcess(), TOKEN_QUERY := 0x0008, hToken)) {
		if (LogonDesktop_GetTokenUser(hToken, TOKEN_USER)) { ; get SID of user who created this process
			if (DllCall("advapi32.dll\ConvertSidToStringSidW", "Ptr", NumGet(TOKEN_USER,, "Ptr"), "Ptr*", StringSid)) { ; and convert it to string form
				VarSetCapacity(SECURITY_ATTRIBUTES, (saCb := A_PtrSize == 8 ? 24 : 12), 0), NumPut(saCb, SECURITY_ATTRIBUTES,, "UInt")
				; get SD from SDDL string (given the amount of struct manipulations I'd have to do to do this in pure WinAPI, I'll stick with SDDL in AutoHotkey, TYVM)
				if (DllCall("advapi32.dll\ConvertStringSecurityDescriptorToSecurityDescriptorW", "WStr", Format("D:(A;;0x1fffff;;;{:s})(A;;0x1fffff;;;SY)", StrGet(StringSid,, "UTF-16")), "UInt", 1, "Ptr", &SECURITY_ATTRIBUTES+A_PtrSize, "Ptr", 0)) ; SDDL_REVISION_1
					lpSECURITY_ATTRIBUTES := &SECURITY_ATTRIBUTES
				; purposely don't free the SD memory allocated by ConvertStringSecurityDescriptorToSecurityDescriptor - doing so causes a crash 90% of the time, and we won't leak because this is only called once anyway
				DllCall("LocalFree", "Ptr", StringSid, "Ptr")
		}	}
		LogonDesktop_CloseHandle(hToken)
	}
	hpipe := CreateNamedPipe(pipe_name, 0x00000001 | 0x40000000,, 1, lpSECURITY_ATTRIBUTES)  ; PIPE_ACCESS_INBOUND | FILE_FLAG_OVERLAPPED, PIPE_TYPE_BYTE
	if (hpipe == -1) ; INVALID_HANDLE_VALUE
		ExitApp 1
	pipe := FileOpen(hpipe, "h", "UTF-16-RAW")
	DisconnectNamedPipe := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandleW", "WStr", "kernel32.dll", "Ptr"), "AStr", "DisconnectNamedPipe", "Ptr")							 
	while (ConnectNamedPipe(hpipe)) {	 ; Wait for a connection.; Read the message incrementally (if it is long).
		message := ""
		while (data := pipe.Read(4096))
			message .= data
		switch message { ; Process the message.
			case "Media_Next":
				PostMessage, 0x319,, 0xB0000,, ahk_class SpotifyMainWindow
			case "Media_Prev":
				PostMessage, 0x319,, 0xC0000,, ahk_class SpotifyMainWindow
			case "Media_Play_Pause":
				PostMessage, 0x319,, 0xE0000,, ahk_class SpotifyMainWindow
			case "<^>!Space":
				result := Send_WM_COPYDATA("PauseToggle", WMPMATT)
			case "<^>!Left":
				result := Send_WM_COPYDATA("JumpPrev",    WMPMATT)
			case "<^>!Right":
				result := Send_WM_COPYDATA("JumpNext",    WMPMATT)
			case "<^>!Del":
				result := Send_WM_COPYDATA("DelCurrent",  WMPMATT)
			case"<^>!PgDn":	
				result := Send_WM_COPYDATA("MuteAll",     WMPMATT)
			case "+^#Space":
				result := Send_WM_COPYDATA("PlayPause",   YTScript)
}
		DllCall(DisconnectNamedPipe, "Ptr", hpipe)		; Disconnect so that we can accept another connection.
	}
	pipe := ""
	LogonDesktop_CloseHandle(hpipe)
}

CreateNamedPipe(Name, OpenMode=3, PipeMode=0, MaxInstances=255, lpSecurityAttributes := 0) {
	return DllCall("CreateNamedPipe","str","\\.\pipe\" Name,"uint",OpenMode
		,"uint",PipeMode,"uint",MaxInstances,"uint",0,"uint",0,"uint",0,"ptr",lpSecurityAttributes,"ptr")
}

ConnectNamedPipe(hNamedPipe) {
	static ConnectNamedPipe := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandleW", "WStr", "kernel32.dll", "Ptr"), "AStr", "ConnectNamedPipe", "Ptr")
		  ,GetOverlappedResult := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandleW", "WStr", "kernel32.dll", "Ptr"), "AStr", "GetOverlappedResult", "Ptr")
		  ,MsgWaitForMultipleObjectsEx := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandleW", "WStr", "user32.dll", "Ptr"), "AStr", "MsgWaitForMultipleObjectsEx", "Ptr")
		  ,hEvent := DllCall("CreateEvent", "ptr", 0, "int", true, "int", false, "ptr", 0, "ptr"), overlapped
	if (!VarSetCapacity(overlapped)) {
		VarSetCapacity( overlapped, 32, 0)
		NumPut(hEvent,  overlapped, 2*A_PtrSize+8, "Ptr")
	}
	if (!DllCall(ConnectNamedPipe, "ptr", hNamedPipe, "ptr", &overlapped) && A_LastError == 997) {	; ERROR_IO_PENDING
		loop {					; Wait for the event to be signaled or any window message received.
			r := DllCall(MsgWaitForMultipleObjectsEx, "uint", 1, "ptr*", hEvent, "uint", -1, "uint", 0x4FF, "uint", 0x6)
			Sleep -1 			; Allow AutoHotkey to dispatch messages.
		} until r=0 or r=-1  	; WAIT_OBJECT_0 or WAIT_FAILED
	}
	return (r := DllCall(GetOverlappedResult, "ptr", hNamedPipe, "ptr", &overlapped, "uint*", 0, "int", true))
}

SetSysColors() {
	Local s, s1, s2, c
	colors=
	(
		ButtonText=18
		ButtonFace=15
		ButtonAlternateFace=25
		ButtonLight=22
		ButtonHilight=20
		ButtonShadow=16
		ButtonDkShadow=21
		ActiveBorder=10
		ActiveTitle=2
		GradientActiveTitle=27
		TitleText=9
		Background=1
		GrayText=17
		Hilight=13
		HilightText=14
		HotTrackingColor=26
		InactiveBorder=11
		InactiveTitle=3
		GradientInactiveTitle=28
		InactiveTitleText=19
		InfoWindow=24
		InfoText=23
		Menu=4
		MenuHilight=29
		MenuBar=30
		MenuText=7
		Scrollbar=0
		AppWorkSpace=12
		Window=5
		WindowFrame=6
		WindowText=8
	)
	Loop, Parse, colors, `n
	{
		RegExMatch( A_LoopField, "([0-9a-zA-Z]+)=([0-9]+)", s )
		c  := s1
		s1 := "Color" . s1
		s1 := %s1%
		if StrLen(s1) {
			DllCall("SetSysColors", "Int", 1, "Int*", s2, "UInt*", s1)
			s  := s1 & 0xFF
			s1 := s1 >> 8
			s2 := s1 & 0xFF
			s1 := s1 >> 8
			if ColorRegUpdate
				RegWrite, REG_SZ, HKEY_CURRENT_USER, Control Panel\Colors, %c%, %s% %s2% %s1%
	}	}
	colors := 0
}

ReadIni( filename = 0 ) { ; Read file and create vars like: ; %Section%%Key% = %value%
Local s, sep, key, line, val, val1, val2
if not filename
	filename := SubStr( A_ScriptName, 1, -3 ) . "ini"
	FileRead, s, %filename%
	sep := chr(129)
	s := RegExReplace( s, "m)^\[([a-zA-Z0-9_]+\])\s*$", sep . "$1" ) . "`n"
	Loop, Parse, s, %sep%
	{
		RegExMatch( A_LoopField, "^([a-zA-Z0-9_]+)", key )
		line :=( RegExReplace( A_LoopField, key . "\]\s*", "" ) )
		Loop, Parse, line, `n
		{
			RegExMatch( A_LoopField, "^\s*([a-zA-Z0-9_]+)\s*=(.+)\s$", val )
			If val1
			%key%%val1% :=val2
}	}	}

Send_WM_COPYDATA(ByRef STR_, ByRef TargetScript) {
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
	SizeInBytes := (StrLen(STR_)+1)*(A_IsUnicode ? 2:1)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
	NumPut(&STR_, CopyDataStruct, 2*A_PtrSize)
	Prev_DetectHiddenWindows := A_DetectHiddenWindows
	Prev_TitleMatchMode := A_TitleMatchMode
	DetectHiddenWindows On
	SetTitleMatchMode 2
	TimeOutTime := 4000
	SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScript%,,,, %TimeOutTime%
	DetectHiddenWindows %Prev_DetectHiddenWindows%
	SetTitleMatchMode %Prev_TitleMatchMode%
	return, errorlevel
}
