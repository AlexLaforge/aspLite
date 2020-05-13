<%
'login/logout form, with 3 attempts allowed
set form=aspl.form
form.initialize=false

dim pw : pw = "asplPW"

if aspl.convertBool(session("blockuser")) then blockUser()

if form.postback then
	
	'check CSRF
	if form.sameSession then

		select case aspl.getRequest("btnAction")
		
			case "logout"
		
				session("authorized")=false
			
			case "login"		
			
				if pw=aspl.getRequest("password") then
				
					session("authorized")=true
					session("wrongPWcount")=0
					
				else		
					
					session("wrongPWcount")=aspl.convertNmbr(session("wrongPWcount"))+1
					
					if session("wrongPWcount")=3 then					
						blockUser()
					end if 
					
					set field = form.field("element")
					field.add "tag","div"
					field.add "class","alert alert-warning"
					field.add "html","Password incorrect!"				
					
				end if
		
		end select
		
	end if


end if

if aspl.convertBool(session("authorized")) then

	set field = form.field("element")
	field.add "tag","div"
	field.add "class","alert alert-success"
	field.add "html","You are now authorized!"
	
	set button = form.field("submit")
	button.add "value","Logout"	
	button.add "class","btn btn-secondary"
	button.add "style","margin-top:5px"
	button.add "onclick","return confirm('are you sure?')"
	
	set logout = form.field("hidden")
	logout.add "name","btnAction"
	logout.add "value","logout"
	
else

	set field = form.field("password")
	field.add "name","password"
	field.add "class","form-control"
	field.add "required",true

	set button = form.field("submit")
	button.add "value","Login"
	button.add "class","btn btn-secondary"
	button.add "style","margin-top:5px"
	
	set login = form.field("hidden")
	login.add "name","btnAction"
	login.add "value","login"

end if

form.build

sub blockUser()

	session("blockuser")=true

	set field = form.field("element")
	field.add "tag","div"
	field.add "class","alert alert-danger"
	field.add "html","Three failed attempts<hr>Session is blocked."
	
	form.build

end sub

%>