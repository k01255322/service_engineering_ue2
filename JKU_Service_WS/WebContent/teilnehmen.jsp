<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
	integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
	crossorigin="anonymous">
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta charset="ISO-8859-1">
<title>Teilnahme</title>
</head>
<body>
<div class="container">
<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<a class="navbar-brand" href="index.html">Hauptmenü</a> <a
				class="navbar-brand" href="lva_service.html">LVA Service</a> <a
				class="navbar-brand" href="prüfungsservice.html">Prüfungsservice</a>
			<a class="navbar-brand" href="raumservice.html">Raumservice</a> <a
				class="navbar-brand" href="veranstaltungsservice.html">Veranstaltungsservice</a>
		</nav>
<form action="teilnahme.jsp" method="post">
     <input type="hidden" name="vid" value= <%= request.getParameter("vid")%> >
	<table table class="table table-borderless" style="border-collapse: collapse;display: block;" >
	    <tr>
		<td>Vorname:</td>
		<td><input type="text" name="vname" placeholder ="Vorname"></td>
		</tr>
		<tr>
		<td>Nachname:</td>
		<td><input type="text" name="nname" placeholder="Nachname"></td>
		</tr>
		
	</table>
	
	<input class="btn btn-primary" type="submit" value="teilnehmen">
	</form>
	<br>

</div>
</body>
</html>