<%
set form = aspl.form

set field = form.field("script")
field.add "text","$.getScript('https://cdn.jsdelivr.net/npm/vue@2.6.11',function(){startVue()});"

set field = form.field("plain")
field.add "html",aspl.loadText("default/html/sampleform28.resx")

form.build

%>