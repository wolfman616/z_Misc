#NoEnv
#persistent
setbatchlines -1
#persistent
#singleinstance force
#NoTrayIcon
setbatchlines -1
; Global vars:
Global Win_Explorer_Class1 := "ExploreWClass" ; New Class
Global Win_Explorer_Class2 := "CabinetWClass" ; Old Class
Global Win_Explorer_Cont1 := "CtrlNotifySink8"
Global Win_Explorer_Cont2 := "Edit1"
Global MenuContext_RightClickAgain := "-> MenuContext: Right Click Again instead of regular click <-" 
Global MenuContext_NoClicked_AddedItem := "-> MenuContext: Added items have not been clicked <-"
Global MenuContext_Separator := "-> MenuContext: Separator <-" 
Global MenuContext_Item := "-> MenuContext: Standard Item <-"
Global MenuContext_Submenu := "-> MenuContext: Popup Submenu <-"
EVENT_OBJECT_TEXTSELECTIONCHANGED:=0x8014
EventX=%EVENT_OBJECT_TEXTSELECTIONCHANGED%
GoogleSearchPath:="https://www.google.com/search?q="
RegistryFound:=""
RegRead, RegLast ,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\, LastKey
Global Active_Window:="",global Focused_Control_Name,global Selected_Text,global RegMatch,global RegAddress
RegNeedle:="i)(^[^\[]?)?(?:computer\\){0}(HK){1}((EY_LOCAL_MACHINE\\)|(EY_CLASSES_ROOT\\)|(CU\\)|(LM\\)|(CR\\)|(U\\)|(CC\\)){1}([\w\\.])+([^$\]]){0}"

OnExit("AtExit")
AtExit() {
	global hWinEventHook, lpfnWinEventProc
	if (hWinEventHook)
		DllCall("UnhookWinEvent", "Ptr", hWinEventHook), hWinEventHook := 0
	if (lpfnWinEventProc)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc, "Ptr"), lpfnWinEventProc := 0	
	return 0
	}

hWinEventHook := DllCall("SetWinEventHook", "UInt", EventX, "UInt", EventX, "Ptr", 0, "Ptr", (lpfnWinEventProc := RegisterCallback("OnEventX", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)

OnEventX(hWinEventHook, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	WinGet, Active_Window, ID , A
	ControlGetFocus, Focused_Control_Name , ahk_id %Active_Window%
	ControlGet, Selected_Text, Selected ,, %Focused_Control_Name%, "ahk_id %Active_Window%"
	;tooltip %Selected_Text% :: Event : %event% ::`nidObject: %idObject% ::
	gosub RegistryStringFind
	}

Return

Capitalised:
Capitalised:=Regexreplace(Selected_Text,"(\b\w)(.*?)","$U1$2") ;
Send %Capitalised% 
Return

RegistryStringFind:
if RegistryFound:= RegExMatch(Selected_Text, RegNeedle, RegMatch)
	{
	RegAddress=Computer\%RegMatch%
	tooltip % regaddress,,,2
	}
Return

~RButton::   ; Hook Right Click

mousegetpos,,, CurrentWindow, OutputVarControl ; Get class of current Window
WinGetClass ClassCurrentWindow, ahk_id %CurrentWindow%

if (OutputVarControl=Win_Explorer_Cont1) or (OutputVarControl=Win_Explorer_Cont2) 
	Goto Label_MenuContext_Explorer 
Return

Label_MenuContext_Explorer: 

AddItem_Google := "Google"
AddItem_Capitalise := "Capitalise"

; Position of items in the menu:
InsertItemsAtPosition := 1 ; Here just after the 1st standard item: 'Open'

ArrayToAddItems := { } ; Object as array of items to add into the context menu

; Add items to array:

;ArrayToAddItems.Push( Fct_MenuContext_Separator() )  ; Separator

;ArrayToAddItems.Push( Fct_MenuContext_Item( "Welcome" ) ) ; Standard item

ArrayToAddItems.Push( Fct_MenuContext_Item( AddItem_Capitalise ) ) ; Standard item
ArrayToAddItems.Push( Fct_MenuContext_Item( AddItem_Google ) ) ; Standard item
;ArrayToAddItems.Push( Fct_MenuContext_Separator() ) 

;Submenu, with an array of Subitems:

/* 
ArrayToAddItems.Push( Fct_MenuContext_Submenu( "Say Hello" ; Name of submenu ; And Array of Items:
	,[ AddItem_Hello1 		; 1st Item
	, MenuContext_Separator 	; Separator...
	, AddItem_Hello2
	, AddItem_Hello3
	, "Test" ] ) )

 */

ArrayToAddItems.Push( Fct_MenuContext_Separator() ) 

TargetProgram_Classes := [ Win_Explorer_Class1, Win_Explorer_Class2 ]



; Function that add the items to the context menu, and return the clicked item
ClickedItem := Fct_Get_ClickedItem_MenuContext_AddedItems( TargetProgram_Classes, InsertItemsAtPosition, ArrayToAddItems* )



If ( ClickedItem = MenuContext_RightClickAgain )
	Goto Label_MenuContext_Explorer ;  rebuild 

Else If ( ClickedItem = AddItem_Capitalise ) {
	Capitalised:=Regexreplace(Selected_Text,"(\b\w)(.*?)","$U1$2") 
	SetTimer capitalised, -200
	}

Else If ( ClickedItem = AddItem_Google ) {
	ReplacedStr := StrReplace(Selected_Text, " " , "%20")
	GoogleString=%GoogleSearchPath%%ReplacedStr%
	Run chrome.exe %GoogleString% " --new-tab "
	}

Else If ( ClickedItem = MenuContext_NoClicked_AddedItem ) 
	Return

Else If ( SubStr( ClickedItem, 1, 2 ) =  "->" ) ; Error
	Return

Else If ( ClickedItem = False )
	Return

Else 
	MsgBox % ClickedItem

Return ; End Label_Menu_Context_Explorer

Fct_MenuContext_Separator() {
	Return { Type: MenuContext_Separator }
	}

Fct_MenuContext_Item( Name ) {
	Return { Type: MenuContext_Item, Name: Name }
	}

Fct_MenuContext_Submenu( Name, ArraySubitems ) {
	Return { Type: MenuContext_SubMenu, Name: Name, Items: ArraySubitems }
	}

Fct_Get_ClickedItem_MenuContext_AddedItems( TargetProgram_Classes, InsertItemsAt_Position, ArrayOf_Items* ) 
{
	; Get program hwnd :
	For each, ProgramClass in TargetProgram_Classes 
	{
		; Get active window hwnd:
		If Program_Handle := WinActive( "ahk_class " ProgramClass ) ; Handle return false if class it's not active
			Break ; Program is active, then OK
	} ; Or not if the loop ( for each ) is finished
	
	; Check we are really in the right active program:
	If not Program_Handle ; False or Handle
		Return "-> Not into the right program <-"	
	
		; Class #32768 is for all standard windows context menu:
	Global MenuContext_AhkClass := "ahk_class #32768" 
		; Wait context menu appears:
	WinWait, %MenuContext_AhkClass% ;
		; Context menu opened –> Get handle:
	MN_GETHMENU := 0x1E1 ; Shell Constant: "Menu_GetHandleMenu"
	SendMessage, MN_GETHMENU, False, False 
	MenuContext_Handle := ErrorLevel ; Return Handle in ErrorLevel
		
	;***************************
	; 	Section: Entries:
	;***************************
	; Constants for menus in User32.dll:
	Static MF_SEPARATOR := 0x800
	Static MF_STRING := 0x0
	Static MF_POPUP := 0x10
	Static MF_BYPOSITION := 0x400 
	
	; Add each new item into the context menu:
	For each, ItemToAdd in ArrayToAdd_Items :=  ArrayOf_Items
	{
		; Save absolut position of this Item in the menu: 
		ItemToAdd.Position := InsertItemsAt_Position-1 + A_Index-1 ; Zero based
		
		; Add Separator:
		If ( ItemToAdd.Type == MenuContext_Separator ) 
		{
			; Insert Separator: –> https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-InsertMenuA
			DllCall( "User32\InsertMenu"
					,"UPtr", MenuContext_Handle
					,"UInt", ItemToAdd.Position ; At the specified position
					,"UInt", MF_SEPARATOR + MF_BYPOSITION
					,"UPtr", False
					,"UInt", False )
		}
		
		; Add Classic Item:
		Else If ( ItemToAdd.Type == MenuContext_Item )
		{
			; Insert text of item: –> https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-InsertMenuA
			DllCall( "User32\InsertMenu" 
					,"UPtr", MenuContext_Handle
					,"UInt", ItemToAdd.Position ; At the specified position
					,"UInt", MF_STRING + MF_BYPOSITION
					,"UPtr", False 
					,"Str", ItemToAdd.Name ) ; Insert Value ( text )
		}
		
		; Add Submenu and its Subitems:
		Else If ( ItemToAdd.Type == MenuContext_Submenu )
		{
			AddSubmenu := ItemToAdd ; Renames to clarify
			; Create Submenu, and return handle:
			AddSubmenu.Handle := DllCall( "User32\CreatePopupMenu" ) 
			
			; Insert Submenu into the context menu: –> https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-InsertMenuA
			DllCall( "User32\InsertMenu"
					,"UPtr", MenuContext_Handle
					,"UInt", AddSubmenu.Position  ; At the specified position
					,"UInt", MF_STRING + MF_BYPOSITION + MF_POPUP
					,"UPtr", AddSubmenu.Handle
					,"Str", AddSubmenu.Name )
			
			; Now add each Item and Separator into this Submenu:
			For each, ItemOfSubmenu in AddSubmenu.Items 
			{
				; AppendMenu –> https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-AppendMenuA
				
				; In case of Separator:
				If ( ItemOfSubmenu == MenuContext_Separator ) 
					DllCall( "User32\AppendMenu"
							,"UPtr", AddSubmenu.Handle
							,"UInt", MF_SEPARATOR
							,"UPtr", False, "UInt", False )
				
				Else  ; In case of Subintem: insert Value as text:
					DllCall( "User32\AppendMenu"
							,"UPtr", AddSubmenu.Handle
							,"UInt", MF_STRING
							,"UPtr", False
							,"Str", ItemOfSubmenu )
			}
		}
		Continue ; Continue to add next item...
	}
	; End for each add items
	
	
	;***************************
	; 	Section: Wait Click:
	;***************************
	Label_Wait_New_Click: ; When User clicks on Separator: wait new click
	
	; Wait User do a regular or right click:
	While not GetKeyState( "LButton" ) and not GetKeyState( "RButton" ) 
	{
		; Fix error if 2 right clicks are very too close: menu disappears sometimes for some apps:
		If not WinExist( MenuContext_AhkClass ) {
			;Send {RButton} 	; Reopen context menu when disappears
			Return MenuContext_RightClickAgain ; Refill the menu 
		}
	}
	
	; Is it a right click on another file ? This means that the menu is closed and reopening...
	If GetKeyState( "RButton" )
		Return MenuContext_RightClickAgain ; Then refill the menu
	;TODO: Fix error when the User right-clicks on context menu, it's filled up again

	; Else Yes: Click into an item, but witch item ?
	
	
	;***********************************
	; 	Section: Get Clicked Item:
	;***********************************
	
	; Get position of mouse into screen:
	CoordMode, Mouse, Screen
	MouseGetPos, MouseScreenX, MouseScreenY  ; Int vars: 4 octets
	
	; POINT –> https://docs.microsoft.com/fr-fr/previous-versions/dd162805(v=vs.85)
	; Create a generic C++ POINT{x,y} with a 'ULongLong' –> 'Int64' 
	; X start at the 1st ULong (right), and Y start at 2nd ULong (32th bit on left):
	MousePointScreen := x := MouseScreenX  | y := ( MouseScreenY << 32 ) 
	
	;Calculate DPI of special screen:  1K, 2K, 4K, 8K, etc...
	WinDPIMultiplicator := A_ScreenDPI / 96  ; 96 is the standard DPI screen: 1K (1600x900)
	
	; Check if clicked item is into the new added items:
	For each, AddedItemInMenu in ArrayOfAdded_Items := ArrayOf_Items 
	{
		; Click on Separator –> Disable:
		If ( AddedItemInMenu.Type == MenuContext_Separator )
		{
			; Get Rectangle of Separator:
			VarSetCapacity( ItemRectangle, 16, 0 ) ; Create Rectangle of 16 octets: 4 corners of Int (4 octets)
			
			; Fill Rectangle: –> https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-GetMenuItemRect
			isFilledRectangle := DLLCall( "User32\GetMenuItemRect"
									,"UPtr", Program_Handle
									,"UPtr", MenuContext_Handle
									,"UInt", AddedItemInMenu.Position ; Absolut position in the context menu
									,"UPtr", &ItemRectangle )
			; Is clicked on separator ?
			If isFilledRectangle 
			and isPointIntoRectangle := DllCall( "User32\PtInRect", "UPtr", &ItemRectangle, "Int64", MousePointScreen )
				Goto Label_Wait_New_Click 
		}
		
		; Click on added Item –> Return Value
		Else If ( AddedItemInMenu.Type == MenuContext_Item ) 					
		{
			VarSetCapacity( ItemRectangle, 16, 0 )
			; https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-GetMenuItemRect
			isFilledRectangle := DLLCall( "User32\GetMenuItemRect"  
									,"UPtr", Program_Handle
									,"UPtr", MenuContext_Handle
									,"UInt", AddedItemInMenu.Position 
									,"UPtr", &ItemRectangle )
			If isFilledRectangle 
			and isPointIntoRectangle := DllCall( "User32\PtInRect", "UPtr", &ItemRectangle, "Int64", MousePointScreen ) 
				Return AddedItemInMenu.Name
		}
		
		; Click on Item of Submenu –> Check each Subitem:
		Else If ( AddedItemInMenu.Type == MenuContext_Submenu )  				
		{
			Loop 3 ; 3 times, because sometimes this function does not work 1 or 2 times:
				For each, ItemInSubmenu in ( ItemIsSubmenu := AddedItemInMenu ).Items 
				{
					ItemPositionInMenu := A_Index
					
					; Get Rectangle for Subitem
					VarSetCapacity( ItemRectangle, 16, 0 ) 
					; https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-GetMenuItemRect
					isFilledRectangle := DLLCall( "User32\GetMenuItemRect"  
											,"UPtr", False ; Indicate Submenu, instead of window
											,"UPtr", ItemIsSubmenu.Handle ; Handle of the Submenu
											,"UInt", ItemPositionInMenu -1 ; Zero based
											,"UPtr", &ItemRectangle )
					
					; Get each corner of Rectangle:
					ItemRectangleX1 := NumGet( &ItemRectangle, 0, "Int" ) ; Int –> 4 octets
					ItemRectangleY1 := NumGet( &ItemRectangle, 4, "Int" )
					ItemRectangleX2 := NumGet( &ItemRectangle, 8, "Int" )
					ItemRectangleY2 := NumGet( &ItemRectangle, 12, "Int" )
					
					; Use DPI multiplicator for special screen (2K, 4K, ...):
					isMouseInto4Corners :=  ( MouseScreenX >= ItemRectangleX1 *WinDPIMultiplicator ) 
									and ( MouseScreenX <= ItemRectangleX2 *WinDPIMultiplicator ) 
									and ( MouseScreenY >= ItemRectangleY1 *WinDPIMultiplicator ) 
									and ( MouseScreenY <= ItemRectangleY2 *WinDPIMultiplicator ) 
					
					;ToolTip % "isFilledRectangle: " isFilledRectangle "`n" "isMouseInto4Corners: " isMouseInto4Corners "`nX: " ItemRectangleX1*WinDPIMultiplicator "<" MouseScreenX ">" ItemRectangleX2*WinDPIMultiplicator "`nY: " ItemRectangleY1*WinDPIMultiplicator "<" MouseScreenY ">" ItemRectangleY2*WinDPIMultiplicator, , , 5
					
					; Check if mouse is into this Rectangle: 
					If isFilledRectangle and isMouseInto4Corners
					{
						; Click on Separator ?
						If ( ItemInSubmenu == MenuContext_Separator ) ; Disable Separator:
							Goto Label_Wait_New_Click ; Wait new click
						
						Else ; Standard text Subitem: 
							Return ItemInSubmenu ; Return value of item
					}
				}
		}
		; End of one item: this is not this item
		Continue ; Then check next item...
	}
	; End: For all the new items, all checked without return
	
	; Then clicked Item is probably on another item of context menu ( like 'Open' ):
	Return MenuContext_NoClicked_AddedItem
}
;End Fct_Get_ClickedItem_MenuContext_AddedItems


