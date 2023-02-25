; msgbox,% Googlelucky("https://www.google.com/url?q=https://learn.microsoft.com/en-us/training/")
; return,

Googlelucky(SearchTerm="",UA="",RedirectDtect="",openbrowser="") { ;DeFault TRUE
	loop,parse,% "UA,RedirectDtect",`,
		(%a_loopfield%):= (%RedirectDtect%=""? True : False)
		(ua=1?	ua:="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36")
	wb:= ComObjCreate("WinHttp.WinHttpRequest.5.1")
	regX:="(https:\/\/(windows\/win32)+[^\(?:\&)]*[" chr(34) "]*)"

	tern:= (quote(SearchTerm) )
	LuckySuRL:=("http://www.google.com/search?q=" . tern . "&btnI")
	if(!RedirectDtect){
	msgbox cyunt
		run,% LuckySuRL
		return,

 

	}
	msgbox % ua "`n " LuckySuRL
	
	try,{
		wb.open("GET",LuckySuRL) 
		if(ua!=1)
			wb.SetRequestHeader("User-Agent",UA)
		wb.Send()
		wb.WaitForResponse()
		clipboard:=pm:= wb.ResponseText
		try,{
			RegeXmatch(pm,regX,Lucky1stResult)
			if(Lucky1stResult) {
				run,% Lucky1stResult
				msgbox % Lucky1stResult
				}
			return,Lucky1stResult? Lucky1stResult : LuckySuRL
		}
	} catch,e
		return,% e.message
}	;    ------========================> below was initial goal to implement but some people didnt know how to make reqs
/*  - STEP_NAME                          ; String := File.Read(_______SidegayZ__u______uttr_______) ; b3LL
      call: HTTP_REQUEST                 	; try{ ; only way to properly protect from an error here
      args:                              	; createFormData(rData,rHeader,data) ; formats & stores the data, rHeader header info,
          url: URL_VALUE                 	; hObject:=comObjectCreate("WinHttp.WinHttpRequest.5.1") ; create WinHttp object
          method: REQUEST_METHOD         	; hObject.setRequestHeader("Content-Type",rHeader) ; set content header
          headers:                       	; hObject.open("POST",endpoint) ; open a post event to the specified endpoint
              HEADER_KEY:HEADER_VALUE    	; hObject.send(rData) ; send request with data
          body:                          	;;you can get the response data either in raw or text format
              BODY_KEY:BODY_VALUE        	;;raw:  hObject.responseBody
          query:                             ;;text: hObject.responseText	                          
              QUERY_KEY:QUERY_VALUE      ; }catch e{                                                 
		  auth:                          	; msgbox,% e.message                                     
              type: AUTH_TYPE            ; }                                                        ; 3nd
              scope: AUTH_SCOPE
              scopes: AUTH_SCOPE
              audience: AUDIENCE
          timeout: TIMEOUT_IN_SECONDS
      result: RESULT_VALUE 
*/