;WIP                 Making changes as demonstrated by the Explora taskbar tasklist control heirarchy which has apparently changed.
#persistent 
#NoEnv 
ListLines,           Off ; Dont forget :)
#keyhistory,         Off
#Singleinstance,     Force
DetectHiddenWindows, On
DetectHiddenText,    On
SetTitleMatchMode,   2		
SetTitleMatchMode,   Slow
setWorkingDir,%      A_ScriptDir
SetBatchLines,       -1
SetWinDelay,         -1
coordMode,  tooltip,  Screen	
coordmode,  mouse,    screen
#include            <TrayIcon>
#include            <_Struct> 
#include            <tb>

ControlGet, hParent, HWND,,MSTaskSwWClass1, ahk_class Shell_TrayWnd
ControlGet, h , hWnd,,MSTaskListWClass1 , ahk_id %hParent%
accToolBar := Acc_ObjectFromWindow(h)
For Each, Child In Acc_Children(accToolBar) {
	If (Acc_Location(accToolBar, child).w)
		try t .= (Acc_State(accToolBar, child)="pressed"? "--> ":"  ") accToolBar.accName(child) "`n"
}
MsgBox,% t
return,


Acc_Init() {
	Static	h
	If Not	h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}

Acc_Query(Acc) { ; thanks Lexikos - www.autohotkey.com/forum/viewtopic.php?t=81731&p=509530#509530
	try return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}

Acc_Error(p="") {
	static setting:=0
	return p=""?setting:setting:=p
}

Acc_GetStateText(nState)
{
	nSize := DllCall("oleacc\GetStateText", "Uint", nState, "Ptr", 0, "Uint", 0)
	VarSetCapacity(sState, (A_IsUnicode?2:1)*nSize)
	DllCall("oleacc\GetStateText", "Uint", nState, "str", sState, "Uint", nSize+1)
	Return	sState
}

Acc_Children(Acc) {
	if ComObjType(Acc,"Name") != "IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren%
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
			return Children.MaxIndex()?Children:
		} else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}

Acc_Location(Acc, ChildId=0, byref Position="") { ; adapted from Sean's code
	try Acc.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
	catch
		return
	Position := "x" NumGet(x,0,"int") " y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")
	return	{x:NumGet(x,0,"int"), y:NumGet(y,0,"int"), w:NumGet(w,0,"int"), h:NumGet(h,0,"int")}
}

Acc_State(Acc, ChildId=0) {
	try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetStateText(Acc.accState(ChildId)):"invalid object"
}

Acc_ObjectFromWindow(hWnd, idObject = -4)
{
	Acc_Init()
	If	DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
	Return	ComObjEnwrap(9,pacc,1)
}
return
Taskbar_Define(Filter="", pQ="", ByRef o1="~`a ", ByRef o2="", ByRef o3="", ByRef o4=""){
	static TB_BUTTONCOUNT = 0x418, TB_GETBUTTON=0x417, sep="|"
	ifEqual, pQ,, SetEnv, pQ, iwt

	if Filter is integer
		 bPos := Filter
	else if Filter contains ahk_pid,ahk_id
		 bPid := InStr(Filter, "ahk_pid"),  bID := !bPid,  Filter := SubStr(Filter, 8)
	else bName := true

	oldDetect := A_DetectHiddenWindows
	DetectHiddenWindows, on

	WinGet,	pidTaskbar, PID, ahk_class Shell_TrayWnd
	hProc := DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pidTaskbar)
	pProc := DllCall("VirtualAllocEx", "Uint", hProc, "Uint", 0, "Uint", 32, "Uint", 0x1000, "Uint", 0x4)
	hctrl := Taskbar_getTaskBar()
	SendMessage,TB_BUTTONCOUNT,,,, ahk_id %hctrl%
	
	i := bPos ? bPos-1 : 0
	cnt := bPos ?  1 : ErrorLevel
	Loop, %cnt%
	{
		i++
		SendMessage, TB_GETBUTTON, i-1, pProc,, ahk_id %hctrl%

		VarSetCapacity(BTN,32), DllCall("ReadProcessMemory", "Uint", hProc, "Uint", pProc, "Uint", &BTN, "Uint", 32, "Uint", 0)
		if !(dwData := NumGet(BTN,12))
			dwData := NumGet(BTN,16,"int64")

		VarSetCapacity(NFO,32), DllCall("ReadProcessMemory", "Uint", hProc, "Uint", dwData, "Uint", &NFO, "Uint", 32, "Uint", 0)
		if NumGet(BTN,12)
			 w := NumGet(NFO, 0),		   o := NumGet(NFO, 20)
		else w := NumGet(NFO, 0, "int64"), o := NumGet(NFO, 24)
		ifEqual, w, 0, continue

		WinGet, n, ProcessName, ahk_id %w%
		WinGet, p, PID, ahk_id %w%
		WinGetTitle, t, ahk_id %w%
		
		if !Filter || bPos || (bName && Filter=n) || (bPid && Filter=p) || (bId && Filter=w) {
			loop, parse, pQ
				f := A_LoopField, res .= %f% sep
			res := SubStr(res, 1, -1) "`n"		
		}
	}
	DllCall("VirtualFreeEx", "Uint", hProc, "Uint", pProc, "Uint", 0, "Uint", 0x8000), DllCall("CloseHandle", "Uint", hProc)
	
	if (bPos)
		loop, parse, pQ
			o%A_Index% := %A_LoopField%

	DetectHiddenWindows,  %oldDetect%
	return SubStr(res, 1, -1)
}
 
Taskbar_getTaskBar(){
	ControlGet, hParent, HWND,,MSTaskSwWClass1, ahk_class Shell_TrayWnd
	ControlGet, h , hWnd,,MSTaskListWClass1, ahk_id %hParent%
	return, h
}