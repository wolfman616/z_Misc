WinGetPos(byref WinTitle="") { ;,WinText="",ExcludeTitle="",ExcludeText="") {
	(!detecthiddenwindows? (detecthiddenwindows,"on",timer("detecthiddenwindows",-300)))
	(!detecthiddentext? (detecthiddentext,"on",timer("detecthiddentext",-300)))
	WinGetPos, wX, wY, wWidth, wHeight,ahk_id %WinTitle% ;,% WinText,% ExcludeTitle,% ExcludeText
	return,	_:= ({	"X" : wx
				,	"Y" : wY
				,	"W" : wWidth
				,	"H" : wHeight })
}

detecthiddenwindows:
detecthiddentext:
(%a_thislabel%),off
return,