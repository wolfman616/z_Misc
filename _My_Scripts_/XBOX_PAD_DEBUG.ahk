#persistent
#include <XInput>
onexit("XInput_Term")
XInput_Init()
settimer,timer_xboxpad,100
return,

timer_xboxpad:
tooltip:= BUttons:= ""
Loop,2 {
	if(!State:= XInput_GetState(A_Index-1)) 
			continue,
	LT_ANALOG:= State.bLeftTrigger, 		RT_ANALOG := State.bRightTrigger
	,	ANALOG_LEFT_X:= State.sThumbLX,		ANALOG_LEFT_Y:= State.sThumbLY
	,	ANALOG_RIGHT_X:= State.sThumbRX	,	ANALOG_RIGHT_Y:= State.sThumbRY
	loop,parse,% "LT_ANALOG,RT_ANALOG",`, 
			if((%a_loopfield%)="") {
				settimer,timer_xboxpad,1000 ;Pad discon? Reduce rate.
				return,
			}	else,if((%a_loopfield%)>0)
				tooltip.= chr(32) . chr(32) . chr(32) . a_loopfield . ": " (%a_loopfield%) . chr(32) . chr(32) . chr(32)
	(tooltip ? tooltip.= "`n")
	loop,parse,% "ANALOG_LEFT_X,ANALOG_LEFT_Y",`,
	{
		oldvarnameasstring:=	a_loopfield . "old"
		if((%a_loopfield%)>((%oldvarnameasstring%)+4000))
		 ||((%a_loopfield%)<((%oldvarnameasstring%)-4000))
				tooltip.=chr(32) . a_loopfield . (%a_loopfield%)
				,ssleep(100)
		(%oldvarnameasstring%):=(%a_loopfield%)
	}	(tooltip ? tooltip.= "`n")
	loop,parse,% "ANALOG_RIGHT_X,ANALOG_RIGHT_Y",`,
	{
			oldvarnameasstring:=	a_loopfield . "old"
				if((%a_loopfield%)>((%oldvarnameasstring%)+4000))
				 ||((%a_loopfield%)<((%oldvarnameasstring%)-4000))
					tooltip.=chr(32) . a_loopfield . (%a_loopfield%)
					,ssleep(200)
			(%oldvarnameasstring%):=(%a_loopfield%)
	}
	((wButtons:= State.wButtons) &0x0001? BUttons.= " DPAD UP ")
	((wButtons:= State.wButtons) &0x0002? BUttons.= " DPAD DOWN ")
	((wButtons:= State.wButtons) &0x0004? BUttons.= " DPAD LEFT ")
	((wButtons:= State.wButtons) &0x0008? BUttons.= " DPAD RIGHT ")
	((wButtons:= State.wButtons) &0x0010? BUttons.= " SELECT ")
	((wButtons:= State.wButtons) &0x0020? BUttons.= " START ")
	((wButtons:= State.wButtons) &0x0040? BUttons.= " LEFT ANALOG BUTT ")
	((wButtons:= State.wButtons) &0x0080? BUttons.= " RIGHT ANALOG BUTT ")
	((wButtons:= State.wButtons) &0x0100? BUttons.= "   LEFT TRIGGER 1 `n")
	((wButtons:= State.wButtons) &0x0200? BUttons.= "   RIGHT TRIGGER 1 `n")
	((wButtons:= State.wButtons) &0x1000? BUttons.= " × ")
	((wButtons:= State.wButtons) &0x2000? BUttons.= " ø ")
	((wButtons:= State.wButtons) &0x4000? BUttons.= chr(32) . chr(214) . chr(32))
	((wButtons:= State.wButtons) &0x8000? BUttons.= " ^ ")
	tooltip,% tooltip (w:= Buttons? "`n " . BUttons : "") . (RawHexButtsVisible? (wb:=(wButtons!=0)? "`n`nRaw: " . Format("{:#x}",wBUttons) : "") : "")
} return,