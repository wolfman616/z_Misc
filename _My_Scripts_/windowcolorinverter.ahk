#SingleInstance force
global invertedWindows:=[]
, invertedpids:=[]
onexit,closeall
return,

F12::Invert(winExist("a"))

Invert(hWnd) {
	loop
		if invertedWindows[a_index] {
			if(hwnd=invertedWindows[a_index]) {
				invertedWindows.delete(a_index)
				msgbox % a_index " was inverted- restoring"
				PostMessage,0x0111,65307,,,% "ahk_pid " invertedpids[a_index]
				return,
			}
		} else {
			invertedWindows[a_index]:= hWnd
			run,% "C:\Program Files\Autohotkey13602\AutoHotkeyU64.exe c:\Script\AHK\WindowColorInvert.ahk " . hWnd,,,pid
			invertedpids[a_index]:= pid
			break,
		}
}

closeall:
for,pid in invertedpids
	PostMessage,0x0111,65307,,,% "ahk_pid " invertedpids[pid]
exitapp,