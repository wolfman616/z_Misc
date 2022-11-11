treegethot(action="") {
	global cnt:=0, cnt2:=0
	VarSetCapacity(POINT,8,0)
	mousegetpos,,,,cwnd,3
	DllCall("GetCursorPos","Ptr",&POINT)
	DllCall("ScreenToClient","Ptr",cWnd,"Ptr",&POINT)
	Xx:= NumGet(&POINT,0,"Int"), yY:= NumGet(&POINT,4,"Int")
	VarSetCapacity(RECT,16,0)
	MyTV:= new RemoteTreeView(cwnd)
	 cnt:= MyTV.GetCount()
	root:= MyTV.GetRoot()
	loop,{
		cnt2++, sel:= MyTV.GetChild(root)
		loop,{
			cnt2++
			if (cnt2>cnt)
				break,
			else if not sel  ; No more items in tree.
				if next
					sel:=next,next:=""
				else,break,
				rt:= MyTV.getrect(sel) ;msgbox % rt.top "`n`" yy "`n`" MyTV.gettext(sel)
				exp:=MyTV.IsExpanded(sel)
				if((yy>rt.top)&&(yy<rt.bottom)) { ;msgbox,% MyTV.gettext(sel) " = hot" ;MyTV.SetSelection(sel)
					switch action {
						case "gettext":	return,MyTV.gettext(sel)
						case "toggle" :	return,MyTV.Expand(sel,!exp?true:false)
						case "expand" :	return,MyTV.Expand(sel,true)
						case "shrink" :	return,MyTV.Expand(sel,false)
						case "rename" :	return,MyTV.EditLabel(sel)
						;case "check":
					}
					return,Obj:= {hWnd:	sel
							, txt:MyTV.gettext(sel)
							, isexpanded : exp
							, left	: rt.left
							, top	: rt.top
							, right	: rt.right
							, bottom: rt.bottom}
						
			} else {
				exp:=MyTV.IsExpanded(sel)
				if exp {
					next:= MyTV.GetNext(sel)
					sel:= MyTV.GetChild(sel)
					continue,
			}	}
			sel:= MyTV.GetNext(sel)
		}
		root:= MyTV.GetParent(MyTV.GetSelection())
		loop,{
			if (MyTV.gettext(root)="N")
				break,
			else,root:= MyTV.GetParent(root)
		}
		if not root  ; No more items in tree.
			break,
		else if (cnt2>cnt)
			break,
	}
	return,0
}