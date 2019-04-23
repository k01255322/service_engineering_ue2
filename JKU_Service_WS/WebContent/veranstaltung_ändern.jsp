<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Veranstaltung ändern</title>
</head>
<body>
<form action="veranstaltung_edit.jsp" method="post">
     <input type="hidden" name="id" value= <%= request.getParameter("id")%> >
	<table border=0>
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
		<td><input type="text" name="ort" placeholder="HS_1"></td>
		</tr>
		
	</table>
	
	<input type="submit" value="Ändern">
	</form>
	<br>
	<a href= "index.html">Hauptmenü</a>
</body>
</html>