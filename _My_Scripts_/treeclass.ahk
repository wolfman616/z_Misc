a_scriptStartTime:= a_tickCount ; (MW:2022) (MW:2022)
#NoEnv
#SingleInstance force
#include C:\Script\AHK\- _ _ LiB\_Const\tvn.ahk
#include <RemoteTreeView>
#include C:\Script\AHK\- _ _ LiB\_Const\Const_Process.ahk
#include <word>
#IfTimeout,			200
#Singleinstance,	Force
#keyhistory,		20
DetectHiddenWindows,On
DetectHiddenText,	On
SetTitleMatchMode,	2
SetTitleMatchMode,	Slow
SetBatchLines,		-1
SetWinDelay,		-1
SetControlDelay,	-1
CoordMode,	tooltip,Screen
Coordmode,	Mouse,	window 
;#include C:\Script\AHK\aHK_cryp7\_libs-and-classes-collection-master\libs\o-z\TreeView.ahk
SetBatchLines -1
ListLines,Off
SendMode,Input
SetWorkingDir,%A_ScriptDir% 
global yy
 ;Size := 28 + 3 * A_PtrSize      ; Size of a TVITEM structure
return
; Autoexecute
+space::
msgbox % treegethot().txt
return,
~space::
wingetclass,Ac,A
(Ac="CabinetWClass"?treegethot("toggle"))
return,

msgb0x("done")

^r::
treegethot("rename")
return,


	;sleep 1000
	(!ff:=errorlevel)?(x:=	msgb0x(NumGet(&rect, 4, "int") "`n" y:=	NumGet(&rect, 0, "int"))):msgb0x(errorlevel)
	tt(ItemText := MyTV.GetText(sel))
	;sendmessage,0x1111,0,0x80,,ahk_id %WinId%
	tt(errorlevel)
		;MsgBox %hItem%, whose text is "%ItemText%"
	;} else if (anus:=MyTV.IsSelected(hItem)) {
	;	ItemText := MyTV.GetText(hItem)
	 ;	MsgBox The next Item is %hItem%, whose text is "%ItemText%"
	

 
#J::
mousegetpos,x,y,h,ctlh,3
a:= new RemoteTreeView(ctlh)
b:=a.GetSelection()
	a.Expand(b, (shit:=!shit))
a.IsBold(pItem)
tt(b.GetText(pItem) )
 
return,

treegethot(action="") {
	static POINT
	static RECT,sel,sel1
	VarSetCapacity(POINT,8,0)
	mousegetpos,,,hw,cwnd,3
	DllCall("GetCursorPos","Ptr",&POINT)
	DllCall("ScreenToClient","Ptr",cwnd,"Ptr",&POINT)
	Xx:=NumGet(&POINT,0,"Int"), yY:=NumGet(&POINT,4,"Int")
	VarSetCapacity(RECT,16,0)
	MyTV:= new RemoteTreeView(cwnd)
	 cnt:= MyTV.GetCount()
	root:= MyTV.GetRoot()
	loop {
		sel:= MyTV.GetChild(root)
		loop {
			if not sel  ; No more items in tree.
				if next
					sel:=next,nest:=""
				else,break,
			rt:= MyTV.getrect(sel)			;	msgbox % rt.top "`n`" yy "`n`" MyTV.gettext(sel)
			exp:=MyTV.IsExpanded(sel)
			if((yy>rt.top)&&(yy<rt.bottom)) { ;msgbox,% MyTV.gettext(sel) " = hot"	 ;MyTV.SetSelection(sel)
				switch action {
					case "gettext":	MyTV.gettext(sel)
					case "toggle" :	MyTV.Expand(sel,!exp?true:false)
					case "expand" :	MyTV.Expand(sel,true)
					case "shrink" :	MyTV.Expand(sel,false)
					case "rename" :	MyTV.EditLabel(sel)
					;case "check":
				}
				yy:=""
				return,Obj:= {hwnd:	sel
						, txt:MyTV.gettext(sel)
						, isexpanded : exp
						, left	: rt.left
						, top	: rt.top
						, right	: rt.right
						, bottom: rt.bottom}
			} else {
				exp:=MyTV.IsExpanded(sel)
				if exp {
					next:=MyTV.GetNext(sel)
					sel:= MyTV.GetChild(sel)
					continue,
			}	}
			sel:= MyTV.GetNext(sel)
		}
		root:= MyTV.GetParent(MyTV.GetSelection())
		loop{
			if (MyTV.gettext(root)="N")
				break,
			else,root:= MyTV.GetParent(root)
		} ;msgb0x(MyTV.gettext(root))
		if not root  ; No more items in tree.
			break,
	}
	return,0
}