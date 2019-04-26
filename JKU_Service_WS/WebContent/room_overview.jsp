<%@page import="sqliteConnector.sqliteConnection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="java.time.format.DateTimeFormatter"%>
   <%@page import="java.time.LocalDate"%>
    <%@ page import="java.sql.*"%>
    <%@ page import="org.sqlite.*"%>
    <%@ page import="java.util.*"%>
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
<title>Termin_Übersicht</title>
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

		<br>

		<h3>
			<span class="badge badge-secondary"><%= request.getParameter("datum") %> </span>
		</h3>
<table class="table">
            <tr bgcolor = "#949494">
               <th scope="col">Raum</th>
               <th scope="col">Uhrzeit</th>
            </tr>
<% 
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
LocalDate ldatum = LocalDate.parse(request.getParameter("datum"), formatter);
String datum = ldatum.format(formatter);
String raum = request.getParameter("raum");
Connection conn = sqliteConnection.dbConnector();
Statement stat = conn.createStatement();
String service ="SELECT raum,von,bis FROM raum_service" +
        " WHERE raum='"+raum+"'"+"and datum='"+datum+"'";
ResultSet rs1 = stat.executeQuery(service);


while (rs1.next()) {
		   out.print("<tr><td>" + rs1.getString(1) + "</td>\n"); 
		   out.println("<td> " + rs1.getString(2) + "-"+rs1.getString(3)+"</td></tr>\n");
}


%>
</table>
</div>
</body>
</html>