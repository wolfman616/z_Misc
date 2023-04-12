Control_Kidnap(byref Child="",x="",y="",w="",h="") {
	global new_PN
	 static list:=[]
	mousegetpos,x,y,hw,cw,2
	( !Child ? (A_New_McTLhW? (Child:=A_New_McTLhW):cw) ) ;stylemen invoked;
	WinGetPos,ChildX,ChildY,Child_W,Child_H,ahk_id %Child%
	Gui,Surrogate: New,+hwndSurrogate +Resize -dpiscale -0xcc000 +e0x010000,%new_PN% Surrogate
	Gui,Surrogate: Color,030915 ; 061830
	(!Child_H?Child_W:=800), (!Child_W?Child_H:=600), (w?Child_W:=w), (h?Child_H:=h)
	child_h<100? (Child_hh:=114,childg:=true)
	child_w<100? (Child_ww:=256,childg:=true)
	Gui,Surrogate:Show,% "Center x" ChildX " y" ChildY " w" (Child_ww?Child_ww:Child_W) " h" (Child_hh?child_h+14:Child_H+14)
	winset,transcolor,000000,ahk_id %Surrogate%
	winset,style,-0x4400000,ahk_id %Child%
	winset,style,+0x4000000,ahk_id %Child%
	sleep,144
	(oldparent:= Ancestbest(Child,2) ? list.push({ "child" : child ,"oldparent" : oldparent }))
	(childg? (parent_(Child,"remove"), ssleep(100)))
	sleep,144
	winset,exstyle,+0x2000000,ahk_id %Surrogate%
	winset,exstyle,+0x2000000,ahk_id %Child%
	if(success:=DllCall("SetParent","ptr",Child,"ptr",Surrogate)) {
		sleep,144
		win_move(Child,0,0,Child_W,Child_h,3)
		winset,style,+0x40000000,ahk_id %Child%
		winset,style,-0xcc0000,ahk_id %Surrogate% ;winset,exstyle,+0x80000,ahk_id %Child%;
		gui,Surrogate:-0xcc0000
		win_move(Surrogate,childx,childy,Child_W,Child_h,3)
	}	;WinMove,ahk_id %Child%,,ChildX+10,ChildY+10,Child_W-100,Child_H-100	;win_move(child,0,0,child_w,Child_h)
	return,Surrogate ;parent window hwnd;
}