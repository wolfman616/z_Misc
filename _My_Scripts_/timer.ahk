Timer(byref Label,Rate="") { ; Settimer wrapper ; eliminates param flaw.
	listlines,off
	(!rate?r:=-1:r:=Rate)    ; (mS)
	if (IsLabel(Label))&&(!(Label=""))
	 try,SetTimer,% Label,% r
	 catch,
		 return,"bad label?"
	else,return,0 ; above Param1 req plain var ref.
	return,1
}