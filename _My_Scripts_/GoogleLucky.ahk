Googlelucky(SearchTerm) {
	regX:="(https:\/\/[^\(?:\&)" 
	regX = %regx%"]*)
	Dlim=";BeloWme!  ;        uRL      ; (to the Lucky End-point!)       '()
	LuckyURL:=("http://www.google.com/search?q=" . SearchTerm . "&btnI") 
	UrlDownloadToFile,%  LuckyURL,html ; temp.html-File- ; nc (method)! =`(
	try,   Fileexist(    tUNC:=(A_ScriptDir . "\html"))    ; temp.universal-name-conventioned Path-Variable
	try,   Fileread,     html,%    tUNC
	try,   RegeXmatch(   html,regX,LuckyEndPoint)
	try,   FileRecycle,% html
	       Return,       LuckyEndPoint ; ( Definitely! ) 
}     ;    ------========================> below was initial goal to implement but someone didnt remeber how to make reqs
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