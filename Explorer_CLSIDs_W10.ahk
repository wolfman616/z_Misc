;Windows 10 CLSID Locations ; bug with png alpha channel in context menus
;#notrayicon
global cl, clsid, varr
gosub vars

OnMessage(0x203,  "WM_LBUTTONDBLCLK")
OnMessage(0x204,  "WM_RBUTTONDOWN")

for, index, element in cl
	if  !ss
		 ss:= index
	else SS:= SS . "|" . index
h:=1150, w:=285, x:=3555, y:=52
gui, 	clsids: New, -DPIScale +toolwindow -SysMenu +AlwaysOnTop, MwMain
gui, 	clsids: -Caption +LastFound +HwndMainhWnd
Gui, 	clsids: Font, s10,% "Continuum light"
Gui,    clsids: Add,  listbox, w285 x0    r46   vClsid,%          SS
Gui,    clsids: Add,  button,  w100 x168  y1095 ghidies,%         "Hide"
Gui,    clsids: Add,  button,  w120 x14   y1095 default gOkies, % "Open Loc"
Gui,    clsids: Show, x%x% y%y% w%w% h%h%
return

WM_LBUTTONDBLCLK(wParam, lParam) {
    if A_GuiControl              {
		Gui, clsids: Submit, NoHide
		run,% (asas:= "explorer shell:::" . cl[Clsid])
}	}

WM_RBUTTONDOWN(wParam, lParam) {
    if A_GuiControl            {
		send, {lbutton}
		Gui,  clsids: Submit, NoHide
		Menu, Menu1,  Add,%  "Copy ClassID", copyclsid
		Menu, Menu1,  icon,% "Copy ClassID", % "HBITMAP:*" Copy_24 
		Menu, Menu1,  Add,%  "Create &Shortcut", createlnk
		Menu, Menu1,  icon,% "create &shortcut", % "HBITMAP:*" PSHTCT2
		Menu, Menu1,  Add,% "Remove from list", removeclsid
		Menu, Menu1,  icon,% "Remove from list", % "HBITMAP:*" recycle24shadow 
		Menu, Menu1,  Add,% "Exit", GuiClose
		Menu, Menu1,  icon,% "Exit", % "HBITMAP:*" delete_button_24
		Menu, Menu1,  Show
}	}

Png2hBitmap(base64input, NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap     := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 3864 << !!A_IsUnicode)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &base64input, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &base64input, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}
vars:
cl:= []
cl["3D Objects (folder)"]                           := "{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
cl["Add Network Location"]                          := "{D4480A50-BA28-11d1-8E75-00C04FA31A86}"
cl["Administrative Tools"]                          := "{D20EA4E1-3957-11d2-A40B-0C5020524153}"
cl["Applications"]                                  := "{4234d49b-0245-4df3-b780-3893943456e1}"
cl["AutoPlay"]                                      := "{9C60DE1E-E5FC-40f4-A487-460851A8D915}"
cl["Backup and Restore (Windows 7)"]                := "{B98A2BEA-7D42-4558-8BD1-832F41BAC6FD}"
cl["BitLocker Drive Encryption"]                    := "{D9EF8727-CAC2-4e60-809E-86F80A666C91}"
cl["Bluetooth Devices"]                             := "{28803F59-3A75-4058-995F-4EE5503B023C}"
cl["Color Management"]                              := "{B2C761C6-29BC-4f19-9251-E6195265BAF1}"
cl["Command Folder"]                                := "{437ff9c0-a07f-4fa0-af80-84b6c6440a16}"
cl["Common Places FS Folder"]                       := "{d34a6ca6-62c2-4c34-8a7c-14709c1ad938}"
cl["Control Panel"]                                 := "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}"
cl["Control Panel (All Tasks)"]                     := "{ED7BA470-8E54-465E-825C-99712043E01C}"
cl["Control Panel (always Category view)"]          := "{26EE0668-A00A-44D7-9371-BEB064C98683}"
cl["Appearance and Personalization"]                := "{26EE0668-A00A-44D7-9371-BEB064C98683}\1"
cl["Clock and Region"]                              := "{26EE0668-A00A-44D7-9371-BEB064C98683}\6"
cl["Ease of Access"]                                := "{26EE0668-A00A-44D7-9371-BEB064C98683}\7"
cl["Hardware and Sound"]                            := "{26EE0668-A00A-44D7-9371-BEB064C98683}\2"
cl["Network and Internet"]                          := "{26EE0668-A00A-44D7-9371-BEB064C98683}\3"
cl["Programs"]                                      := "{26EE0668-A00A-44D7-9371-BEB064C98683}\8"
cl["System and SecurityI"]                          := "{26EE0668-A00A-44D7-9371-BEB064C98683}\5"
cl["System and SecurityII"]                         := "{26EE0668-A00A-44D7-9371-BEB064C98683}\10"
cl["User Accounts"]                                 := "{26EE0668-A00A-44D7-9371-BEB064C98683}\9"
cl["Control Panel (always Icons view)"]             := "{21EC2020-3AEA-1069-A2DD-08002B30309D}"
cl["Credential Manager"]                            := "{1206F5F1-0569-412C-8FEC-3204630DFB70}"
cl["Date and Time"]                                 := "{E2E7934B-DCE5-43C4-9576-7FE4F75E7480}"
cl["Default Programs"]                              := "{17cd9488-1228-4b2f-88ce-4298e93e0966}"
cl["Default Apps page in Settings"]                 := "{17cd9488-1228-4b2f-88ce-4298e93e0966}\pageDefaultProgram"
cl["Default Apps page in SettingsII"]               := "{17cd9488-1228-4b2f-88ce-4298e93e0966}\pageFileAssoc"
cl["delegate folder that appears in Computer"]      := "{b155bdf8-02f0-451e-9a26-ae317cfd7779}"
cl["Desktop (folder)"]                              := "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"
cl["Device Manager"]                                := "{74246bfc-4c96-11d0-abef-0020af6b0b7a}"
cl["Devices and Printers"]                          := "{A8A91A66-3A7D-4424-8D24-04E180695C7A}"
cl["Documents (folder)I"]                           := "{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}"
cl["Documents (folder)II"]                          := "{d3162b92-9365-467a-956b-92703aca08af}"
cl["Downloads (folder)I"]                           := "{088e3905-0323-4b02-9826-5d99428e115f}"
cl["Downloads (folder)II"]                          := "{374DE290-123F-4565-9164-39C4925E467B}"
cl["Ease of Access Center"]                         := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}"
cl["Use the computer without a display"]            := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageNoVisual"
cl["Make the computer easier to see"]               := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageEasierToSee"
cl["Use the computer without a mouse or keyboard"]  := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageNoMouseOrKeyboard"
cl["Make the mouse easier to use"]                  := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageEasierToClick"
cl["Set up Mouse Keys"]                             := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageMouseKeysSettings"
cl["Make the keyboard easier to use"]               := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageKeyboardEasierToUse"
cl["Use text or visual alternatives for sounds"]    := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageEasierWithSounds"
cl["Make it easier to focus on tasks"]              := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageEasierToReadAndWrite"
cl["Set up Filter Keys"]                            := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageFilterKeysSettings"
cl["Set up Sticky Keys"]                            := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageStickyKeysSettings"
cl["Get recommendations to make your computer easier to use (cognitive)"] := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageQuestionsCognitive"
cl["Get recommendations to make your computer easier to use (eyesight)"]  := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageQuestionsEyesight"
cl["Set up Repeat and Slow Keys"]                   := "{D555645E-D4F8-4c29-A827-D93C859C4F2A}\pageRepeatRateSlowKeysSettings"
cl["E-mail (default e-mail program)"]               := "{2559a1f5-21d7-11d4-bdaf-00c04f60b9f0}"
cl["Favorites"]                                     := "{323CA680-C24D-4099-B94D-446DD2D7249E}"
cl["File Explorer Options"]                         := "{6DFD7C5C-2451-11d3-A299-00C04F8EF6AF}"
cl["File History"]                                  := "{F6B6E965-E9B2-444B-9286-10C9152EDBC5}"
cl["Folder Options"]                                := "{6DFD7C5C-2451-11d3-A299-00C04F8EF6AF}"
cl["Font Settings"]                                 := "{93412589-74D4-4E4E-AD0E-E0CB621440FD}"
cl["Fonts (folder)"]                                := "{BD84B380-8CA2-1069-AB1D-08000948F534}"
cl["Frequent folders"]                              := "{3936E9E4-D92C-4EEE-A85A-BC16D5EA0819}"
cl["Games Explorer"]                                := "{ED228FDF-9EA8-4870-83b1-96b02CFE0D52}"
cl["Get Programs"]                                  := "{15eae92e-f17a-4431-9f28-805e482dafd4}"
cl["Help and Support"]                              := "{2559a1f1-21d7-11d4-bdaf-00c04f60b9f0}"
cl["Hyper-V Remote File Browsing"]                  := "{0907616E-F5E6-48D8-9D61-A91C3D28106D}"
cl["Indexing Options"]                              := "{87D66A43-7B11-4A28-9811-C86EE395ACF7}"
cl["Infared (if installed)"]                        := "{A0275511-0E86-4ECA-97C2-ECD8F1221D08}"
cl["Installed Updates"]                             := "{d450a8a1-9568-45c7-9c0e-b4f9fb4537bd}"
cl["Intel Rapid Storage Technology (if installed)"] := "{E342F0FE-FF1C-4c41-BE37-A0271FC90396}"
cl["Internet Options (Internet Explorer)"]          := "{A3DD4F92-658A-410F-84FD-6FBBBEF2FFFE}"
cl["Keyboard Properties"]                           := "{725BE8F7-668E-4C7B-8F90-46BDB0936430}"
cl["Libraries"]                                     := "{031E4825-7B94-4dc3-B131-E946B44C8DD5}"
cl["Location Information (Phone and Modem Control Panel)"] := "{40419485-C444-4567-851A-2DD7BFA1684D}"
cl["Location Settings"]                             := "{E9950154-C418-419e-A90A-20C5287AE24B}"
cl["Media Servers"]                                 := "{289AF617-1CC3-42A6-926C-E6A863F0E3BA}"
cl["Mouse Properties"]                              := "{6C8EEC18-8D75-41B2-A177-8831D59D2D50}"
cl["Music (folder)I"]                               := "{1CF1260C-4DD0-4ebb-811F-33C572699FDE}"
cl["Music (folder)II"]                              := "{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"
cl["My Documents"]                                  := "{450D8FBA-AD25-11D0-98A8-0800361B1103}"
cl["netplwiz"]                                      := "{7A9D77BD-5403-11d2-8785-2E0420524153}"
cl["Network"]                                       := "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
cl["Network and Sharing Center"]                    := "{8E908FC9-BECC-40f6-915B-F4CA0E70D03D}"
cl["Advanced sharing settings"]                     := "{8E908FC9-BECC-40f6-915B-F4CA0E70D03D}\Advanced"
cl["Media streaming options"]                       := "{8E908FC9-BECC-40f6-915B-F4CA0E70D03D}\ShareMedia"
cl["Network Connections"]                           := "{7007ACC7-3202-11D1-AAD2-00805FC1270E}"
cl["Network Connections II" ]                       := "{992CFFA0-F557-101A-88EC-00DD010CCC48}"
cl["Network (WorkGroup)"]                           := "{208D2C60-3AEA-1069-A2D7-08002B30309D}"
cl["Notification Area Icons"]                       := "{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}"
cl["NVIDIA Control Panel (if installed)"]           := "{0bbca823-e77d-419e-9a44-5adec2c8eeb0}"
cl["Offline Files Folder"]                          := "{AFDB1F70-2A4C-11d2-9039-00C04F8EEB3E}"
cl["OneDrive"]                                      := "{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
cl["Pen and Touch"]                                 := "{F82DF8F7-8B9F-442E-A48C-818EA735FF9B}"
cl["Personalization"]                               := "{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}"
cl["Color and Appearance"]                          := "{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}\pageColorization"
cl["Desktop Background"]                            := "{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}\pageWallpaper"
cl["Pictures (folder)I"]                            := "{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"
cl["Pictures (folder)II"]                           := "{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}"
cl["Portable Devices"]                              := "{35786D3C-B075-49b9-88DD-029876E11C01}"
cl["Power Options"]                                 := "{025A5937-A6BE-4686-A844-36FE4BEC8B6D}"
cl["Create a power plan"]                           := "{025A5937-A6BE-4686-A844-36FE4BEC8B6D}\pageCreateNewPlan"
cl["Edit Plan Settings"]                            := "{025A5937-A6BE-4686-A844-36FE4BEC8B6D}\pagePlanSettings"
cl["System Settings"]                               := "{025A5937-A6BE-4686-A844-36FE4BEC8B6D}\pageGlobalSettings"
cl["Previous Versions Results Folder"]              := "{f8c2ab3b-17bc-41da-9758-339d7dbf2d88}"
cl["printhood delegate folder"]                     := "{ed50fc29-b964-48a9-afb3-15ebb9b97f36}"
cl["Printers I"]  									:= "{2227A280-3AEA-1069-A2DE-08002B30309D}"
cl["Printers II"] 									:= "{863aa9fd-42df-457b-8e4d-0de1b8015c60}"
cl["Problem Reporting Settings"]                    := "{BB64F8A7-BEE7-4E1A-AB8D-7D8273F7FDB6}\pageSettings"
cl["Programs and Features"]                         := "{7b81be6a-ce2b-4676-a29e-eb907a5126c5}"
cl["Public (folder)"]                               := "{4336a54d-038b-4685-ab02-99bb52d3fb8b}"
cl["Quick access"]                                  := "{679f85cb-0220-4080-b29b-5540cc05aab6}"
cl["Recent folders"]                                := "{22877a6d-37a1-461a-91b0-dbda5aaebc99}"
cl["Recent files"]                                  := "{4564b25e-30cd-4787-82ba-39e73a750b14}"
cl["Recovery"]                                      := "{9FE63AFD-59CF-4419-9775-ABCC3849F861}"
cl["Recycle Bin"]                                   := "{645FF040-5081-101B-9F08-00AA002F954E}"
cl["Region"]                                        := "{62D8ED13-C9D0-4CE8-A914-47DD628FB1B0}"
cl["Reliability Monitor"]                           := "{BB64F8A7-BEE7-4E1A-AB8D-7D8273F7FDB6}\pageReliabilityView"
cl["Remote Assistance"]                             := "{C58C4893-3BE0-4B45-ABB5-A63E4B8C8651}\raPage"
cl["RemoteApp and Desktop Connections"]             := "{241D7C96-F8BF-4F85-B01F-E2B043341A4B}"
cl["Connection Properties"]                         := "{241D7C96-F8BF-4F85-B01F-E2B043341A4B}\PropertiesPage"
cl["Remote Printers"]                               := "{863aa9fd-42df-457b-8e4d-0de1b8015c60}"
cl["Removable Drives"]                              := "{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
cl["Removable Storage Devices"]                     := "{a6482830-08eb-41e2-84c1-73920c2badb9}"
﻿﻿cl["Results Folder"]                                := "{2965e715-eb66-4719-b53f-1672673bbefa}"
cl["Run"] 											:= "{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}"
cl["Search (File Explorer)"]                        := "{9343812e-1c37-4a49-a12e-4b2d810d956b}"
cl["Search (Windows)"]                              := "{2559a1f8-21d7-11d4-bdaf-00c04f60b9f0}"
cl["Security and Maintenance"]                      := "{BB64F8A7-BEE7-4E1A-AB8D-7D8273F7FDB6}"
cl["Advanced Problem Reporting Settings"]           := "{BB64F8A7-BEE7-4E1A-AB8D-7D8273F7FDB6}\pageAdvSettings"
cl["Change Security and Maintenance settings"]      := "{BB64F8A7-BEE7-4E1A-AB8D-7D8273F7FDB6}\Settings"
cl["Problem Details"]                               := "{BB64F8A7-BEE7-4E1A-AB8D-7D8273F7FDB6}\pageReportDetails"
cl["Problem Reporting Settings"]                    := "{BB64F8A7-BEE7-4E1A-AB8D-7D8273F7FDB6}\pageSettings"
cl["Problem Reports"]                               := "{BB64F8A7-BEE7-4E1A-AB8D-7D8273F7FDB6}\pageProblems"
cl["Reliability Monitor"]                           := "{BB64F8A7-BEE7-4E1A-AB8D-7D8273F7FDB6}\pageReliabilityView"
cl["Set Program Access and Computer Defaults"]      := "{2559a1f7-21d7-11d4-bdaf-00c04f60b9f0}"
cl["Show Desktop"]                                  := "{3080F90D-D7AD-11D9-BD98-0000947B0257}"
cl["Sound"] 										:= "{F2DDFC82-8F12-4CDD-B7DC-D4FE1425AA4D}"
cl["Speech Recognition"]                            := "{58E3C745-D971-4081-9034-86E34B30836A}"
cl["Storage Spaces"]                                := "{F942C606-0914-47AB-BE56-1321B8035096}"
cl["Sync Center"]                                   := "{9C73F5E5-7AE7-4E32-A8E8-8D23B85255BF}"
cl["Sync Setup"]                                    := "{9C73F5E5-7AE7-4E32-A8E8-8D23B85255BF}\::{F1390A9A-A3F4-4E5D-9C5F-98F3BD8D935C}"
cl["Sync Setup Folder"]                             := "{2E9E59C0-B437-4981-A647-9C34B9B90891}"
cl["System"]                                        := "{BB06C0E4-D293-4f75-8A90-CB05B6477EEE}"
cl["System Icons"]                                  := "{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}\SystemIcons"
cl["System Restore"]                                := "{3f6bc534-dfa1-4ab4-ae54-ef25a74e0107}"
cl["Tablet PC Settings"]                            := "{80F3F1D5-FECA-45F3-BC32-752C152E456E}"
cl["Task View"]                                     := "{3080F90E-D7AD-11D9-BD98-0000947B0257}"
cl["Taskbar and Navigation properties"]             := "{0DF44EAA-FF21-4412-828E-260A8728E7F1}"
cl["Taskbar page in Settings"]                      := "{0DF44EAA-FF21-4412-828E-260A8728E7F1}"
cl["Text to Speech"]                                := "{D17D1D6D-CC3F-4815-8FE3-607E7D5D10B3}"
cl["This Device"]                                   := "{5b934b42-522b-4c34-bbfe-37a3ef7b9c90}"
cl["This PC"]                                       := "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
cl["Troubleshooting"]                               := "{C58C4893-3BE0-4B45-ABB5-A63E4B8C8651}"
cl["Additional Information"]                        := "{C58C4893-3BE0-4B45-ABB5-A63E4B8C8651}\resultPage"
cl["All Categories"]                                := "{C58C4893-3BE0-4B45-ABB5-A63E4B8C8651}\listAllPage"
cl["Change Settings"]                               := "{C58C4893-3BE0-4B45-ABB5-A63E4B8C8651}\settingPage"
cl["History"]                                       := "{C58C4893-3BE0-4B45-ABB5-A63E4B8C8651}\historyPage"
cl["Search Troubleshooting"]                        := "{C58C4893-3BE0-4B45-ABB5-A63E4B8C8651}\searchPage"
cl["Troubleshoot problems - Hardware and Sound"]    := "{C58C4893-3BE0-4B45-ABB5-A63E4B8C8651}\devices"
cl["Troubleshoot problems - Network and Internet"]  := "{C58C4893-3BE0-4B45-ABB5-A63E4B8C8651}\network"
cl["Troubleshoot problems - Programs"]              := "{C58C4893-3BE0-4B45-ABB5-A63E4B8C8651}\applications"
cl["Troubleshoot problems - System and Security"]   := "{C58C4893-3BE0-4B45-ABB5-A63E4B8C8651}\system"
cl["User Accounts"]                                 := "{60632754-c523-4b62-b45c-4172da012619}"
cl["Change Your Name"]                              := "{60632754-c523-4b62-b45c-4172da012619}\pageRenameMyAccount"
cl["Manage Accounts"]                               := "{60632754-c523-4b62-b45c-4172da012619}\pageAdminTasks"
cl["User Accounts (netplwiz)"]                      := "{7A9D77BD-5403-11d2-8785-2E0420524153}"
cl["User Pinned"]                                   := "{1f3427c8-5c10-4210-aa03-2ee45287d668}"
cl["%UserProfile%"]                                 := "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
cl["Videos (folder)I"]                              := "{A0953C92-50DC-43bf-BE83-3742FED03C9C}"
cl["Videos (folder)II"]                             := "{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"
cl["Web browser (default)"]                         := "{871C5380-42A0-1069-A2EA-08002B30309D}"
cl["Windows Defender Firewall"]                     := "{4026492F-2F69-46B8-B9BF-5654FC07E423}"
cl["Allowed apps"]                                  := "{4026492F-2F69-46B8-B9BF-5654FC07E423}\pageConfigureApps"
cl["Customize Settings"]                            := "{4026492F-2F69-46B8-B9BF-5654FC07E423}\PageConfigureSettings"
cl["Restore defaults"]                              := "{4026492F-2F69-46B8-B9BF-5654FC07E423}\PageRestoreDefaults"
cl["Windows Mobility Center"]                       := "{5ea4f148-308c-46d7-98a9-49041b1dd468}"
cl["Windows Features"]                              := "{67718415-c450-4f3c-bf8a-b487642dc39b}"
cl["Windows To Go"]                                 := "{8E0C279D-0BD1-43C3-9EBD-31C3DC5B8A77}"
cl["Work Folders"]                                  := "{ECDB0924-4208-451E-8EE0-373C0956DE16}"

delete_button_24o :="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"

recycle24shadowo := "AAABAAEAGBgAAAEAIACICQAAFgAAACgAAAAYAAAAMAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACcAtUAnALVAJwC1QAAAAAnAAAAYwAAAHgAAAB4AAAAeAAAAHgAAAB4AAAAeAAAAHgAAAEPAAAAfEYBYoRwAZqVAAAAZAAAAFoAAABaAAAAUgAAABecAtUAnALVAJwC1QCcAtUAnALVAAAAAB4AAAB7AAAAgQAAAIMAAACDAAAAgwAAAIMAAACDAAAAgwAAAIMAAABMAAAAg50D1cJ7AqmiAAAAgQAAAIAAAACAAAAAfwAAAHIBAAEInALVAJwC1QCcAtUAnALVAAAAAFwAAACDTwFsrGkCjupuApX/bgKV/24Clf9uApX/bgKV/wAAAIMAAAB/XQGBk7sE/v6zBPPorwPu4K8D7uCrA+jYbgGXmgAAAIIAAABKnALVAJwC1QCcAtUAAAAAHgAAAIBGAWGibgKV/24Clf9uApX/bgKV/24Clf9uApX/bgKV/wAAAIMAAACDpgPi0LwE//+8BP//vAT//7wE//+8BP//uQT790QAX4sAAAB/AAAAHpwC1QCcAtUAAAAAXAAAAIN0Ap7gbgKV/24Clf9uApX/bgKV/24Clf9uApX/bgKV/wAAAIN7AqmivAT//7wE//+8BP//vAT//7wE//+8BP//vAT//6YD4c8AAACDAAAAZZwC1QAAAAAeAAAAgHsCqaKQA8T/bgKV/24Clf9uApX/bgKV/24Clf9uApX/bgKV/wAAAIOOAsKyvAT//7wE//+8BP//vAT//7wE//+8BP//vAT//7wE//97AqmiAAAAgQAAADgAAABgAAAAg68D7uCtBOr/bgKV/24Clf9uApX/bgKV/24Clf9uApX/bgKV/wAAAIMAAAB0tgT377wE//+8BP//vAT//7wE//+8BP//vAT//7wE//+zBPPpAAAAgwAAAHUAAACBewKporwE//+8BP//jwPB/24Clf9uApX/bgKV/24Clf9uApX/bgKV/wAAAIMAAAAyhgK3rLwE//+8BP//vAT//7wE//+8BP//vAT//7wE//+8BP//mAPOvQAAAIIAAACDsAPv47wE//+8BP//tgT39T0BVZc8AVSPVgF2RlYBdkZWAXZGWwF9PwAAAB0BAAIEAAAAZrIE8duDArSNAAAAKQAAAIMoADmMbAKT924Clf9uApX/gAKu90YBYpGGAreqvAT//7wE//+8BP//vAT//5sD078AAACCAAAAYAAAAGAAAAAeAwAFAgMABQKcAtUAAAAAJ58D2F2fA9hdAAAAXAAAAINhAoTQbgKV/24Clf9uApX/bgKV/2QCh9atA+zevAT//7wE//+8BP//vAT//7kE+/dEAF+LAAAAgX4Cq4gAAAAenALVAJwC1QCcAtUAAgADAwAAAQpzAZ4vAAAAgDkBT5ZuApX/bgKV/24Clf9uApX/bgKV/24Clf+rA+jYvAT//7wE//+8BP//vAT//7wE//+rA+nasQTw5H0Cq4oAAAAenALVAJwC1QCcAtUAnALVAAYADAEAAABLAAAAg2YCi+BuApX/bgKV/24Clf9uApX/bgKV/2oCkPBqAZKYvAT//7wE//+8BP//vAT//7wE//+8BP//pgPhzwAAAFMCAAMDnALVAJwC1QCcAtUAnALVAJwC1QAAAABPRgFhom4Clf9uApX/bgKV/24Clf9uApX/bgKV/1gBeLsAAABgowPdzLwE//+8BP//vAT//7wE//+5BPv3RgFihAAAAD4AAAA3AAAAJJwC1QCcAtUAnALVAJwC1QAAAABPYAKDzm4Clf9uApX/bgKV/24Clf9uApX/agKQ7wAAAHQAAABdhgK3qrwE//+8BP//vAT//7wE//+WAsy6AAAAggAAAH0AAAB9AAAAbAAAACAAAABpAAAAaQAAAGkAAABuAAAAZVQBc65sApP3bgKV/24Clf9uApX/TgFrrAAAADGWA8ycrQPr0K0D69CtA+vQrQPr0qcD4tQAAACDAAAAg1kBebxLAWeoAAAAggAAADAAAABzAAAAegAAAIIAAACCAAAAgAAAAIIkADSLXgGAyW4Clf9mAovgAAAAZQEAAgQBAAEIAQABCAEAAQgAAABiAAAAgAAAAINKAWenagKQ724Clf9qApDvAAAAgwAAAG2DArOZtgT377UE9e6vA+7grwPu4K8D7uBdAYGTAAAAg1YBdlJYAXlMAAAAH5wC1QCcAtUAnALVAJwC1QAAAABiPQFVmGYCi+BuApX/bgKV/24Clf9uApX/UgFwsgAAAIIAAAB6AAAAg7kE+/e8BP//vAT//7wE//+rA+nZAAAAgwAAAFwCAAQCAgAEApwC1QCcAtUAnALVAJwC1QAAAABiZgKL4G4Clf9uApX/bgKV/24Clf9uApX/agKQ7xwAKYcAAACCkALDs7wE//+8BP//vAT//7wE//+8BP//ewKpogAAAGIAAAAenALVAJwC1QCcAtUAnALVAJwC1QAAAAAnRgFhom4Clf9uApX/bgKV/24Clf9uApX/bgKV/1oBe8FEAF+LuQT797wE//+8BP//vAT//7wE//+8BP//rwPu4AAAAGIAAAAhnALVAJwC1QCcAtUAnALVAJwC1QACAAMDAAAAWmMCh9RuApX/bgKV/24Clf9uApX/bgKV/2wCk/edA9bLvAT//7wE//+8BP//vAT//7wE//+vA+7gsQTx14UCtogAAAAhnALVAJwC1QCcAtUAnALVAJwC1QCcAtUAAAAAFjQASJNuApX/bgKV/24Clf9uApX/bgKV/34CrP+8BP//vAT//7wE//+8BP//vAT//7wE//9wAZqcAAAAIJUCyi8AAAEQnALVAJwC1QCcAtUAnALVAJwC1QCcAtUAAwAGAQAAAFRgAoLObgKV/24Clf9uApX/bgKV/60E6v+8BP//vAT//7wE//+8BP//vAT//6YD4tAAAABWAgAEAgMABwEDAAcBnALVAJwC1QCcAtUAnALVAJwC1QCcAtUAnALVAAAAAQ4tAD9hYQKE0G4Clf96Aqb/pQPf/7kE+vi3BPjwsATv4bEE8dmyBPHYrgPrzU8BbmcAAAEPnALVAJwC1QCcAtUAnALVAJwC1QDgAAcAwAADAMAAAwCAAAEAgAABAAAAAAAAAAAAAAAAAAAAAAAACAAAADgAAAA8AAAAPgAAAB4AAAAAAAAAAAAAAAABAOAAAQDgAAMA4AADAOAAAwDwAAMA8AADAPgAHwA"

PSHTCT2o := "AAABAAEAGBgAAAEAIACICQAAFgAAACgAAAAYAAAAMAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALWbN/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPXXUP/Lqz7/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANq8RP/dv0b/zaw+/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADDpjv/2btE/+LBRv+vjjL/3b5F/8urPv8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADEqDz/5MZI/93ARv/GqT3/sZAz/6yNMv+2lDT/ooMu/9u+Rf/Jqj3/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuJs3/+bISf/DpTv/l3or/6aHL/+vjTL/r40y/6qJMP+nhi//rIsx/6GCLv/nyUr/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADRtUL/2LhD/6CALf+vjzL/r44y/6+NMv+ujDH/rIsx/6iIMP+mhi//q4sx/9S0Qf/Xt0P/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANCyQP/Orj//rIwx/7OTM/+xkDP/tZQ0/9GzQP/jxEf/58hJ/9i4Qv+0kzP/1LRB/9e3Q/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAN3ARv+ykjP/uJU0/7+eOP/jxEj/38BG/7ubOP8AAAAAAAAAAOLBRv/ZuUL/2LhD/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4MNH/7eWNf+9mjb/27xE/9/ARv8AAAAAAAAAAAAAAAAAAAAAAAAAAPDRTv/ZuUP/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA5MRI/7+cN//kxEf/yKo9/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANa3Q/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA5MRH/96+RP/NrD7/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6MhJ/+bISf8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA7tNO/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwKI6/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8A////AP///wD///8A////AP/9/wD//P8A//x/AP/wPwD/gB8A/gAfAPwAHwD4AD8A+Ax/APB8/wDw/f8A8f//APP//wD3//8A9///AP///wD///8A////AP///wA"

Copy_24o := "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"
global Copy_24 := Png2hBitmap(Copy_24o)
global PSHTCT2 := Png2hBitmap(PSHTCT2o, NewHandle := True)
global recycle24shadow := Png2hBitmap(recycle24shadowo, NewHandle := True)
global delete_button_24 := Png2hBitmap(delete_button_24o, NewHandle := True)
return,

removeclsid:
return,

createlnk:
copyclsid:
clipboard =% cl[Clsid]
return,

GuiClose:
exitApp

Okies:
Gui, clsids: Submit, NoHide
;msgbox, % (asas:= "explorer shell:::" . cl[Clsid])
run,% (asas:= "explorer shell:::" . cl[Clsid])
return

tt((Clsid . "selected"))
run,% asas
return

hidies:
exitapp
Gui, clsids: hide
return