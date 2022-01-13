#noEnv ; #warn
#persistent
#SingleInstance force
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard
global result
global tries := 1
global Target_Service := "Audiosrv" ; Audiosrv = Windows Audio Service  other audio svc = AudioEndpointBuilder; upnphost ; XblAuthManager etc

result := service_restart(Target_Service)   
settimer testresult, 4500
+
testresult:
if result !=0	 	;		 0 = OK
{
	tries := tries + 1
	if(tries > 5) {
		msgbox % "unable to restart the " Target_Service " service"
		exitapp
	}
	Tooltip retrying
	sleep 2000
	result := service_restart(Target_Service)    

} else 
	msgbox,0,% "Success..", % "The" Target_Service " Restarted succesfully at " A_now,
exitapp

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return
