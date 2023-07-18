#NoEnv ; Untested, may need icon sizes list in reverse order (requires imagemagick path added to env vars)
#NoTrayIcon
listlines,off
SetBatchLines,	-1
SetWinDelay,		-1
SetControlDelay,-1
DetectHiddenWindows,On
DetectHiddenText,		On
SetTitleMatchMode,Slow
SetTitleMatchMode,2

CoordMode,Tooltip,Screen
Coordmode,Mouse,	Screen
SetWorkingDir %A_ScriptDir%

Temp_Dir=%A_ScriptDir%

Args1:= A_Args[1]? A_Args[1] : "C:\Users\ninj\Desktop11\Clipboarder.2023.07.18.png"

gW:= 187, gH:= 84

gosub,vars
gosub,Hookinit

onexit,unHook

wms:="0x231,0x232,0x214,361,0x5,0x3,0x216"
loop,parse,wms,`,
	onmessage(a_loopfield,"size")

Start:
InputBox,Dims,% "Icon dimensions...",,,gw,gh,gx,gy,,Timeout,% "24, 48, 64, 128, 256"
if(errorlevel=1)
	exitapp,
loop,parse,Dims,`,
	Maxi:= a_index

if(Maxi>1)
	Dims:=strreplace(Dims," ")
else,Dims:=strreplace(Dims," ",",")

loop,parse,Dims,`,, 
{	(((ival:= a_loopfield) > ivalold)? iValMax:= ival)
	ivalold:= ival
}

splitPath,Args1,inFileName,inDir,inExtension,inNameNoExt,inDrive
o:=comobjcreate("Shell.Application")
,od:=o.namespace(inDir)
,of:=od.parsename(inFileName)

if((FileMaxDim:= ((wwe:=regexreplace(w:= od.getdetailsof(of,176),"\D*")) > (hhe:=regexreplace(h:= od.getdetailsof(of,178),"\D*")))? wwe : hhe) < iValMax) {
	msgbox,% iValMax ": Max indicated`n" FileMaxDim ": Max file dimension`nPlease rectify."
	reload,
	exitapp,
} Dest_Dir:="C:\Icon"

TEMP_FILE=TEMP_FILE.%inExtension%
fileCopy,%1%,%Temp_Dir%\%TEMP_FILE%
TEMP_FILE=%Temp_Dir%\%TEMP_FILE%
out2=%inNameNoExt%.ico
out3=TEMP_FILE.png
out4=%Temp_Dir%\%inNameNoExt%.ico
out5="%out4%"
qstr="%Dest_Dir%\%inNameNoExt%.ico"

;PNG_Create:
;Runwait,%comspec% /c convert %out3% -resize "256x256^" -gravity center -crop 256x256+0+0 +repage -alpha Set -background none -depth 8  %out3%,,hide

RunWait,%comspec% /c convert %out3% -define icon:auto-resize=%Dims% %qstr%,,hide
loop,5 {
	if(FileExist(Out4)) {
		FileMove,Out4,Dest_Dir
		break,
	} else,sleep,20
} Dest_File=%Dest_Dir%\%inNameNoExt%.ico
loop,2 {
	if(InvokeVerb(Dest_File,"Cut")) {
		msgbox,%errorlevel% error %A_Index%
		break,
	} Clipboard:= Dest_File
} return,
ExitApp,

size() {
	if(mboxhwnd)
		return,win_move(mboxhwnd,gx,gy,Scaled_W,Scaled_H)
}

Hookinit:
HookMb:= dllcall("SetWinEventHook","Uint",0x0010,"Uint",0x0010,"Ptr",0,"Ptr"
, ProcMb_:= RegisterCallback("onMsgbox",""),"Uint",0,"Uint",0,"Uint",0x0000) ;WINEVENT_OUTOFCONTEXT:= 0x0000
return,

unHook:
menu,tray,noicon
if(FileExist(TEMP_FILE))
	FileDelete,%TEMP_FILE%
else,sleep,300
dllcall("UnhookWinEvent","Ptr",ProcMb_)
sleep,20
dllcall("GlobalFree",    "Ptr",ProcMb_,"Ptr")
(%ProcMb_%):= ""
dllcall("UnhookWinEvent","Ptr",HookMb)
sleep,20
dllcall("GlobalFree",    "Ptr",HookMb,"Ptr")
(%HookMb%):= ""
ExitApp,

onMsgbox(HookCr,eventcr,hWnd,idObject,idChild,dwEventThread) {
	static mbox_hwnd
	if(!mbox_hwnd)
		global mboxhwnd:= hWnd
	loop,2 {
		WindowIconSet(hWnd,"C:\Icon\48_24\newitem.ico")
		sleep,40
}	}

WindowIconSet(hWndl,Filename,Index:= 0)  {
	local mboxicon:= b64_2_hicon(mboxicon64)
	, mboxicon2:= b64_2_hicon(mbicon48)
	SendMessage,0x80,0,mboxicon,,ahk_id %hWndl% ;WM_SETICON,ICON_SMALL
	SendMessage,0x80,1,mboxicon2,,ahk_id %hWndl% ;WM_SETICON,ICON_LARGE
	Return,ErrorLevel
}

b64_2_hicon(B64in,NewHandle:= False) {
	global
	Static hBitmap:= 0
	(NewHandle? hBitmap:= 0)
	If(hBitmap)
		Return,hBitmap
	VarSetCapacity(B64,3864 <<!!A_IsUnicode)
	If(!DllCall("Crypt32.dll\CryptStringToBinary","Ptr",&B64in,"UInt",0,"UInt", 0x01,"Ptr",0,"UIntP",DecLen,"Ptr",0,"Ptr",0))
		Return,False
	VarSetCapacity(Dec,DecLen,0)
	If(!DllCall("Crypt32.dll\CryptStringToBinary","Ptr",&B64in,"UInt",0,"UInt",0x01,"Ptr",&Dec,"UIntP",DecLen,"Ptr",0,"Ptr",0))
		Return,False
	hData:= DllCall("Kernel32.dll\GlobalAlloc","UInt",2,"UPtr",DecLen,"UPtr"), pData:= DllCall("Kernel32.dll\GlobalLock","Ptr",hData,"UPtr")
	DllCall("Kernel32.dll\RtlMoveMemory","Ptr",pData,"Ptr",&Dec,"UPtr",DecLen), DllCall("Kernel32.dll\GlobalUnlock","Ptr",hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal","Ptr",hData,"Int",True,"PtrP",pStream)
	hGdip:= DllCall("Kernel32.dll\LoadLibrary","Str","Gdiplus.dll","UPtr"), VarSetCapacity(SI,16,0), NumPut(1,SI,0,"UChar")
	DllCall("Gdiplus.dll\GdiplusStartup","PtrP",pToken,"Ptr",&SI,"Ptr",0)
	, DllCall("Gdiplus.dll\GdipCreateBitmapFromStream","Ptr",pStream,"PtrP",pBitmap)
	, DllCall("gdiplus\GdipCreateHICONFromBitmap","UPtr",pBitmap,"UPtr*",hIcon)
	, DllCall("Gdiplus.dll\GdipDisposeImage","Ptr",pBitmap), DllCall("Gdiplus.dll\GdiplusShutdown","Ptr",pToken)
	DllCall("Kernel32.dll\FreeLibrary","Ptr",hGdip), DllCall(NumGet(NumGet(pStream +0,0,"UPtr") +(A_PtrSize *2),0,"UPtr"),"Ptr",pStream)
	Return,hIcon
}

InvokeVerb(Path,Menu) {
	objShell:= ComObjCreate("Shell.Application")
	if(InStr(FileExist(Path),"D") || InStr(Path,"::{")) {
		objFolder:= objShell.NameSpace(Path)
		, objFolderItem:= objFolder.Self
	} else {
		SplitPath,Path,Name,Dir
		objFolder:= objShell.NameSpace(dir)
		, objFolderItem:= objFolder.ParseName(Name)
	} if(validate) {
		colVerbs:= objFolderItem.Verbs
		loop,% colVerbs.Count {
			Verb:= colVerbs.Item(A_Index- 1)
			, RetMenu:= Verb.Name
			StringReplace,RetMenu,RetMenu,&
			if(RetMenu=Menu) {
				Verb.DoIt
				return,True
			}
		} return,False
	} else,objFolderItem.InvokeVerbEx(Menu)
}

vars:
global mboxhwnd, dest_dir
, gx:= a_screenwidth/2 -(gw*.5)
, gy:= a_screenheight/2 -(gh*.5)
, dpiratio:= A_ScreenDPI/96
, Scaled_W:= dpiratio *gW
, Scaled_H:= dpiratio *gH
, mboxicon64:="iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAFiUAABYlAUlSJPAAAAUQSURBVEhLpZV7TJNXGId/tRXdRLLFOCUgKHOoMLVFUKAFCxTaBpgoY3Euy2KQCaJcC9hCdG5oNi/JZlDHNqd0yzKjRsF5ny4zi2bGP7Z/rO6GFjBetmxqL4h8ffee3ig4M5ed5MnvnO8r78N7vtOvCB2R13rx7Md7MeHsdxi/uwPjtu/E0x+0MTv8iHlg3YYxdY1AeLj/r59gTCPClO47sOSRkln4H9E2q0nBCU5/xX8Yllx6r8jm6s656ehh7E+C9o6XnroW6RwnOP3V/GPGnguYumkfohrahGCb3u7sa8qg3vo0+r4+lS6a0hgNHTSp6Ui9ho6I9M79WfCzq6+yRnLPfXCve3Xb4EFOcPqKJ356CannB9GiIpk5n+Zwi3sMdmdvg5auVimps0pFh6uSqKs8jtasjCEZI69gRHrnU0le8IvrRtMScq95zTMwt/9ed81G6ZQlk0ZzsqD1KLSnPWhcQR3pPeRR22kw1iW50u30MEDJtzRYqSRT3qEB5O53Qt8pQX+UkHaBkHl6ACzoazRSd2MJ/Vm52tOv4k5qN0hnOFlQ/TmaNTSpWUurLDp6YMkml8HusJszyG3Wk2ttIblNOjpZkUClxk7CMLoIhgM+QZOObtRn0EXupH/1Kk9/suPeNa7XBGWZFRW7yJZ0ix4GiHRL/SJVTHk7PXgzkowrppDi5b2EkSy2Sij+wX2TH+51/8O2a287rifxVrHABPNiKjcX0dfmQnJ5yecOergDA7mbFtGtGg3tKIui1OJdhCU7JSzh9M5F7mTB+4TaNGqvTWHmU3vdAtrOh+JS9i2H3SvQX6aPGE8IUrxj0JF7hR6aSunmygiKfamF8DgKzYSFZTaMDp/lPTR8GHJqkulEULC2hCKYyQHERX2Ps68hh85Uzqaqsmh6bv0WwvotHjS/O4B1mz1Yv5XXzFuMcTlBvcgGxVifoCKOdCw4mRUQJCZYYTRIMBoJeUUEr4C/B6YsOrsylhRWK0Hwye5+WFou48P2++jwXxMYjR6oNSxQ+AXTSFcdKohnQTYLcliQbQgRaOlseQyFdR0jCDo6nHhj4W1s3vYjDhxyo/OoB51fScjSD2K+2ga5YqZPMLKDF5+3Ij9DQn4mcQ7vQAi+2HcXX+534JX0S8iLd2FO1HHMnLUIOboV4ELgQt4cM2oBZJj4qCBlmhVL0yQsTfdweoKChiz6piKWwsR/tSGCoA07hoJ0NzIMfyE6Yg9GyZTewoFiIqPHbn9UkBljRVmKhLL5hGWpA0MCLQu4AyFYruiCSr4JxTG/w1jlQU0KH00uLggVMD5BCp0ICnTRVlSrJNQkEXbNG9oiIRBb1Kjk14iS0MBUzPgDr2cP+LYlhY6z4CRD+utO4jUJCb+/JHEvKMiPtMI8W4JlDnHbiuFbFEdhpdOvYAgblsdd8XYgCoizbvzVSTwngy/tek4hDn4PiiZZ8XaChHcSCXLZU48IxssSEEpcWCHMM+4O60AUC+1gmKB44mdojZfQ+gKhdfqIh8yCZROPQPCqly6URp7Duun3ESvPDzwLbzGRc28En8HQFmnGtaB2ym+ojvoJa6JsQ4JsOsUf1qyKo3TOx8K/F3fFtogUa/58iZAFBXKEY/KoNEyQqfCMLDG0g6vV86izOikE/7pK5Dw6HHLdN/ffr1PT+aBg5OCL9Szozet19vwbuX4C89B7yS7v67reX3ZomAv4qBr4x8dAm/8nG2uTCX8DdAhw7F53/10AAAAASUVORK5CYII"
global mbicon48:="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"
global gw, gh
return,