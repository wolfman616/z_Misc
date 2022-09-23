TT(TxT="",x:="",y="",dur="") {	;tooltip wrap can also be called with 1 or 2 params, guess which.
listlines,off
	(TxT=""? TxT:= A_now)
	if (x && !isint(x)) { ; allow2declare a_locStr
		isint(y)?(y?dur:=y) transpose potential dur arg
		somethingElseThatMightBeDeclarableLater:=dur?dur:() 
		switch	(tt_loc:=X)	{
			case "center":
				x:=	(A_screenwidth*0.5)-80
				y:=	(A_screenheight*.5)-35
			case "tray":
				x:=	A_screenwidth
				y:=	45
			case "!tray":
				x:=	A_screenwidth
				y:=	A_screenheight
		}
	} else (!y&&!dur? dur:= (x?x:-880))			;default timeout 880ms (timeout as param.2 (int or str))
	((dur&&!dur=0)? (dur<100&&dur>-100)? (dur*=1000))
	;(x="center"?Dur:=y, x:=(A_screenwidth*0.5)-80, y:=(A_screenheight*.5)-35,)
	
	ToolTip,% TxT,% (x&&y?x:""),% (x&&y? y:""), 1 ; (y="center"?y:=(A_screenheight*.5)-35)
	SetTimer,Timeout,% ((instr(dur,"-")||dur<0)?dur:("-" . dur))
	return,~errOrlevel
}

Timeout: 
tooltip,
return, 

; class tt {		  ; Like Tts in falling rain...
	 ;         t  :=   ; This.Timer := ObjBindMethod(this, "Tick")
	 ; i:=this.tt := this.Tick.Bind(this)
	; coordMode mouse, screen
	; coordMode Pixel, screen
	; __New(ttt=1000) {
		; this.count := tooltipsA
		; this.timeout := ttt
		 ; NUM="")  { ; tooltip function with a default timeout count of 400ms (timeout can be provided as UINT as 2nd param)
			; num="")?
				; (tooltips="")?(num:=1):(num:=tooltips++)
; }