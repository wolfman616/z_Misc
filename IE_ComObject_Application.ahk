;INTERNET EXPLORER APPLICATION 
#Warn
SetWorkingDir %A_ScriptDir%
#singleinstance force
Array :=[]
wb := ComObjCreate("InternetExplorer.application")
wb.visible := False
wb.Navigate("https://imx.to/i/2ffi1y")
while wb.ReadyState != 4 || wb.document.readystate != "complete" || wb.busy
    sleep 20
    
wb.document.all["imgContinue"].click()
;send, {enter}
;wb.document.all.submit.click()
;while wb.ReadyState != 4 || wb.document.readystate != "complete" || wb.busy
    ;sleep 10
while wb.ReadyState != 4 || wb.document.readystate != "complete" || wb.busy
sleep 20
dick:=Wb.document.documentElement.outerhtml 
p:= 1,	Matched_String:= ""
FoundJPGs2:=0
Needlef=(?:href=")(?:https:\/\/)(?:\imx\.to)[\/a-z0-9\.]*
foo="2
	while p := RegExMatch(dick, Needlef, Matched_String, (p + StrLen(Matched_String))) {
FoundJPGs2:=FoundJPGs2+1, p := p + StrLen(Matched_String)
SplitPath, Matched_String1, namex, dirx, extx, name_no_extx, drivex
array[FoundJPGs2]:=[matched_string]
urldownloadtoFile %matched_string1%, %namex%
msgbox %matched_string1%
}