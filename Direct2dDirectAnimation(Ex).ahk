#SingleInstance force
#NoTrayIcon
SetBatchLines,-1
DllCall("LoadLibrary","str","d2d1.dll")
dtagTimerEventHandler := "QueryInterface;AddRef;Release;OnPreUpdate;OnPostUpdate;OnRenderingTooSlow"
CreateObjectFromDtag("_TimerEventHandler_",dtagTimerEventHandler,tTimerEventHandler) ;Create TimerEventHandler struct of interface to recieve event
global pTimerEventHandler := &tTimerEventHandler  ;point to interface
global sizeX = 500		; width
	  ,sizeY = 500		; height
	  ,hGui				; hwnd
	  ,fps
	  ;,oD2D1Factory	; Direct2d 
	  ;,oDWriteFactory	; DirectWrite 
global pManager:=ComObjCreate("{4C1FC63A-695C-47E8-A339-1A194BE3D0B8}","{9169896C-AC8D-4e7d-94E5-67FA4DC2F2E8}") ;IUIAnimationManager
	,pTimer:=ComObjCreate("{BFCD4A0C-06B6-4384-B768-0DAA792C380E}","{6B0EFAD1-A053-41d6-9085-33A689144665}") ;IUIAnimationTimer
	,pTransitionLibrary:=ComObjCreate("{1D6322AD-AA85-4EF5-A828-86D71067D145}","{CA5A14B1-D24F-48b8-8FE4-C78169BA954E}") ;IUIAnimationTransitionLibrary
	,pVariableRed
	,pVariableGreen
	,pVariableBlue
	,iTimerEventHandlerRef
	,pFactory		; Direct2d Factory
DllCall("d2d1\D2D1CreateFactory","uint",0,"ptr",guid(CLSID,"{06152247-6f50-465a-9245-118bfd3b6007}"),"uint*",0,"ptr*",pFactory) ;Create D2D1 Factory
_InitializeAnimation()

gui,new,hwndhGui
gui,show,w%sizeX% h%sizeY%,Example: How to use Direct2D and UI Animation
OnMessage(0xF,"_Direct2D_PAINT")
OnMessage(0x14,"_WM_ERASEBKGND")
OnMessage(0x201,"_OnClick")
SendMessage,0xF,,,,ahk_id %hGui%
return,

GuiClose:
ExitApp,

_InitializeAnimation() {
	DllCall(vt(pManager,3),"ptr",pManager,"double",0.1,"ptr*",pVariableRed) ;IUIAnimationManager::CreateAnimationVariable
	DllCall(vt(pManager,3),"ptr",pManager,"double",0.8,"ptr*",pVariableGreen)
	DllCall(vt(pManager,3),"ptr",pManager,"double",0.1,"ptr*",pVariableBlue)
	DllCall(vt(pVariableRed,10),"ptr",pVariableRed,"double",0) ;IUIAnimationVariable::SetLowerBound
	DllCall(vt(pVariableRed,10),"ptr",pVariableGreen,"double",0)
	DllCall(vt(pVariableRed,10),"ptr",pVariableBlue,"double",0)
	DllCall(vt(pVariableRed,11),"ptr",pVariableRed,"double",1) ;IUIAnimationVariable::SetUpperBound
	DllCall(vt(pVariableRed,11),"ptr",pVariableGreen,"double",1)
	DllCall(vt(pVariableRed,11),"ptr",pVariableBlue,"double",1)
	pTimerUpdateHandler:=ComObjQuery(pManager,"{195509B7-5D5E-4e3e-B278-EE3759B367AD}") ;IUIAnimationTimerUpdateHandler
	DllCall(vt(pTimer,3),"ptr",pTimer,"ptr",pTimerUpdateHandler,"uint",1) ;IUIAnimationTimer::SetTimerUpdateHandler
	DllCall(vt(pTimer,4),"ptr",pTimer,"ptr",pTimerEventHandler)  ;IUIAnimationTimer::SetTimerEventHandle
}

_OnClick() {
	WinSetTitle,ahk_id %hgui%,,FPS:%fps%
	fps:= 0
	DllCall(vt(pManager,5),"ptr",pManager,"ptr*",pStoryboard) ;IUIAnimationManager::CreateStoryboard
	DllCall(vt(pTransitionLibrary,10),"ptr",pTransitionLibrary,"double",0.75,"double",Random(0,1),"double",0.5,"double",0.5,"ptr*",pTransitionRed) ;IUIAnimationTransitionLibrary::CreateAccelerateDecelerateTransition
	DllCall(vt(pTransitionLibrary,10),"ptr",pTransitionLibrary,"double",0.75,"double",Random(0,1),"double",0.5,"double",0.5,"ptr*",pTransitionGreen)
	DllCall(vt(pTransitionLibrary,10),"ptr",pTransitionLibrary,"double",0.75,"double",Random(0,1),"double",0.5,"double",0.5,"ptr*",pTransitionBlue)
	DllCall(vt(pStoryboard,3),"ptr",pStoryboard,"ptr",pVariableRed,"ptr",pTransitionRed) ;IUIAnimationStoryboard::AddTransition
	DllCall(vt(pStoryboard,3),"ptr",pStoryboard,"ptr",pVariableGreen,"ptr",pTransitionGreen)
	DllCall(vt(pStoryboard,3),"ptr",pStoryboard,"ptr",pVariableBlue,"ptr",pTransitionBlue)
	DllCall(vt(pTimer,8),"ptr",pTimer,"double*",nTimeNow) ;IUIAnimationTimer::GetTime
	DllCall(vt(pStoryboard,11),"ptr",pStoryboard,"double",nTimeNow,"uint*",0) ;IUIAnimationStoryboard::Schedule
}

_WM_ERASEBKGND() {
	return,0
}

_Direct2D_PAINT() {
	Critical
	static _NotInit:= 1
	static pRenderTarget,pGradientStops,pBackgroundBrush,pBrush3,pBrush4,oBrushAnimated
	static tD2D1_RECT_F,tD2D1_ROUNDED_RECT,tD2D1_STROKE_STYLE_PROPERTIES,tDashes
	if _NotInit	{
		if A_PtrSize=8
			_struct(tD2D1_HWND_RENDER_TARGET_PROPERTIES,"uint;uint;uint;uint",hGui,hGui>>32,sizeX,sizeY)
		else,_struct(tD2D1_HWND_RENDER_TARGET_PROPERTIES,"uint;uint;uint",hGui,sizeX,sizeY)
		DllCall(vt(pFactory,14),"ptr",pFactory
				,"ptr",_struct(tD2D1_RENDER_TARGET_PROPERTIES,"uint;uint;uint;float;float;uint;uint")
				,"ptr",&tD2D1_HWND_RENDER_TARGET_PROPERTIES
				,"ptr*",pRenderTarget)  ;ID2D1Factory::CreateHwndRenderTarget

		DllCall(vt(pRenderTarget,9),"ptr",pRenderTarget
				,"ptr",_struct(tD2D1_GRADIENT_STOP,"float;float;float;float;float;float;float;float;float;float",0,0.75,0.75,0.75,1,1,0.25,0.25,0.25,1)
				,"uint",2,"uint",0,"uint",0,"ptr*",pGradientStops) ;ID2D1RenderTarget::CreateGradientStopCollection

		DllCall(vt(pRenderTarget,10),"ptr",pRenderTarget
				,"ptr",_struct(tD2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES,"float;float;float;float",sizeX/2,0,sizeX/2,sizeX/2)
				,"ptr",0,"ptr",pGradientStops,"ptr*",pBackgroundBrush) ;ID2D1RenderTarget::CreateLinearGradientBrush

		DllCall(vt(pRenderTarget,8),"ptr",pRenderTarget
				,"ptr",_struct(tD2D1_COLOR_F3,"float;float;float;float",0,1,0,0.5)
				,"ptr",0,"ptr*",pBrush3) ;ID2D1RenderTarget::CreateSolidColorBrush

		DllCall(vt(pRenderTarget,8),"ptr",pRenderTarget
				,"ptr",_struct(tD2D1_COLOR_F3,"float;float;float;float",0,0,0,0.5)
				,"ptr",0,"ptr*",pBrush4)
	}

	DllCall(vt(pVariableRed,3),"ptr",pVariableRed,"double*",nRed) ;IUIAnimationVariable::GetValue
	DllCall(vt(pVariableGreen,3),"ptr",pVariableGreen,"double*",nGreen)
	DllCall(vt(pVariableBlue,3),"ptr",pVariableBlue,"double*",nBlue)
	_struct(tD2D1_COLOR_F4,"float;float;float;float",nRed,nGreen,nBlue,0.5)

	DllCall(vt(pBrush4,8),"ptr",pBrush4,"ptr",&tD2D1_COLOR_F4) ;ID2D1SolidColorBrush::SetColor

	if _NotInit	{
		_struct(tD2D1_RECT_F,"float;float;float;float",0,0,sizeX,sizeY)
		_struct(tD2D1_ROUNDED_RECT,"float;float;float;float;float;float",0.12*sizeX,0.12*sizeY,0.88*sizeX,0.88*sizeY,30,30)
		_struct(tD2D1_STROKE_STYLE_PROPERTIES,"uint;uint;uint;uint;float;uint;float",0,0,2,0,10,5,0)
		_struct(tDashes,"float;float",0,1)
	}

	DllCall(vt(pRenderTarget,48),"ptr",pRenderTarget) ;ID2D1RenderTarget::BeginDraw
	DllCall(vt(pRenderTarget,17),"ptr",pRenderTarget,"ptr",&tD2D1_RECT_F,"ptr",pBackgroundBrush) ;ID2D1RenderTarget::FillRectangle
	DllCall(vt(pRenderTarget,19),"ptr",pRenderTarget,"ptr",&tD2D1_ROUNDED_RECT,"ptr",pBrush4) ;ID2D1RenderTarget::FillRoundedRectangle
	DllCall(vt(pFactory,11),"ptr",pFactory,"ptr",&tD2D1_STROKE_STYLE_PROPERTIES,"ptr",&tDashes,"uint",2,"ptr*",pStrokeStyle) ;ID2D1Factory::CreateStrokeStyle
	DllCall(vt(pRenderTarget,18),"ptr",pRenderTarget,"ptr",&tD2D1_ROUNDED_RECT,"ptr",pBrush3,"float",10,"ptr",pStrokeStyle) ;ID2D1RenderTarget::DrawRoundedRectangle
	DllCall(vt(pRenderTarget,49),"ptr",pRenderTarget,"uint64*",0,"uint64*",0) ;ID2D1RenderTarget::EndDraw

	_NotInit? _NotInit:= 0 : ()
}


;;;;;;;;;;;;;
;;Functions;;
;;;;;;;;;;;;;

CreateObjectFromDtag(Name,Dtag,ByRef point) {
	StringSplit,key,Dtag,`;`,,%A_Space%%A_Tab%
	VarSetCapacity(point,A_PtrSize*(key0+1))
	NumPut(&point+A_PtrSize,point)
	loop,%key0%
		NumPut(RegisterCallback(Name key%A_Index%,"F"),point,A_PtrSize*A_Index)
}

_struct(ByRef var,type="",param*){
	if type is Integer
	{
		Loop,% VarSetCapacity(var,type,0)//4
			param[A_Index]? NumPut(param[A_Index],var,(A_Index-1)*4,"uint") : ()
	} else {
		StringSplit,key,type,`;,%A_Space%
		VarSetCapacity(var,key0*4,0)
		loop,% key0
			param[A_Index]? NumPut(param[A_Index],var,(A_Index-1)*4,key%A_Index%):()
	}
	return,&var
}

GUID(ByRef GUID,sGUID) {
	VarSetCapacity(GUID,16,0)
	return,DllCall("ole32\CLSIDFromString","wstr",sGUID,"ptr",&GUID)>= 0?&GUID:""
}

vt(p,n) {
	return,NumGet(NumGet(p+0,"ptr")+n*A_PtrSize,"ptr")
}

Random(a,b) {
	Random,p,a,b
	return,p
}

;;;;;;;;;;;;;;;;;;;;;;;;;
;;Self-Struct-interface;;
;;;;;;;;;;;;;;;;;;;;;;;;;
_TimerEventHandler_QueryInterface(pSelf,pRIID,pObj) {
	Return,0x80004002
}
_TimerEventHandler_AddRef(pSelf) {
	return,++TimerEventHandlerRef
}
_TimerEventHandler_Release(pSelf) {
	return,--iTimerEventHandlerRef
}
_TimerEventHandler_OnPreUpdate(pSelf) {
	return,0
}
_TimerEventHandler_OnPostUpdate(pSelf) {
	SendMessage,0xF,,,,ahk_id %hGui%
	fps++
	return,0
}
_TimerEventHandler_OnRenderingTooSlow(pSelf,iFramesPerSecond) {
	return,0
}