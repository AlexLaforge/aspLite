<%
'the functions below are not part of aspLite. But they are used in code/demo_asp/jqueryui.asp (jQuery IO Datepicker)
'they are rather specific to use with the jQuery Datepicker. You can extend this list of functions as you wish.

'select a date-format
dim dateformat
dateformat="dd/mm/yy" 'or mm/dd/yy see function dateFromPicker - you can add more - see https://jqueryui.com/datepicker/

function dateFromPicker(theDate)

	on error resume next
	
	if not aspL.isEmpty(theDate) then
	
		dim arrDate
		arrDate=split(theDate,"/")
		
		select case dateformat
		
			case "dd/mm/yy" : dateFromPicker=dateserial(arrDate(2),arrDate(1),arrDate(0))
				
			case "mm/dd/yy" : dateFromPicker=dateserial(arrDate(2),arrDate(0),arrDate(1))
				
		end select
	
	else
	
		dateFromPicker=""
		
	end if
	
	if err.number<>0 then
		dateFromPicker=""
	end if
	
	on error goto 0
	
end function

function dateToPicker(theDate)
	
	on error resume next 

	if not aspL.isEmpty(theDate) then
	
		select case dateformat
		
			case "dd/mm/yy" : dateToPicker=aspl.padLeft(day(theDate),2,0) & "/" & aspl.padLeft(month(theDate),2,0) & "/" & year(theDate)
				
			case "mm/dd/yy" : dateToPicker=aspl.padLeft(month(theDate),2,0) & "/" & aspl.padLeft(day(theDate),2,0) & "/" & year(theDate)
				
		end select
		
	else
		dateToPicker=""
	end if
	
	if err.number<>0 then
		dateToPicker=""
	end if
	
	on error goto 0
	
end function


%>