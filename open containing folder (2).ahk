#NoEnv ; ISSUES WITH OPENING ELELVATED? FOLDERS
; detecthiddenwindows on
; #persistent
File=%1%
o:=comobjcreate("Shell.Application")
splitpath,file,file,directory,ext
if !errorlevel {
	od:=o.namespace(directory)
	of:=od.parsename(file)
	if containing_loc:=od.getdetailsof(of,203) { ;202 - Link status: Unresolved
		;splitpath containing_loc, inFileName, inDir, inExtension, inNameNoExt, inDrive
		;Run explorer.exe /select`, "%containing_loc%", HIDE
		;die=explorer.exe "%1%" select`
		TargetScriptTitle := "event_object_create hook.ahk ahk_class AutoHotkey"
		StringToSend=%containing_loc%
		result := Send_WM_COPYDATA(StringToSend, TargetScriptTitle)
		if (result = "FAIL")
			MsgBox SendMessage failed. Does the following WinTitle exist?:`n%TargetScriptTitle%
		else if (result = 0)
			MsgBox Message sent but the target window responded with 0, which may mean it ignored it.
		return

		Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle)  ; ByRef saves a little memory in this case.
		; This function sends the specified string to the specified window and returns the reply.
		; The reply is 1 if the target window processed the message, or 0 if it ignored it.
		{
			VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
			; First set the structure's cbData member to the size of the string, including its zero terminator:
			SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
			NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
			NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
			Prev_DetectHiddenWindows := A_DetectHiddenWindows
			Prev_TitleMatchMode := A_TitleMatchMode
			DetectHiddenWindows On
			SetTitleMatchMode 2
			TimeOutTime := 4000  ; Optional. Milliseconds to wait for response from receiver.ahk. Default is 5000
			; Must use SendMessage not PostMessage.
			SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%,,,, %TimeOutTime% ; 0x4a is WM_COPYDATA.
			DetectHiddenWindows %Prev_DetectHiddenWindows%  ; Restore original setting for the caller.
			SetTitleMatchMode %Prev_TitleMatchMode%         ; Same.
			return ErrorLevel  ; Return SendMessage's reply back to our caller.
		}
		;Runwait %die%,, , handle
		;sleep 1800
		;send {f5}
		;wingettitle, turd, "ahk_pid" handle
		;msgbox % turd
	} else {
tooltip dhdhdhd
		;Runwait %die%,, , handle
		;wingettitle, turd, "ahk_pid" handle
		;sleep 1800
		;send {f5}
		;msgbox % turd
		Run %COMSPEC% /c explorer.exe /select`, "%1%",, Hide

	}
} else Exit
