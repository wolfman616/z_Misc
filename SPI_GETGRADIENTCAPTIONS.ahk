#NoEnv 
;SPI_GETTHREADLOCALINPUTSETTINGS = 0x104E = 0x104F

;SPI_GETGRADIENTCAPTIONS 0x1008
toggle: ; test!
thread_LocalInput := True
go:=DllCall("SystemParametersInfo","UInt",0x1008,"UInt",0,"UInt",&thread_LocalInput,"UInt",0,"UInt")
msgbox,0,Result1,% "Current: " - go - (!thread_LocalInput ? "Off" : "On")  " - ( flappin )",2000

exit
actual:=SPI_THREADLOCALINPUT()
go:=DllCall("SystemParametersInfo","UInt",0x104E,"UInt",0,"UInt",&thread_LocalInput,"UInt",0,"UInt")
;msgbox % actual result confirms
msgbox,0,Result2,% "New: " (!thread_LocalInput ? "Off" : "On") " - (( gapin. ) exiting..)",2000
exitapp,

SPI_THREADLOCALINPUT(Mode="Toggle") {
	switch mode {
		case "toggle":
			retest:=threadold:=True
			go:=DllCall("SystemParametersInfoW","UInt",0x104E,"UInt",0,"UInt",&threadold,"UInt",0,"UInt")
			THR34DLOC4l:=!threadold
			go:=DllCall("SystemParametersInfoW","UInt",0x104F,"UInt",0,"UInt",THR34DLOC4l,"UInt",0,"UInt")
			go:=DllCall("SystemParametersInfoW","UInt",0x104E,"UInt",0,"UInt",&retest,"UInt",0,"UInt")
			if !(retest = threadold)
				return, THR34DLOC4l ; pass back state
}	}