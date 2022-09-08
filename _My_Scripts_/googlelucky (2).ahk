googlelucky(searchterm) {
	regx:="(https:\/\/[^\" 
	regx= %regx%"]*)
	poo="
	endpoint=http://www.google.com/search?q=%searchterm%&btnI ; url pointing to the API endpoint
	UrlDownloadToFile, %endpoint%, html
	if fileexist(penis:=(A_ScriptDir . "\html"))
	Fileread, html, %penis%
	FileRecycle,% html
	result:=regexmatch(html,regx,luckyendpoint)
	;run %luckyendpoint%
	return, luckyendpoint
}


/*  - STEP_NAME

:
      call: HTTP_REQUEST


      args:
          url: URL_VALUE


          method: REQUEST_METHOD


          headers:
              HEADER_KEY

:HEADER_VALUE


              ...
          body:
              BODY_KEY

:BODY_VALUE


              ...
          query:
              QUERY_KEY

:QUERY_VALUE


              ...
          auth:
              type: AUTH_TYPE


              scope: AUTH_SCOPE


              scopes: AUTH_SCOPE


              audience: AUDIENCE


          timeout: TIMEOUT_IN_SECONDS


      result: RESULT_VALUE */


	;String := File.Read(penis)

; try{ ; only way to properly protect from an error here
	; createFormData(rData,rHeader,data) ; formats the data, stores in rData, header info in rHeader
	; hObject:=comObjectCreate("WinHttp.WinHttpRequest.5.1") ; create WinHttp object
	; hObject.setRequestHeader("Content-Type",rHeader) ; set content header
	; hObject.open("POST",endpoint) ; open a post event to the specified endpoint
	; hObject.send(rData) ; send request with data

	;;you can get the response data either in raw or text format
	;;raw: hObject.responseBody
;;	text: hObject.responseText	
; }catch e{
	; msgbox,% e.message
; }