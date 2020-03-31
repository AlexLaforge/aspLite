<%

class cls_asp_cdomessage

	public smtpserver,smtpport,sendusing,pickupdir,smtpusername,smtpuserpw,smtpusessl
	
	public receiverEmail,receiverName, subject, body, attachments, fromemail, fromname
	
	private sub class_initialize
		set attachments=server.CreateObject ("scripting.dictionary")
		pickupdir="C:\Inetpub\mailroot\Pickup"
		smtpport=25
		smtpusessl=false
		sendusing=1	
		smtpserver="localhost"
	end sub
	
	Public function send
	
		On Error Resume next
		
		body=wrapInHTML(prepareforEmail(body),subject)
		body=replace(body,">" & vbcrlf &".",">.",1,-1,1)
	
		dim myMail, fileKey	
		set myMail=Server.CreateObject("CDO.Message")
		
		'configuration object
		myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")=smtpserver
		myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=smtpport 
		myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout")=60
		myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")=sendusing
		myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverpickupdirectory") = pickupdir

		if smtpusername<>"" then
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate")=1
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername")=smtpusername
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword")=smtpuserpw
		end if
		
		if smtpusessl then
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
		else
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = False
		end if

		myMail.Configuration.Fields.Update
		myMail.Bodypart.ContentMediaType = "text/html"
		myMail.Bodypart.Charset = "utf-8"
		myMail.Bodypart.ContentTransferEncoding = "quoted-printable"
		myMail.Subject=subject
		myMail.To=receiverName&"<"&receiverEmail&">"
		myMail.From=fromname&"<"& fromemail &">"
		myMail.ReplyTo=fromemail
		
		'attachments
		for each fileKey in attachments
			myMail.AddAttachment attachments(fileKey)
		next 
		
		myMail.HtmlBody=body
		myMail.HTMLBodypart.Charset = "utf-8"
		myMail.send
		
		set MyMail=nothing		
	
		if err.number<>0 then	
			asperror("Something goes wrong when sending emails.")
		end if		
		
		On Error Goto 0
		
	end function
	
	function wrapInHTML(body,subject)
	
		if instr(1,body,"<!doctype html>",vbTextCompare)=0 then
			
			wrapInHTML="<!doctype html>" & vbcrlf
			wrapInHTML=wrapInHTML & "<html>" & vbcrlf & "<head>" & vbcrlf 
			wrapInHTML=wrapInHTML & "<meta HTTP-EQUIV=""Content-Type"" content=""text/html; charset=""utf-8"">"  & vbcrlf 
			wrapInHTML=wrapInHTML & "<title>"& subject &"</title>" & vbcrlf & "</head>" & vbcrlf 
			wrapInHTML=wrapInHTML& "<body>" & vbcrlf & body & vbcrlf & "</body>" & vbcrlf & "</html>" & vbcrlf 
		
		else
		
			wrapInHTML=body
		
		end if
		
	end function
	
	
	function prepareforEmail(value)
	
		prepareforEmail=value
		
		if left(trim(prepareforEmail),1)<>"<" then
			prepareforEmail="<div>" & prepareforEmail & "</div>"
		end if		
				
	end function
	
end class

%>
