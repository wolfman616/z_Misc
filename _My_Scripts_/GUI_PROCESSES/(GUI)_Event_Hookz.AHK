event1 := ("EVENT_OBJECT_ACCELERATORCHANGE|0x8012|An object's KeyboardShortcut property has changed. Server applications send this event for their accessible objects.¬EVENT_OBJECT_CLOAKED|0x8017|Sent when a window is cloaked. A cloaked window still exists, but is invisible to the user.¬EVENT_OBJECT_CONTENTSCROLLED|0x8015|A window object's scrolling has ended. Unlike EVENT_SYSTEM_SCROLLEND, this event is associated with the scrolling window. Whether the scrolling is horizontal or vertical scrolling, this event should be sent whenever the scroll action is completed.  The hwnd parameter of the WinEventProc callback function describes the scrolling window  the idObject parameter is OBJID_CLIENT, and the idChild parameter is CHILDID_SELF.¬EVENT_OBJECT_CREATE|0x8000|An object has been created. The system sends this event for the following user interface elements: caret, header control, list-view control, tab control, toolbar control, tree view control, and window object. Server applications send this event for their accessible objects.  Before sending the event for the parent object, servers must send it for all of an object's child objects. Servers must ensure that all child objects are fully created and ready to accept IAccessible calls from clients before the parent object sends this event.  Because a parent object is created after its child objects, clients must make sure that an object's parent has been created before calling IAccessible::get_accParent, particularly if in-context hook functions are used.¬EVENT_OBJECT_DEFACTIONCHANGE|0x8011|An object's DefaultAction property has changed. The system sends this event for dialog boxes. Server applications send this event for their accessible objects.¬EVENT_OBJECT_DESCRIPTIONCHANGE|0x800D|An object's Description property has changed. Server applications send this event for their accessible objects.¬EVENT_OBJECT_DESTROY|0x8001|An object has been destroyed. The system sends this event for the following user interface elements: caret, header control, list-view control, tab control, toolbar control, tree view control, and window object. Server applications send this event for their accessible objects. Clients assume that all of an object's children are destroyed when the parent object sends this event.  After receiving this event, clients do not call an object's IAccessible properties or methods. However, the interface pointer must remain valid as long as there is a reference count on it due to COM rules, but the UI element may no longer be present. Further calls on the interface pointer may return failure errors  to prevent this, servers create proxy objects and monitor their life spans.¬EVENT_OBJECT_DRAGSTART|0x8021|The user started to drag an element. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the object being dragged.¬EVENT_OBJECT_DRAGCANCEL|0x8022|The user has ended a drag operation before dropping the dragged element on a drop target. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the object being dragged.¬EVENT_OBJECT_DRAGCOMPLETE|0x8023|The user dropped an element on a drop target. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the object being dragged.¬EVENT_OBJECT_DRAGENTER|0x8024|The user dragged an element into a drop target's boundary. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the drop target.¬EVENT_OBJECT_DRAGLEAVE|0x8025|The user dragged an element out of a drop target's boundary. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the drop target.¬EVENT_OBJECT_DRAGDROPPED|0x8026|The user dropped an element on a drop target. The hwnd, idObject, and idChild parameters of the WinEventProc callback function identify the drop target.¬EVENT_OBJECT_END|0x80FF|The highest object event value.¬EVENT_OBJECT_FOCUS|0x8005|An object has received the keyboard focus. The system sends this event for the following user interface elements: list-view control, menu bar, pop-up menu, switch window, tab control, tree view control, and window object. Server applications send this event for their accessible objects.  The hwnd parameter of the WinEventProc callback function identifies the window that receives the keyboard focus.¬EVENT_OBJECT_HELPCHANGE|0x8010|An object's Help property has changed. Server applications send this event for their accessible objects.¬EVENT_OBJECT_HIDE|0x8003|An object is hidden. The system sends this event for the following user interface elements: caret and cursor. Server applications send this event for their accessible objects. When this event is generated for a parent object, all child objects are already hidden. Server applications do not send this event for the child objects.	Hidden objects include the STATE_SYSTEM_INVISIBLE flag  shown objects do not include this flag. The EVENT_OBJECT_HIDE event also indicates that the STATE_SYSTEM_INVISIBLE flag is set. Therefore, servers do not send the EVENT_STATE_CHANGE event in this case.¬EVENT_OBJECT_HOSTEDOBJECTSINVALIDATED|0x8020|A window that hosts other accessible objects has changed the hosted objects. A client might need to query the host window to discover the new hosted objects, especially if the client has been monitoring events from the window. A hosted object is an object from an accessibility framework MSAA or UI Automation that is different from that of the host. Changes in hosted objects that are from the same framework as the host should be handed with the structural change events, such as EVENT_OBJECT_CREATE for MSAA. For more info see comments within winuser.h.¬EVENT_OBJECT_IME_HIDE|0x8028|An IME window has become hidden.¬EVENT_OBJECT_IME_SHOW|0x8027|An IME window has become visible.¬EVENT_OBJECT_IME_CHANGE|0x8029|The size or position of an IME window has changed.¬EVENT_OBJECT_INVOKED|0x8013|An object has been invoked  for example, the user has clicked a button. This event is supported by common controls and is used by UI Automation.	For this event, the hwnd, ID, and idChild parameters of the WinEventProc callback function identify the item that is invoked.¬EVENT_OBJECT_LIVEREGIONCHANGED|0x8019|An object that is part of a live region has changed. A live region is an area of an application that changes frequently and/or asynchronously.¬EVENT_OBJECT_LOCATIONCHANGE|0x800B|An object has changed location, shape, or size. The system sends this event for the following user interface elements: caret and window objects. Server applications send this event for their accessible objects.  This event is generated in response to a change in the top-level object within the object hierarchy  it is not generated for any children that the object might have. For example, if the user resizes a window, the system sends this notification for the window, but not for the menu bar, title bar, scroll bar, or other objects that have also changed.  The system does not send this event for every non-floating child window when the parent moves. However, if an application explicitly resizes child windows as a result of resizing the parent window, the system sends multiple events for the resized children.	  If an object's State property is set to STATE_SYSTEM_FLOATING, the server sends EVENT_OBJECT_LOCATIONCHANGE whenever the object changes location. If an object does not have this state, servers only trigger this event when the object moves in relation to its parent. For this event notification, the idChild parameter of the WinEventProc callback function identifies the child object that has changed.¬EVENT_OBJECT_NAMECHANGE|0x800C|An object's Name property has changed. The system sends this event for the following user interface elements: check box, cursor, list-view control, push button, radio button, status bar control, tree view control, and window object. Server applications send this event for their accessible objects.¬EVENT_OBJECT_PARENTCHANGE|0x800F|An object has a new parent object. Server applications send this event for their accessible objects.¬EVENT_OBJECT_REORDER|0x8004|A container object has added, removed, or reordered its children. The system sends this event for the following user interface elements: header control, list-view control, toolbar control, and window object. Server applications send this event as appropriate for their accessible objects.	  For example, this event is generated by a list-view object when the number of child elements or the order of the elements changes. This event is also sent by a parent window when the Z-order for the child windows changes.¬")
event2 := ("EVENT_OBJECT_SELECTION|0x8006|The selection within a container object has changed. The system sends this event for the following user interface elements: list-view control, tab control, tree view control, and window object. Server applications send this event for their accessible objects. This event signals a single selection: either a child is selected in a container that previously did not contain any selected children, or the selection has changed from one child to another.  The hwnd and idObject parameters of the WinEventProc callback function describe the container  the idChild parameter identifies the object that is selected. If the selected child is a window that also contains objects, the idChild parameter is OBJID_WINDOW.¬EVENT_OBJECT_SELECTIONADD|0x8007|A child within a container object has been added to an existing selection. The system sends this event for the following user interface elements: list box, list-view control, and tree view control. Server applications send this event for their accessible objects.  The hwnd and idObject parameters of the WinEventProc callback function describe the container. The idChild parameter is the child that is added to the selection.¬EVENT_OBJECT_SELECTIONREMOVE|0x8008|An item within a container object has been removed from the selection. The system sends this event for the following user interface elements: list box, list-view control, and tree view control. Server applications send this event for their accessible objects.  This event signals that a child is removed from an existing selection.  The hwnd and idObject parameters of the WinEventProc callback function describe the container  the idChild parameter identifies the child that has been removed from the selection.¬EVENT_OBJECT_SELECTIONWITHIN|0x8009|Numerous selection changes have occurred within a container object. The system sends this event for list boxes  server applications send it for their accessible objects.	  This event is sent when the selected items within a control have changed substantially. The event informs the client that many selection changes have occurred, and it is sent instead of several EVENT_OBJECT_SELECTIONADD or EVENT_OBJECT_SELECTIONREMOVE events. The client queries for the selected items by calling the container object's IAccessible::get_accSelection method and enumerating the selected items.  For this event notification, the hwnd and idObject parameters of the WinEventProc callback function describe the container in which the changes occurred.¬EVENT_OBJECT_SHOW|0x8002|A hidden object is shown. The system sends this event for the following user interface elements: caret, cursor, and window object. Server applications send this event for their accessible objects.  Clients assume that when this event is sent by a parent object, all child objects are already displayed. Therefore, server applications do not send this event for the child objects.  Hidden objects include the STATE_SYSTEM_INVISIBLE flag  shown objects do not include this flag. The EVENT_OBJECT_SHOW event also indicates that the STATE_SYSTEM_INVISIBLE flag is cleared. Therefore, servers do not send the EVENT_STATE_CHANGE event in this case.¬EVENT_OBJECT_STATECHANGE|0x800A|An object's state has changed. The system sends this event for the following user interface elements: check box, combo box, header control, push button, radio button, scroll bar, toolbar control, tree view control, up-down control, and window object. Server applications send this event for their accessible objects.	  For example, a state change occurs when a button object is clicked or released, or when an object is enabled or disabled.	  For this event notification, the idChild parameter of the WinEventProc callback function identifies the child object whose state has changed.¬EVENT_OBJECT_TEXTEDIT_CONVERSIONTARGETCHANGED|0x8030|The conversion target within an IME composition has changed. The conversion target is the subset of the IME composition which is actively selected as the target for user-initiated conversions.¬EVENT_OBJECT_TEXTSELECTIONCHANGED|0x8014|An object's text selection has changed. This event is supported by common controls and is used by UI Automation.  The hwnd, ID, and idChild parameters of the WinEventProc callback function describe the item that is contained in the updated text selection.¬EVENT_OBJECT_UNCLOAKED|0x8018|Sent when a window is uncloaked. A cloaked window still exists, but is invisible to the user.¬EVENT_OBJECT_VALUECHANGE|0x800E|An object's Value property has changed. The system sends this event for the user interface elements that include the scroll bar and the following controls: edit, header, hot key, progress bar, slider, and up-down. Server applications send this event for their accessible objects.¬EVENT_SYSTEM_ALERT|0x0002|An alert has been generated. Server applications should not send this event.¬EVENT_SYSTEM_ARRANGMENTPREVIEW|0x8016|A preview rectangle is being displayed.¬EVENT_SYSTEM_CAPTUREEND|0x0009|A window has lost mouse capture. This event is sent by the system, never by servers.¬EVENT_SYSTEM_CAPTURESTART|0x0008|A window has received mouse capture. This event is sent by the system, never by servers.¬EVENT_SYSTEM_CONTEXTHELPEND|0x000D|A window has exited context-sensitive Help mode. This event is not sent consistently by the system.¬EVENT_SYSTEM_CONTEXTHELPSTART|0x000C|A window has entered context-sensitive Help mode. This event is not sent consistently by the system.¬EVENT_SYSTEM_DESKTOPSWITCH|0x0020|The active desktop has been switched.¬EVENT_SYSTEM_DIALOGEND|0x0011|A dialog box has been closed. The system sends this event for standard dialog boxes  servers send it for custom dialog boxes. This event is not sent consistently by the system.¬EVENT_SYSTEM_DIALOGSTART|0x0010|A dialog box has been displayed. The system sends this event for standard dialog boxes, which are created using resource templates or Win32 dialog box functions. Servers send this event for custom dialog boxes, which are windows that function as dialog boxes but are not created in the standard way.  This event is not sent consistently by the system.¬EVENT_SYSTEM_DRAGDROPEND|0x000F|An application is about to exit drag-and-drop mode. Applications that support drag-and-drop operations must send this event the system does not send this event.¬EVENT_SYSTEM_DRAGDROPSTART|0x000E|An application is about to enter drag-and-drop mode. Applications that support drag-and-drop operations must send this event because the system does not send it.¬EVENT_SYSTEM_END|0x00FF|The highest system event value.¬EVENT_SYSTEM_FOREGROUND|0x0003|The foreground window has changed. The system sends this event even if the foreground window has changed to another window in the same thread. Server applications never send this event.	For this event, the WinEventProc callback function's hwnd parameter is the handle to the window that is in the foreground, the idObject parameter is OBJID_WINDOW, and the idChild parameter is CHILDID_SELF.¬EVENT_SYSTEM_MENUPOPUPEND|0x0007|A pop-up menu has been closed. The system sends this event for standard menus  servers send it for custom menus.  When a pop-up menu is closed, the client receives this message, and then the EVENT_SYSTEM_MENUEND event.	This event is not sent consistently by the system.¬EVENT_SYSTEM_MENUPOPUPSTART|0x0006|A pop-up menu has been displayed. The system sends this event for standard menus, which are identified by HMENU, and are created using menu-template resources or Win32 menu functions. Servers send this event for custom menus, which are user interface elements that function as menus but are not created in the standard way. This event is not sent consistently by the system.¬EVENT_SYSTEM_MENUEND|0x0005|A menu from the menu bar has been closed. The system sends this event for standard menus  servers send it for custom menus.  For this event, the WinEventProc callback function's hwnd, idObject, and idChild parameters refer to the control that contains the menu bar or the control that activates the context menu. The hwnd parameter is the handle to the window that is related to the event. The idObject parameter is OBJID_MENU or OBJID_SYSMENU for a menu, or OBJID_WINDOW for a pop-up menu. The idChild parameter is CHILDID_SELF.¬EVENT_SYSTEM_MENUSTART|0x0004|A menu item on the menu bar has been selected. The system sends this event for standard menus, which are identified by HMENU, created using menu-template resources or Win32 menu API elements. Servers send this event for custom menus, which are user interface elements that function as menus but are not created in the standard way.	For this event, the WinEventProc callback function's hwnd, idObject, and idChild parameters refer to the control that contains the menu bar or the control that activates the context menu. The hwnd parameter is the handle to the window related to the event. The idObject parameter is OBJID_MENU or OBJID_SYSMENU for a menu, or OBJID_WINDOW for a pop-up menu. The idChild parameter is CHILDID_SELF.	The system triggers more than one EVENT_SYSTEM_MENUSTART event that does not always correspond with the EVENT_SYSTEM_MENUEND event.¬EVENT_SYSTEM_MINIMIZEEND|0x0017|A window object is about to be restored. This event is sent by the system, never by servers.¬EVENT_SYSTEM_MINIMIZESTART|0x0016|A window object is about to be minimized. This event is sent by the system, never by servers.¬EVENT_SYSTEM_MOVESIZEEND|0x000B|The movement or resizing of a window has finished. This event is sent by the system, never by servers.¬EVENT_SYSTEM_MOVESIZESTART|0x000A|A window is being moved or resized. This event is sent by the system, never by servers.¬EVENT_SYSTEM_SCROLLINGEND|0x0013|Scrolling has ended on a scroll bar. This event is sent by the system for standard scroll bar controls and for scroll bars that are attached to a window. Servers send this event for custom scroll bars, which are user interface elements that function as scroll bars but are not created in the standard way.  The idObject parameter that is sent to the WinEventProc callback function is OBJID_HSCROLL for horizontal scroll bars, and OBJID_VSCROLL for vertical scroll bars.¬EVENT_SYSTEM_SCROLLINGSTART|0x0012|Scrolling has started on a scroll bar. The system sends this event for standard scroll bar controls and for scroll bars attached to a window. Servers send this event for custom scroll bars, which are user interface elements that function as scroll bars but are not created in the standard way.  The idObject parameter that is sent to the WinEventProc callback function is OBJID_HSCROLL for horizontal scrolls bars, and OBJID_VSCROLL for vertical scroll bars.¬EVENT_SYSTEM_SOUND|0x0001|A sound has been played. The system sends this event when a system sound, such as one for a menu, is played even if no sound is audible for example, due to the lack of a sound file or a sound card. Servers send this event whenever a custom UI element generates a sound.  For this event, the WinEventProc callback function receives the OBJID_SOUND value as the idObject parameter.¬EVENT_SYSTEM_SWITCHEND|0x0015|The user has released ALT+TAB. This event is sent by the system, never by servers. The hwnd parameter of the WinEventProc callback function identifies the window to which the user has switched.  If only one application is running when the user presses ALT+TAB, the system sends this event without a corresponding EVENT_SYSTEM_SWITCHSTART event.¬EVENT_SYSTEM_SWITCHSTART|0x0014|The user has pressed ALT+TAB, which activates the switch window. This event is sent by the system, never by servers. The hwnd parameter of the WinEventProc callback function identifies the window to which the user is switching.  If only one application is running when the user presses ALT+TAB, the system sends an EVENT_SYSTEM_SWITCHEND event without a corresponding EVENT_SYSTEM_SWITCHSTART event.")

createeventgui:
gui, eventgui: new, +owner, eventgui
gui, eventgui: +LastFound +Hwndeventguihwnd -Caption -DPIScale +AlwaysOnTop -SysMenu +ToolWindow +owndialogs
gui, eventgui: color, 0f0022
Split_Head   :=  "OBJECT_REORDER,ECT_END"
Split_Tail   :=  "DRAGCANCEL,ECT_END"
gui, ttt: new, +owner, ttt
gui, ttt: +LastFound +Hwndttthwnd -Caption -DPIScale +AlwaysOnTop -SysMenu +ToolWindow +owndialogs
gui, ttt: color, 3f0059

loop, parse,% "event1,event2", `,
	loop, parse, %A_loopfield%, ¬,
		loop, parse, A_loopfield, |,
			switch A_index {
				case 1:
					eventname:= A_loopfield
				case 2:
					eventcode:= A_loopfield
				case 3:
					winevents[eventname]  :=  eventcode
					leng := StrLen(A_loopfield)		
					if (leng > 99 )                    { 
						mainstring:= ""
						aiold     :=  1
						loop,% ( lo0 := (ceil((leng*0.01) ) ) )
						{
							if (a_index = "1")         {
								if (a_index = lo0)
									  mainstring := (SubStr(A_loopfield, 1)) ; . "END CUNTTT"
								else, mainstring := (SubStr(A_loopfield, 1, 100)) . "`n"
							} else {
								if (a_index = lo0)     {
									azss :=(SubStr(A_loopfield, ((a_index -1) * 100)))
									mainstring := mainstring . azss ; . "END CUNT"
								} else {
									if(a_index != lo0) {
										nigger := SubStr(A_loopfield, ((a_index -1) * 100), 100)
										mainstring := (mainstring . nigger . "`n")
						}	}	}	} 
						    winevent_I[eventname]  :=  mainstring
					} else, winevent_I[eventname]  :=  A_loopfield
			}
sleep 200
for Index, element in winevents {
	max_index += 1
	t_Ind := strreplace(Index,"EVENT_OBJECT_")
	gui, ttt:Add, Text, x24 y8,% winevent_i[index]
	;msgbox % winevent_i[index]
	LOOP, PARSE, Split_Tail, `, 
	{
		if Index CONTAINS %A_LOOPFIELD%
			ripple += 1
	}	
	if ripple {
		1_ := (23 - RIPPLE)
		_1 := (24 - RIPPLE)
		2_ := (46 - RIPPLE)
		_2 := (47 - RIPPLE)
		3_ := (63 - RIPPLE)
		_3 := (64 - RIPPLE)
		4_ := (72 - RIPPLE)
	} else {
		1_ := 23 
		_1 := 24
		2_ := 46
		_2 := 47 
		3_ := 63
		_3 := 64
		4_ := 72
	} 
	if max_index BETWEEN 1 AND %1_%
	{  
		if (max_index =   "1") {
			ripple   :=   0	
			col      :=   1
		}
		if (col       =   "1") {
			t_X := "x48", t_Y := ("y" . ( (max_index * 24) + (rIPPLE * 24)) )
	}	}
	Else if max_index BETWEEN %_1% AND %2_%
	{
		if (col            =    "1")   {
			if ripple                  {
				rippleold :=    rippple
				rippple   :=    0
			}
			col           :=    2
		}
		if (COL            =    "2")  
			t_Y := "y" . ((max_index - 20 ) * 24)
	}
	Else if max_index BETWEEN %_2% AND %3_%
	{
		if (col       = "2") {
			rippleold:=rippple
			rippple  := 0
			col      := 3
		} 
		if (COL       = "3") 
			t_Y := "y" . (((max_index-42) ) * 24) 
	}	
	Else if max_index BETWEEN %_3% AND %4_%
	{
		if (col = "3") {
			rippple := 0
			col := 4
		} 
		if (COL = "4") 
			t_Y := ("y" . ((max_index-59) * 24))
	}	
	t_X := ("x" . (48 + ((COL-1) * 420))) ; MSGBOX % T_X " " INDEX
	LOOP,PARSE, Split_Head, `,
	{
		if Index CONTAINS %A_LOOPFIELD%
			ripple += 1
	}
	gui, eventgui:Add, Text, %t_X% %t_Y%, %Index%
}

;gui, ttt:Add, Text, x24 y24,% winevent_i[index]
gui, ttt: show, autosize
gui, eventgui: show, autosize
return,

WM_MOUSEMOVE(wParam, lParam, Msg, Hwnd) { 
	Global ; Assume-global mode
	Static Init := OnMessage(0x0200, "WM_MOUSEMOVE")
	;VarSetCapacity(TME, 16, 0)
	;NumPut(16, TME, 0)
	;NumPut(2, TME, 4) ; TME_LEAVE
	;NumPut(hColorPalette, TME, 8)
	;DllCall("User32.dll\TrackMouseEvent", "UInt", &TME)
	MouseGetPos,x,y,hwnd, MouseCtl
	;GuiControlGet, ColorVal,, % MouseCtl%	ControlGet, ControlhWnd, hWnd ,, %Control%, ahk_id %Window%
	ControlGet, ControlhWnd, hWnd ,, %MouseCtl%, ahk_id %hwnd%
	if (MouseCtlold != MouseCtl) {
			gui, ttt:destroy
	MouseCtlold:=MouseCtl 
		ControlGetText, TOAAA, %MouseCtl%, ahk_id %hwnd%
		gui, ttt:new, +owner, ttt
		gui, ttt: +LastFound +Hwndttthwnd -Caption -DPIScale +AlwaysOnTop -SysMenu +ToolWindow +owndialogs
		gui, ttt: color, 3f0059
		gui, ttt:Add, Text, x24 y14,% winevent_i[TOAAA]
		gui, ttt:show,% "noactivate "(x_x := ("x" . ( x - 500))) " " (y_y := ("y" . ( y - 200)))  " autosize " ;" w500 h256"  
		sleep 250
}	}

WM_MOUSELEAVE(wParam, lParam, Msg, Hwnd) { 
	Global ; Assume-global mode
	Static Init := OnMessage(0x02A3, "WM_MOUSELEAVE")
}
 
WM_LBUTTONDOWN(wParam, lParam, Msg, Hwnd) {
	Global ; Assume-global mode
	Static Init := OnMessage(0x0201, "WM_LBUTTONDOWN")
	MouseGetPos,x,y,, MouseCtl
	ToolTip, % x " " y
}
