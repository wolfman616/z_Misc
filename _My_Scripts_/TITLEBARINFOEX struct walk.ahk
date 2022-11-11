a_scriptStartTime:= a_tickCount ; (MW:2022) (MW:2022)
#NoEnv 
 #include C:\Script\AHK\- _ _ LiB\_Const\Const_Process.ahk
menu,tray,icon,% "C:\Icon\24\Gterminal_24_32.ico"
; #IfTimeout,200 ;* DANGER * : Performance impact if set too low. *think about using this*.
; ListLines,Off 
#persistent 
#Singleinstance,	Force
DetectHiddenWindows,On
DetectHiddenText,	On
SetTitleMatchMode,	2
SetTitleMatchMode,	Slow
Setworkingdir,% (splitpath(A_AhkPath)).dir
SetBatchLines,		-1
SetWinDelay,		-1
coordMode,	ToolTip	,Screen
coordmode,	Mouse	,Screen
OnMessage(0x404,"AHK_NOTIFYICON")
loop,parse,% "VarZ,MenuZ",`,
	 gosub,% a_loopfield
;DWORD cbsize
gui, add,text,, fuckoff
gui, show,w600 h200 center, fuckoff
return

^!space::
mousegetpos,x,y,hwnd,cwnd,2
sizeof_RECT := 16
cbsize:=sizeof_TITLEBARINFOEX:= 140
varsetcapacity(TITLEBARINFOEX,cbsize,0)
numput(cbsize,TITLEBARINFOEX,0,"int")
sendmessage,0x33F,0,% &TITLEBARINFOEX,,ahk_id %hwnd%
msgbox % "err " errorlevel
rcTitleBar := { left:	NumGet(TITLEBARINFOEX, 4,"int")
			,	top:	NumGet(TITLEBARINFOEX, 8,"int")
			,	right:	NumGet(TITLEBARINFOEX,12,"int")
			,	bottom:	NumGet(TITLEBARINFOEX,16,"int")}
msgbox,% rcTitleBar.left "`n" rcTitleBar.right 
;DWORD rgstate[CCHILDREN_TITLEBAR + 1]
ttP2:= NumGet(TITLEBARINFOEX, 20, "int")
rcTitleBar2 := { left:	NumGet(TITLEBARINFOEX,24,"int") ;reserved
			,	top:	NumGet(TITLEBARINFOEX,28,"int")
			,	right:	NumGet(TITLEBARINFOEX,32,"int")
			,	bottom:	NumGet(TITLEBARINFOEX 36,"int")}
					msgbox,% rcTitleBar2.top "`n" rcTitleBar2.bottom 
msgbox % _ttlbar_enumeration(ttP3:= NumGet(TITLEBARINFOEX, 40, "int"))
rcTitleBar3 := { left:	NumGet(TITLEBARINFOEX,44,"int") ;reserved possibly
			,	top:	NumGet(TITLEBARINFOEX,48,"int")
			,	right:	NumGet(TITLEBARINFOEX,52,"int")
			,	bottom:	NumGet(TITLEBARINFOEX,56,"int")}
					msgbox,% rcTitleBar3.top "`n" rcTitleBar3.bottom 
msgbox % _ttlbar_enumeration(ttP4:= NumGet(TITLEBARINFOEX, 60, "int"))
rcTitleBar4 := { left:	NumGet(TITLEBARINFOEX,64,"int") 
			,	top:	NumGet(TITLEBARINFOEX,68,"int")
			,	right:	NumGet(TITLEBARINFOEX,72,"int")
			,	bottom: NumGet(TITLEBARINFOEX,76,"int")}
					msgbox,% rcTitleBar4.top "`n" rcTitleBar4.bottom 
msgbox % _ttlbar_enumeration(ttP5:= NumGet(TITLEBARINFOEX, 80, "int"))

rcTitleBar5 := { left:	NumGet(TITLEBARINFOEX,84,"int") 
			,	top:	NumGet(TITLEBARINFOEX,88,"int")
			,	right:  NumGet(TITLEBARINFOEX,92,"int")
			,	bottom: NumGet(TITLEBARINFOEX,96,"int")}
					msgbox,% rcTitleBar5.top "`n" rcTitleBar5.bottom 
ttP6:= NumGet(TITLEBARINFOEX,100,"int")
msgbox % _ttlbar_enumeration(ttP6)
rcTitleBar6 := { left:	NumGet(TITLEBARINFOEX,104,"int") 
			,	top:	NumGet(TITLEBARINFOEX,108,"int")
			,	right:	NumGet(TITLEBARINFOEX,112,"int")
			,	bottom:	NumGet(TITLEBARINFOEX,116,"int") }
					msgbox,% rcTitleBar6.top "`n" rcTitleBar6.bottom 
msgbox % _ttlbar_enumeration(ttP7:= NumGet(TITLEBARINFOEX, 120, "int"))
rcTitleBar7 := { left:	NumGet(TITLEBARINFOEX,124,"int") 
			,	top:	NumGet(TITLEBARINFOEX,128,"int")
			,	right:  NumGet(TITLEBARINFOEX,132,"int")
			,	bottom: NumGet(TITLEBARINFOEX,136,"int") }
msgbox,% rcTitleBar7.top "`n" rcTitleBar7.bottom 
return,


_ttlbar_enumeration(bitmask){
	(bitmask &0x00100000? state .= "STATE_SYSTEM_FOCUSABLE"    )
	(bitmask &0x00008000? state .= "STATE_SYSTEM_INVISIBLE"    )
	(bitmask &0x00010000? state .= "STATE_SYSTEM_OFFSCREEN"    )
	(bitmask &0x00000001? state .= "STATE_SYSTEM_UNAVAILABLE"  )
	(bitmask &0x00000008? state .= "STATE_SYSTEM_PRESSED"      )
	return state
}
menutray(){
global
	Menu,Tray,Show
}
OpenProcess(DesiredAccess, InheritHandle, ProcessId)
{
	return DllCall("OpenProcess"
	             , "Int", DesiredAccess
				 , "Int", InheritHandle
				 , "Int", ProcessId
				 , "Ptr")
}

;----------------------------------------------------------------------------------------------
; Function: CloseHandle
;         Closes an open object handle.
;
; Parameters:
;         hObject       - A valid handle to an open object
;
; Returns:
;         If the function succeeds, the return value is nonzero.
;         If the function fails, the return value is zero.
;
CloseHandle(hObject)
{
	return DllCall("CloseHandle"
	             , "Ptr", hObject
				 , "Int")
}

;----------------------------------------------------------------------------------------------
; Function: VirtualAllocEx
;         Reserves or commits a region of memory within the virtual address space of the 
;         specified process, and specifies the NUMA node for the physical memory.
;
; Parameters:
;         hProcess      - A valid handle to an open object. The handle must have the 
;                         PROCESS_VM_OPERATION access right.
;
;         Address       - The pointer that specifies a desired starting address for the region 
;                         of pages that you want to allocate. 
;
;                         If you are reserving memory, the function rounds this address down to 
;                         the nearest multiple of the allocation granularity.
;
;                         If you are committing memory that is already reserved, the function rounds 
;                         this address down to the nearest page boundary. To determine the size of a 
;                         page and the allocation granularity on the host computer, use the GetSystemInfo 
;                         function.
;
;                         If Address is NULL, the function determines where to allocate the region.
;
;         Size          - The size of the region of memory to be allocated, in bytes. 
;
;         AllocationType - The type of memory allocation. This parameter must contain ONE of the 
;                          following values:
;								MEM_COMMIT
;								MEM_RESERVE
;								MEM_RESET
;
;         ProtectType   - The memory protection for the region of pages to be allocated. If the 
;                         pages are being committed, you can specify any one of the memory protection 
;                         constants:
;								 PAGE_NOACCESS
;								 PAGE_READONLY
;								 PAGE_READWRITE
;								 PAGE_WRITECOPY
;								 PAGE_EXECUTE
;								 PAGE_EXECUTE_READ
;								 PAGE_EXECUTE_READWRITE
;								 PAGE_EXECUTE_WRITECOPY
;
; Returns:
;         If the function succeeds, the return value is the base address of the allocated region of pages.
;         If the function fails, the return value is NULL.
;
VirtualAllocEx(hProcess, Address, Size, AllocationType, ProtectType)
{
	return DllCall("VirtualAllocEx"
				 , "Ptr", hProcess
				 , "Ptr", Address
				 , "UInt", Size
				 , "UInt", AllocationType
				 , "UInt", ProtectType
				 , "Ptr")
}

;----------------------------------------------------------------------------------------------
; Function: VirtualFreeEx
;         Releases, decommits, or releases and decommits a region of memory within the 
;         virtual address space of a specified process
;
; Parameters:
;         hProcess      - A valid handle to an open object. The handle must have the 
;                         PROCESS_VM_OPERATION access right.
;
;         Address       - The pointer that specifies a desired starting address for the region 
;                         to be freed. If the dwFreeType parameter is MEM_RELEASE, lpAddress 
;                         must be the base address returned by the VirtualAllocEx function when 
;                         the region is reserved.
;
;         Size          - The size of the region of memory to be allocated, in bytes. 
;
;                         If the FreeType parameter is MEM_RELEASE, dwSize must be 0 (zero). The function 
;                         frees the entire region that is reserved in the initial allocation call to 
;                         VirtualAllocEx.
;
;                         If FreeType is MEM_DECOMMIT, the function decommits all memory pages that 
;                         contain one or more bytes in the range from the Address parameter to 
;                         (lpAddress+dwSize). This means, for example, that a 2-byte region of memory
;                         that straddles a page boundary causes both pages to be decommitted. If Address 
;                         is the base address returned by VirtualAllocEx and dwSize is 0 (zero), the
;                         function decommits the entire region that is allocated by VirtualAllocEx. After 
;                         that, the entire region is in the reserved state.
;
;         FreeType      - The type of free operation. This parameter can be one of the following values:
;								MEM_DECOMMIT
;								MEM_RELEASE
;
; Returns:
;         If the function succeeds, the return value is a nonzero value.
;         If the function fails, the return value is 0 (zero). 
;
VirtualFreeEx(hProcess, Address, Size, FType)
{
	return DllCall("VirtualFreeEx"
				 , "Ptr", hProcess
				 , "Ptr", Address
				 , "UINT", Size
				 , "UInt", FType
				 , "Int")
}

;----------------------------------------------------------------------------------------------
; Function: WriteProcessMemory
;         Writes data to an area of memory in a specified process. The entire area to be written 
;         to must be accessible or the operation fails
;
; Parameters:
;         hProcess      - A valid handle to an open object. The handle must have the 
;                         PROCESS_VM_WRITE and PROCESS_VM_OPERATION access right.
;
;         BaseAddress   - A pointer to the base address in the specified process to which data 
;                         is written. Before data transfer occurs, the system verifies that all 
;                         data in the base address and memory of the specified size is accessible 
;                         for write access, and if it is not accessible, the function fails.
;
;         Buffer        - A pointer to the buffer that contains data to be written in the address 
;                         space of the specified process.
;
;         Size          - The number of bytes to be written to the specified process.
;
;         NumberOfBytesWritten   
;                       - A pointer to a variable that receives the number of bytes transferred 
;                         into the specified process. This parameter is optional. If NumberOfBytesWritten 
;                         is NULL, the parameter is ignored.
;
; Returns:
;         If the function succeeds, the return value is a nonzero value.
;         If the function fails, the return value is 0 (zero). 
;
WriteProcessMemory(hProcess, BaseAddress, Buffer, Size, ByRef NumberOfBytesWritten = 0)
{
	return DllCall("WriteProcessMemory"
				 , "Ptr", hProcess
				 , "Ptr", BaseAddress
				 , "Ptr", Buffer
				 , "Uint", Size
				 , "UInt*", NumberOfBytesWritten
				 , "Int")
}

;----------------------------------------------------------------------------------------------
; Function: ReadProcessMemory
;         Reads data from an area of memory in a specified process. The entire area to be read 
;         must be accessible or the operation fails
;
; Parameters:
;         hProcess      - A valid handle to an open object. The handle must have the 
;                         PROCESS_VM_READ access right.
;
;         BaseAddress   - A pointer to the base address in the specified process from which to 
;                         read. Before any data transfer occurs, the system verifies that all data 
;                         in the base address and memory of the specified size is accessible for read 
;                         access, and if it is not accessible the function fails.
;
;         Buffer        - A pointer to a buffer that receives the contents from the address space 
;                         of the specified process.
;
;         Size          - The number of bytes to be read from the specified process.
;
;         NumberOfBytesWritten   
;                       - A pointer to a variable that receives the number of bytes transferred 
;                         into the specified buffer. If lpNumberOfBytesRead is NULL, the parameter 
;                         is ignored.
;
; Returns:
;         If the function succeeds, the return value is a nonzero value.
;         If the function fails, the return value is 0 (zero). 
;
ReadProcessMemory(hProcess, BaseAddress, ByRef Buffer, Size, ByRef NumberOfBytesRead = 0)
{
	return DllCall("ReadProcessMemory"
	             , "Ptr", hProcess
				 , "Ptr", BaseAddress
				 , "Ptr", &Buffer
				 , "UInt", Size
				 , "UInt*", NumberOfBytesRead
				 , "Int")
}

menuz:
menu,Tray,NoStandard
menu,Tray,Add,%	 splitpath(A_scriptFullPath).fn,% "do_nothing"
menu,Tray,disable,% splitpath(A_scriptFullPath).fn
menu,Tray,Add ,% "Open",%	"MenHandlr"
menu,Tray,Icon,% "Open",%	"C:\Icon\24\Gterminal_24_32.ico"
menu,Tray,Add ,% "Open Containing",%	"MenHandlr"
menu,Tray,Icon,% "Open Containing",%	"C:\Icon\24\explorer24.ico"
menu,Tray,Add ,% "Edit",%	"MenHandlr"
menu,Tray,Icon,% "Edit",%	"C:\Icon\24\explorer24.ico"
menu,Tray,Add ,% "Reload",%	"MenHandlr"
menu,Tray,Icon,% "Reload",%	"C:\Icon\24\eaa.bmp"
menu,Tray,Add,%	 "Suspend",%	"MenHandlr"
menu,Tray,Icon,% "Suspend",%	"C:\Icon\24\head_fk_a_24_c1.ico"
menu,Tray,Add,%	 "Pause",%		"MenHandlr"
menu,Tray,Icon,% "Pause",%		"C:\Icon\24\head_fk_a_24_c2b.ico"
menu,Tray,Add ,% "Exit",%		"MenHandlr"
menu,Tray,Icon,% "Exit",%		"C:\Icon\24\head_fk_a_24_c2b.ico"
msgb0x((ahkexe:= splitpath(A_AhkPath)).fn
,	 (_:= (splitpath(A_scriptFullPath).fn) " Started`n@ " time4mat() "   In:  "
.	_:= (a_tickCount-a_scriptStartTime) " Ms"),3)
sleep,100
a_scriptStartTime:= time4mat(a_now,"H:m - d\M")
_:=""
menu,Tray,Tip,% splitpath(A_scriptFullPath).fn "`nRunning, Started @`n" a_scriptStartTime
do_nothing:
return,

MenHandlr(isTarget="") {
	listlines,off
	switch 	(isTarget=""? a_thismenuitem : isTarget) {
		case "Open Containing": TT("Opening "   a_scriptdir "..." Open_Containing(A_scriptFullPath),1)
		case "edit","Open","SUSPEND","pAUSE":
			PostMessage,0x0111,(%a_thismenuitem%),,,% A_ScriptName " - AutoHotkey"
		case "RELOAD": reload()
		case "EXIT": exitapp
		default: islabel(a_thismenuitem)? timer(a_thismenuitem,-10) : ()
	}	
	return,1
}

AHK_NOTIFYICON(byref wParam="", byref lParam="") {
	switch lParam {
	;	case 0x0206: ; WM_RBUTTONDBLCLK	;	case 0x020B: ; WM_XBUTTONDOWN
	;	case 0x0201: ; WM_LBUTTONDOWN	;	case 0x0202: ; WM_LBUTTONUP
		case 0x0204: 
			return,timer("menutray",-1) ; WM_RBUTTONdn
		case 0x0203: 
			(_:="",wParam:=""),
			timer("ID_VIEW_VARIABLES",-10)
			PostMessage,0x0111,%open%,,,% A_ScriptName " - AutoHotkey"
			sleep(80),lParam:=(sleep(11),tt("Loading...","tray",1)) ; WM_doubleclick  
	}
	return
}

reload() {
	reload,
	exitapp,
}

varz:
global	EDIT:=65304, open:=65407, Suspend:=65305, PAUSE:=65306, exit:=6530
global	This_PiD:= DllCall("GetCurrentProcessId")
return,