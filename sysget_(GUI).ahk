;	sysmetrics
;	metric 				n_index  	desc
gosub, varz
menu, tray,   icon,%  "C:\Script\AHK\APP_COG.ico"
menu, M_align, add,%  "Left",    	Align_l
menu, M_align, add,%  "Center",  	Align_c
menu, M_align, add,%  "Right",  	Align_r
menu, tray,    add,%  "Aligment",  :M_align
menu, tray,    add,%  "extended entries",  GoGoGadget_Gui
menu, M_align, Check  ,%  "Center"

GoGoGadget_Gui:
Gui_extended := !Gui_extended

gui, Gui_sys: Destroy
Gui, Gui_sys: New, -dpiscale +hwndWindle, System-Metrics
Gui, Gui_sys: Margin,% marginSz,% marginSz

if Gui_extended {
	menu, tray, Check  ,%  "extended entries"
 	Gui_sysL_H := "h1000"
	Gui_sys_H  := "h1050"
} else {
	menu, tray, UnCheck,%  "extended entries"
	Gui_sysL_H := "h865"
	Gui_sys_H  := "h889"
}
Gui, Gui_sys:Add, ListView, w1024 %Gui_sysL_H% 0x4 LV0x8200 Grid R38 +Multi gTranny vCopy, Parameter-Metric|Value|Description
 LV_ModifyCol(1, "180 Text"), LV_ModifyCol(2, "Text 106"), LV_ModifyCol(3, "Text c0xFF2211 1100") 

sysmetrics_str1:= strreplace(sysmetrics_str1,  "Â", "")
sysmetrics_str1:= strreplace(sysmetrics_str1, "`t", "")
sysmetrics_str1:= strreplace(sysmetrics_str1, "`n", "")
sysmetrics_str1:= strreplace(sysmetrics_str1, "`r", "")

a := (Metric_VALUE(sysmetrics_str1)), 
if Gui_extended 
	b := (Metric_VALUE(sysmetrics_str2))
Gui,  Gui_sys: Show, noactivate w1000 %Gui_sys_H% center

~^c::
tranny:
if winactive("ahk_id " Windle) {
	gui, Gui_sys:submit, NoHide
	CLIPBOARD =% COPY       ;not copying?
}
return,

~escape::
if !(winactive("ahk_id " Windle))
	return,
guiclose:
exitapp

Align_L:
GuiLeftAlignX := ("x" . (A_ScreenWidth * 0.3) - (0.5 * Gui_sys_W))
msgbox % GuiLeftAlignX
Gui,  Gui_sys: Show, noactivate w1006 %Gui_sys_H% x5 y57
menu, M_align, check  ,%  "Left"
menu, M_align, uncheck,%  "Center"
menu, M_align, uncheck,%  "Right"                       
return,

Align_C:
Gui,  Gui_sys: Show, noactivate w%Gui_sys_W% %Gui_sys_H% center
menu, M_align, check  ,%  "Center"
menu, M_align, uncheck,%  "Left"
menu, M_align, uncheck,%  "Right"   
return,

Align_R:
Gui,  Gui_sys: Show, NoActivate w%Gui_sys_W% %Gui_sys_H% x2632 y62
menu, M_align, Check  ,%  "Right"
menu, M_align, Uncheck,%  "Left"
menu, M_align, Uncheck,%  "Center"  
return,

Metric_VALUE(string)        {
	loop, parse, string, "#",
	{
		if (A_Index > 1)    {
			if A_Loopfield  {        ;   msgbox,% "index of '#' " A_Index ": " A_Loopfield
				loop, parse, A_Loopfield, "|",
				{
					switch   A_Index {
						case "1":   ;   msgbox,% "metricTitle: " metricTitle
							metricTitle := strreplace(strreplace(strreplace(A_Loopfield,"#","")," ",""),"_"," ")
						case "2":   ;   msgbox,% "index of '|' " A_Index ": " A_Loopfield
							loop, parse, A_Loopfield, "î",
							{	    ;	msgbox,% "index of 'î' " A_Index ": " A_Loopfield
								switch   A_Index {
									case "1":
										sysmetric[metricTitle] := strreplace(A_Loopfield, " ", "")
										if instr(A_Loopfield, ",") {
											loop, parse, A_Loopfield, `,
											{
												switch   A_Index {
													case "1":
														SysGet, ss,  %A_Loopfield%
													case "2":
														SysGet, sss, %A_Loopfield%
														Metric_VALUE := (ss . "x" sss)						
											}	}
										} else {
											SysGet, hres2,% A_Loopfield 
											Metric_VALUE := hres2							
										}
									case "2":
										metricdesc[metricTitle] := A_Loopfield
			}	} 	} 	 	}	}
			LV_Add(,metrictitle, Metric_VALUE, metricdesc[metricTitle])
}	}	}

varz:
global metricdesc, copy, Gui_sys_W, Gui_sys_H, Gui_extended
Gui_extended := true
Gui_sys_W := 1010
Gui_sys_H := 1077
marginSz       := 11
metricdesc     := []
sysmetric      := []
sysmetrics_str1 =
(
#Monitors 		           |80 		îSM_CMONITORS: Number of display monitors on the desktop (not including 'non-display pseudo-monitors').
#Screen 			       |0,1 	îSM_CXSCREEN, SM_CYSCREEN: Width and height of the screen of the primary display monitor, in pixels. These are the same as the built-in variables A_ScreenWidth and A_ScreenHeight.
#Multi-Monitor_Format      |81 		îSM_SAMEDISPLAYFORMAT: Nonzero if all the display monitors have the same color format, zero otherwise. Note that two displays can have the same bit depth, but different color formats. For example, the red, green, and blue pixels can be encoded with different numbers of bits, or those bits can be located in different places in a pixel's color value.
#Virtual_Screen_Size       |78, 79 	îSM_CXVIRTUALSCREEN, SM_CYVIRTUALSCREEN: Width and height of the virtual screen, in pixels. The virtual screen is the bounding rectangle of all display monitors. The SM_XVIRTUALSCREEN, SM_YVIRTUALSCREEN metrics are the coordinates of the top-left corner of the virtual screen.
#Virtual_Screen_Size(2)    |76, 77 	îSM_XVIRTUALSCREEN, SM_YVIRTUALSCREEN: Coordinates for the left side and the top of the virtual screen. The virtual screen is the bounding rectangle of all display monitors. By contrast, the SM_CXVIRTUALSCREEN, SM_CYVIRTUALSCREEN metrics (further above) are the width and height of the virtual screen.
#Tablet-PC			       |86 		îSM_TABLETPC: Nonzero if the current operating system is the Windows XP Tablet PC edition, zero if not.
#Mouse_Buttons             |43 		îSM_CMOUSEBUTTONS: Number of buttons on mouse (0 if no mouse is installed).
#Mouse-Drag_Thresh         |68, 69 	îSM_CXDRAG, SM_CYDRAG: Width and height of a rectangle centered on a drag point to allow for limited movement of the mouse pointer before a drag operation begins. These values are in pixels. It allows the user to click and release the mouse button easily without unintentionally starting a drag operation.
#Double-Click_Thresh       |36, 37 	îSM_CXDOUBLECLK, SM_CYDOUBLECLK: Width and height of the rectangle around the location of a first click in a double-click sequence, in pixels. The second click must occur within this rectangle for the system to consider the two clicks a double-click. (The two clicks must also occur within a specified time.)
#Mouse-Win_Track_Thresh    |34, 35 	îSM_CXMINTRACK, SM_CYMINTRACK: Minimum tracking width and height of a window, in pixels. The user cannot drag the window frame to a size smaller than these dimensions. A window can override these values by processing the WM_GETMINMAXINFO message.
#Cursor                    |13, 14 	îSM_CXCURSOR, SM_CYCURSOR: Width and height of a cursor, in pixels. The system cannot create cursors of other sizes.
#Icon_Size_(Regular)       |11, 12 	îSM_CXICON, SM_CYICON: Default width and height of an icon, in pixels.
#Icon_Size_(Small)         |49, 50 	îSM_CXSMICON, SM_CYSMICON: Recommended dimensions of a small icon, in pixels. Small icons typically appear in window captions and in small icon view.
#Icon-Spacing              |38, 39 	îSM_CXICONSPACING, SM_CYICONSPACING: Dimensions of a grid cell for items in large icon view, in pixels. Each item fits into a rectangle of this size when arranged. These values are always greater than or equal to SM_CXICON and SM_CYICON.
#Window-Max_Footprint      |59, 60 	îSM_CXMAXTRACK, SM_CYMAXTRACK: Default maximum dimensions of a window that has a caption and sizing borders, in pixels. This metric refers to the entire desktop. The user cannot drag the window frame to a size larger than these dimensions.
#Window-Size_(Minimum)	   |28, 29 	îSM_CXMIN, SM_CYMIN: Minimum width and height of a window, in pixels.
#Window-Size_Minimized     |57, 58 	îSM_CXMINIMIZED, SM_CYMINIMIZED: Dimensions of a minimized window, in pixels.
#Window-Size_Full-Screen   |16, 17 	îSM_CXFULLSCREEN, SM_CYFULLSCREEN: Width and height of the client area for a full-screen window on the primary display monitor, in pixels.
#Window-Size_Maximized     |61, 62 	îSM_CXMAXIMIZED, SM_CYMAXIMIZED: Default dimensions, in pixels, of a maximized top-level window on the primary display monitor.
#Window-Minimized_Arrange  |56 		îSM_ARRANGE: Flags specifying how the system arranged minimized windows. See MSDN for more information.
#Window-Edge_Size          |45, 46 	îSM_CXEDGE, SM_CYEDGE: Dimensions of a 3-D border, in pixels. These are the 3-D counterparts of SM_CXBORDER and SM_CYBORDER.
#Window-Border_Size		   |5, 6 		îSM_CXBORDER, SM_CYBORDER: Width and height of a window border, in pixels. This is equivalent to the SM_CXEDGE value for windows with the 3-D look.
#Window-Frame_Size         |32, 33 	îSM_CXSIZEFRAME, SM_CYSIZEFRAME: Thickness of the sizing border around the perimeter of a window that can be resized, in pixels. SM_CXSIZEFRAME is the width of the horizontal border, and SM_CYSIZEFRAME is the height of the vertical border. Synonymous with SM_CXFRAME and SM_CYFRAME
#Window-FixedFrame_Size    |7, 8 	îSM_CXFIXEDFRAME, SM_CYFIXEDFRAME (synonymous with SM_CXDLGFRAME, SM_CYDLGFRAME): Thickness of the frame around the perimeter of a window that has a caption but is not sizable, in pixels. SM_CXFIXEDFRAME is the height of the horizontal border and SM_CYFIXEDFRAME is the width of the vertical border.
#Min_spacing               |47, 48 	îSM_CXMINSPACING SM_CYMINSPACING: Dimensions of a grid cell for a minimized window, in pixels. Each minimized window fits into a rectangle this size when arranged. These values are always greater than or equal to SM_CXMINIMIZED and SM_CYMINIMIZED.
#Caption_Size 			   |4 		îSM_CYCAPTION: Height of a caption area, in pixels.
#Caption_Size_(Small)	   |51 		îSM_CYSMCAPTION: Height of a small caption, in pixels.
#Button_Size               |30, 31 	îSM_CXSIZE, SM_CYSIZE: Width and height of a button in a window's caption or title bar, in pixels.
#Button_Size_(Small)	   |52, 53 	îSM_CYSMSIZE: Dimensions of small caption buttons, in pixels.
#H-Scroll_Size             |21, 3 	îSM_CXHSCROLL, SM_CYHSCROLL: Width of the arrow bitmap on a horizontal scroll bar, in pixels; and height of a horizontal scroll bar, in pixels.
#H-Scroll-Thumb_Size       |10 		îSM_CXHTHUMB: Width of the thumb box in a horizontal scroll bar, in pixels.
#V-Scroll_Size             |2, 20 	îSM_CXVSCROLL, SM_CYVSCROLL: Width of a vertical scroll bar, in pixels; and height of the arrow bitmap on a vertical scroll bar, in pixels.
#V-Scroll-Thumb_Size       |9 		îSM_CYVTHUMB: Height of the thumb box in a vertical scroll bar, in pixels.
#Menu_Line-Height          |15 		îSM_CYMENU: Height of a single-line menu bar, in pixels.
#Menu_CheckMark_Size	   |71, 72 	îSM_CXMENUCHECK, SM_CYMENUCHECK: Dimensions of the default menu check-mark bitmap, in pixels.
#Menu_Button_Size   	   |54, 55 	îSM_CXMENUSIZE, SM_CYMENUSIZE: Dimensions of menu bar buttons, such as the child window close button used in the multiple document interface, in pixels.
#MenuDropAlignment         |40 		îSM_MENUDROPALIGNMENT: Nonzero if drop-down menus are right-aligned with the corresponding menu-bar item; zero if the menus are left-aligned.
#Focus_Border_Size         |83, 84 	îSM_CXFOCUSBORDER, SM_CYFOCUSBORDER: Width (in pixels) of the left and right edges and the height of the top and bottom edges of a control's focus rectangle. Windows 2000: The retrieved value is always 0.
)
sysmetrics_str2 =
(
#SM_CLEANBOOT 		|67		îSM_CLEANBOOT: Specifies how the system was started:    0 = Normal boot    1 = Fail-safe boot    2 = Fail-safe with network boot
#SM_SHUTTINGDOWN 	|8192 	îSM_SHUTTINGDOWN: Nonzero if the current session is shutting down; zero otherwise. Windows 2000: The retrieved value is always 0.
#SM_NETWORK			|63 	îSM_NETWORK: Least significant bit is set if a network is present; otherwise, it is cleared. The other bits are reserved for future use.
#SM_REMOTECONTROL 	|8193 	 îSM_REMOTECONTROL: This system metric is used in a Terminal Services environment. Its value is nonzero if the current session is remotely controlled; zero otherwise.
#SM_REMOTESESSION 	|4096 	îSM_REMOTESESSION: This system metric is used in a Terminal Services environment. If the calling process is associated with a Terminal Services client session, the return value is nonzero. If the calling process is associated with the Terminal Server console session, the return value is zero. The console session is not 
#SM_DBCSENABLED		|42 	îSM_DBCSENABLED: ;Nonzero if User32.dll supports DBCS; zero otherwise. 
#SM_DEBUG			|22 	îSM_DEBUG: Nonzero if the debug version of User.exe is installed; zero otherwise.
#SM_IMMENABLED   	|82 	îSM_IMMENABLED: Nonzero if Input Method Manager/Input Method Editor features are enabled; zero otherwise. SM_IMMENABLED indicates whether the system is ready to use a Unicode-based IME on a Unicode application. To ensure that a language-dependent IME works, check SM_DBCSENABLED and the system ANSI code page. Otherwise the ANSI-to-Unicode conversion may not be performed correctly, or some components like fonts or registry setting may not be present.
#SM_SECURE		    |44 	îSM_SECURE: Nonzero if security is present; zero otherwise.
)
sysmetrics_str3 =
(
#SM_PENWINDOWS		|41 	îSM_PENWINDOWS: Nonzero if the Microsoft Windows for Pen computing extensions are installed; zero otherwise.
#SM_SWAPBUTTON      |23 	îSM_SWAPBUTTON: Nonzero if the meanings of the left and right mouse buttons are swapped; zero otherwise.
#SM_SHOWSOUNDS      |70 	îSM_SHOWSOUNDS: Nonzero if the user requires an application to present information visually in situations where it would otherwise present the information only in audible form; zero otherwise.
#SM_MIDEASTENABLED	|74 	îSM_MIDEASTENABLED: Nonzero if the system is enabled for Hebrew and Arabic languages, zero if not.
#SM_MEDIACENTER     |87 	îSM_MEDIACENTER: Nonzero if the current operating system is the Windows XP, Media Center Edition, zero if not.
#MOUSE_PRESENT      |19 	îSM_MOUSEPRESENT: Nonzero if a mouse is installed; zero otherwise.
#MOUSEWHEEL_PRESENT |75 	îSM_MOUSEWHEELPRESENT: Nonzero if a mouse with a wheel is installed; zero otherwise.necessarily the physical console.
#SM_CYKANJIWINDOW 	|18 	îSM_CYKANJIWINDOW: For double byte character set versions of the system, this is the height of the Kanji window at the bottom of the screen, in pixels.
)
return,
