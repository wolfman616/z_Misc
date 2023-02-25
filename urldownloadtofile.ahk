; #persistent
; msgbox % e:= urlDownloadToFile("http://www.google.com/search?q=learn.microsoft.com/en-us/windows/ WM_APP&btnI")
; return,

urlDownloadToFile(url,LocalFile="",userAgent:="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0") {
	global
	splitPath,url,file
	if(!regExMatch(url,"i)https?://"))
		url:="https://" url
	(LocalFile=""?LocalFile:= A_desktop "\shit.bin")
	try,{ 
		hObject:=comObjCreate("WinHttp.WinHttpRequest.5.1")
		hObject.open("GET",url)
		if(userAgent)
			hObject.setRequestHeader("User-Agent",userAgent)
		hObject.send()
		uBytes:= hObject.responseBody
		cLen:= uBytes.maxIndex()
		fileHandle:= fileOpen(LocalFile,"w")
		varSetCapacity(f,cLen,0)
		loop,% cLen+1
			numPut(uBytes[a_index-1],f,a_index-1,"UChar")
		err:= fileHandle.rawWrite(f,cLen+1)
	} catch,e
		return,% e.message
	return,LocalFile
}
 
sURL(url){
	regex.="((https?|ftp)\:\/\/)" 										; SCHEME
	regex.="([a-z0-9+!*(),;?&=\$_.-]+(\:[a-z0-9+!*(),;?&=\$_.-]+)?@)?"	; User and Pass
	regex.="([a-z0-9-.]*)\.([a-z]{2,3})"								; Host or IP
	regex.="(\:[0-9]{2,5})?"											; Port
	regex.="(\/([a-z0-9+\$_-]\.?)+)*\/?" 								; Path
	regex.="(\?[a-z+&\$_.-][a-z0-9;:@&%=+\/\$_.-]*)?" 					; GET Query
	regex.="(#[a-z_.-][a-z0-9+\$_.-]*)?" 								; Anchor
	return,(url ~= "i)" regex)? true : false
}