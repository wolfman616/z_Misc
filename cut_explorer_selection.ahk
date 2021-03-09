;  MW 2021
#NoEnv
#Singleinstance Force
Return

^#x:: 			; { CTRL START X } ;
This_Path := Selected_Files(), FileToClipboard(This_Path)
Return

Selected_Files() {
	IfWinActive, ahk_class CabinetWClass ; Explorer
	{
		for window in ComObjCreate("Shell.Application").Windows
			if window.HWND = WinExist("A")
				This_window := window
			if(This_window.Document.SelectedItems.Count > 1) {    ; Multiple Items selected
				these_files := ""
				for item in This_window.Document.SelectedItems
				these_files .= item.Path . "`n"
				Return these_files
			} Else Return This_window.Document.FocusedItem.Path
	} Else {
		if(WinActive("ahk_class Progman") || WinActive("ahk_class WorkerW")) {  ;Desktop
			ControlGet, SelectedFiles, List, Selected Col1, SysListView321, A
			if InStr(SelectedFiles, "`n") {		; Multiple Items
				these_files := ""
				Loop, Parse, SelectedFiles, `n, `r
				these_files .= A_Desktop . "\" . A_LoopField . "`n"
				Return these_files
			} Else Return A_Desktop . "\" . SelectedFiles
		} Else Return False
	}
}

FileToClipboard(PathToCopy,Method="Cut") {
	FileCount:=0, PathLength:=0, Offset:=0
	Loop,Parse,PathToCopy,`n,`r
	{
		FileCount++
		PathLength+=StrLen(A_LoopField)
	}
	pid:=DllCall("GetCurrentProcessId","uint")
	hwnd:=WinExist("ahk_pid " . pid)
	; 0x42 = GMEM_MOVEABLE(0x2) | GMEM_ZEROINIT(0x40)
	hPath := DllCall("GlobalAlloc","uint",0x42,"uint",20 + (PathLength + FileCount + 1) * 2,"UPtr")
	pPath := DllCall("GlobalLock","UPtr",hPath)
	NumPut(20,pPath+0),pPath += 16 ; DROPFILES.pFiles = offset of file list
	NumPut(1,pPath+0),pPath += 4 ; fWide = 0 -->ANSI,fWide = 1 -->Unicode
	Loop,Parse,PathToCopy,`n,`r ; Rows are delimited by linefeeds (`r`n).
		offset += StrPut(A_LoopField,pPath+offset,StrLen(A_LoopField)+1,"UTF-16") * 2
	DllCall("GlobalUnlock","UPtr",hPath)
	DllCall("OpenClipboard","UPtr",hwnd)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData","uint",0xF,"UPtr",hPath) ; 0xF = CF_HDROP
		; Write Preferred DropEffect structure to clipboard to switch between copy/cut operations
		; 0x42 = GMEM_MOVEABLE(0x2) | GMEM_ZEROINIT(0x40)
	mem := DllCall("GlobalAlloc","uint",0x42,"uint",4,"UPtr")
	str := DllCall("GlobalLock","UPtr",mem)
	if (Method="copy")
		DllCall("RtlFillMemory","UPtr",str,"uint",1,"UChar",0x05)
	Else if (Method="cut")
		DllCall("RtlFillMemory","UPtr",str,"uint",1,"UChar",0x02)
	Else {
		DllCall("CloseClipboard")
		Return
	}
	DllCall("GlobalUnlock","UPtr",mem)
	cfFormat := DllCall("RegisterClipboardFormat","Str","Preferred DropEffect")
	DllCall("SetClipboardData","uint",cfFormat,"UPtr",mem)
	DllCall("CloseClipboard")
	Return
}

