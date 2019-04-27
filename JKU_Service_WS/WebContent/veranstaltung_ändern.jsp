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
<title>Veranstaltung ändern</title>
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
<form action="veranstaltung_edit.jsp" method="post">
     <input type="hidden" name="id" value= <%= request.getParameter("id")%> >
	<table table class="table table-borderless" style="border-collapse: collapse;display: block;" >
	    <tr>
		<td>Bezeichnung:</td>
		<td><input type="text" name="bez" placeholder ="Bezeichnung"></td>
		</tr>
		<tr>
		<td>Datum:</td>
		<td><input type="text" name="datum" placeholder="z.B. 31.12.2019"></td>
		</tr>
		<tr>
		<td>Uhrzeit von:</td>
		<td><input type="text" name="von" placeholder="z.B. 13:30"></td>
		</tr>
		<tr>
		<td>Uhrzeit bis:</td>
		<td><input type="text" name="bis" placeholder="z.B. 14:45"></td>
		</tr>
		<tr>
		<td>Max Teilnehmeranzahl:</td>
		<td><input type="number" name="maxteilnehmer" placeholder="40"></td>
		</tr>
		<tr>
		<td>Ort:</td>
		<td><input type="text" name="ort" placeholder="HS 1"></td>
		</tr>
		
	</table>
	
	<input class="btn btn-primary" type="submit" value="Ändern">
	</form>
	<br>

</div>
</body>
</html>