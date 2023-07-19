;#noenv
;#persistent

;loop,80 {
;	tooltip,% "Press escape to terminate..."
;	sleep,40
;} settimer,MouseFileTip,40
;return,

;~esc::exitapp

;MouseFileTip:
;tooltip,% (t:=FileUnderMouse())? t : "No File detected"
;return,

FileUnderMouse() {
	static Windows:= ComObjCreate("Shell.Application").Windows

	MouseGetPos,,,hwnd,CtrlClass
	WinGetClass,WinClass,ahk_id %hwnd%

	try,if(WinClass="CabinetWClass" && CtrlClass="DirectUIHWND3") {
		oAcc:= Acc_ObjectFromPoint()
		Name:= Acc_Parent(oAcc).accValue(0)
		NonNull(Name,oAcc.accValue(0))

		if(Name="")
			return,

		for,window in Windows
			if(window.hwnd=hwnd) {
				FolderPath:= RegExReplace(window.Document.Folder.Self.Path,"(\w+?\:)\\$","$1") ; “d:\” 转换为 “d:”
				return, FolderPath "\" Name
			}
	} else,if(WinClass="Progman" || WinClass="WorkerW") {
		oAcc:= Acc_ObjectFromPoint(ChildID)
		Name:= ChildID? oAcc.accName(ChildID) : ""

		if(Name="")
			return,

		SplitPath,Name,,,OutExtension,OutNameNoExt
		return,A_Desktop "\" Name
	}
}

Acc_Init() {
	Static h
	return,(!h? h:= DllCall("LoadLibrary","Str","oleacc","Ptr"))
}

Acc_ObjectFromPoint(ByRef _idChild_ = "", x = "", y = "") {
	Acc_Init()
	If(DllCall("oleacc\AccessibleObjectFromPoint","Int64",x==""||y==""? 0*DllCall("GetCursorPos","Int64*",pt) +pt:x&0xFFFFFFFF|y<<32,"Ptr*",pacc,"Ptr",VarSetCapacity(varChild,8 +2*A_PtrSize,0)*0+&varChild)=0)
	Return,ComObjEnwrap(9,pacc,1), _idChild_:= NumGet(varChild,8,"UInt")
}

Acc_Parent(Acc) {
	try,parent:= Acc.accParent
	return,parent? Acc_Query(parent) :()
}

Acc_Query(Acc) { ; thanks Lexikos - www.autohotkey.com/forum/viewtopic.php?t=81731&p=509530#509530
	try,return,ComObj(9,ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"),1)
}