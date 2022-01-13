#noEnv ; #warn
; #persistent
#SingleInstance force
sendMode Input

CoordMode, ToolTip, Client 
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard
;img:="S:\Documents\My Pictures\Icons\- CuRS0R\PIANO.ANI"
;img:="S:\Documents\My Pictures\Icons\- CuRS0R\bfly.ani"
img:="S:\Documents\My Pictures\Icons\- CuRS0R\Retikool2.ani"
;img:="S:\Documents\My Pictures\Icons\- CuRS0R\DB_04BUS.ANI" ; gold dripping thing
;img2:="S:\Documents\My Pictures\Icons\- CuRS0R\CY_04BUS.ANI"

mousegetpos x, y
tooltip % "here ..." ,x, y-80
sleep 900

SetSystemCursor(img)
sleep 2220
RestoreCursor()
tooltip
sleep 10
msgbox, 0, turdface, bye, 2
return,



Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return
