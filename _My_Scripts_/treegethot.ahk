treegethot(action="") {
	static POINT, RECT
	local o, _cnt_
	VarSetCapacity(POINT,8,0)
	mousegetpos,,,vb,cwnd,3
	DllCall("GetCursorPos","Ptr",&POINT), DllCall("ScreenToClient","Ptr",cwnd,"Ptr",&POINT)
	Xx:= NumGet(&POINT,0,"Int"), yY:= NumGet(&POINT,4,"Int"), VarSetCapacity(RECT,16,0)
	MyTV:= new RemoteTreeView(cwnd)
	if((_cnt_:= MyTV.GetCount())<1)
		return.0
	root:= MyTV.GetRoot()
	loop,{
		indx++
		sel:= MyTV.GetChild(root)
		loop,{
			indx++
			if not sel ;No more items in tree.
				if next
					sel:=next,next:=""
				else,break,
			else,if(indx>_cnt_)
				return,0
			rt:= MyTV.getrect(sel)
			exp:=MyTV.IsExpanded(sel)
			if((yy>rt.top)&&(yy<rt.bottom)) {
				_cnt_:= 0,indx:= 0
				switch,action {
					case "gettext": return,MyTV.GetText(sel)
					case "rename" : return,MyTV.EditLabel(sel)
					case "expand" : return,MyTV.Expand(sel,True)
					case "shrink" : return,MyTV.Expand(sel,False)
					case "toggle" : return,MyTV.Expand(sel,(!exp? True:False))
					case "getpath": loop {
							try,path:= MyTV.GetText(sel) . "\" . path
							try,{ ; sleep,100
								sel:= MyTV.GetParent(sel)
								if(sel=0||sel="error")
									break,
						}	}
						instr( path,"Desktop\N\")? path:= strreplace(path,"Desktop\N\")
						instr( path,"(S:) EVO")? path:= strreplace(path,"(S:) EVO","S:")
						instr( path,"(C:) ADATA")? path:= strreplace(path,"(C:) ADATA","C:")
						instr( path,"(D:) Crucial P2")? path:= strreplace(path,"(D:) Crucial P2","D:")
						instr( path,"Desktop\N\Script")? path:= strreplace(path,"Desktop\N\Script","C:\Script")
						return,path
					default : return,o:= {hwnd : sel
									  , bottom : rt.bottom
									  ,  right : rt.right
									  ,	  left : rt.left
									  ,	   top : rt.top
									  ,	   txt : MyTV.gettext(sel)
								 ,  isexpanded : exp}
				}
			} else {
				try,exp:= MyTV.IsExpanded(sel)
				if exp {
					try,next:= MyTV.GetNext(sel)
					try,sel:= MyTV.GetChild(sel)
					continue,
			}	}
			try,sel:= MyTV.GetNext(sel)
		}
		try,root:= MyTV.GetParent(MyTV.GetSelection())
		loop,{
			if(MyTV.gettext(root)="N")
				break,
			else,try,root:= MyTV.GetParent(root)
		}
		if not root ;No more items in tree.
			break,
		else,if(indx>_cnt_)
			return,0
	}
	return,0
}

dtecttree(){
	local tvb,tvbold,tvv
	static counter
	mousegetpos,,,hwnd,cwnd
	if (cwnd="SysTreeView321") {
		(tvb? (!tvbold=tvb? counter:= 0 : counter++), tvbold:= tvb)
		tvb:= (tvv:= (treegethot()).bottom)
		if counter>10
			if tvv.isexpanded {
				treegethot("shrink")
				counter:= 0
}	}		}