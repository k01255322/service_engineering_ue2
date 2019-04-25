<%@page import="sqliteConnector.sqliteConnection"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
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
<title>LVA anlegen</title>
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

		<%
			// Variablen
			boolean exists = false;

			//Datenbankverbindung
			Connection conn = sqliteConnection.dbConnector();

			String ak_nummer = request.getParameter("ak_nummer");

			String qAk = "SELECT ak_nummer, nachname FROM lehrende_liste";

			String lva_leiter = null;

			String qRaum = "SELECT DISTINCT id FROM raeume";

			Statement stmt = null;

			ResultSet rs = null;

			try {
				stmt = conn.createStatement();
				rs = stmt.executeQuery(qAk);

				while (rs.next()) {
					if (rs.getString(1).equals(ak_nummer)) {
						exists = true;
						lva_leiter = rs.getString(2);
						break;
					}
				}
				rs.close();

				if (exists == true) {

					stmt = conn.createStatement();
					rs = stmt.executeQuery(qRaum);
		%>

		<h3>
			<span class="badge badge-secondary">Formular zum erstellen
				einer LVA</span>
		</h3>

		<form action="lva_insert.jsp" method="post">
			<div class="form-group">
				<label for="titel">LVA Bezeichnung</label> <input type="text"
					class="form-control" name="titel"
					placeholder="z.B. Service Engineering"> <label
					for="lva_nummer">LVA Nummer</label> <input type="text"
					class="form-control" name="lva_nummer" placeholder="z.B. 255.255">
				<label for="ak_nummer">AK-Nummer</label> <input type="text"
					class="form-control" name="ak_nummer" placeholder="z.B. AK1">
				<label for="max_studierende">Max. Anzahl Studierender</label> <input
					type="text" class="form-control" name="max_studierende"
					placeholder="z.B. 100"> <label for="raum">Raum</label> <select
					class="form-control" name="raum">
					<%
						while (rs.next()) {
					%>
					<option><%=rs.getString(1)%></option>
					<%
						}
					%>
				</select> <label for="datum">Datum</label> <input type="text"
					class="form-control" name="datum" placeholder="z.B. 31.12.2019">
				<label for="von">Uhrzeit von</label> <input type="text"
					class="form-control" name="von" placeholder="z.B. 10:00"> <label
					for="bis">Uhrzeit bis</label> <input type="text"
					class="form-control" name="bis" placeholder="z.B. 11:30">
					
					<div class="form-check">
    <input type="checkbox" class="form-check-input" name="woechentlich" data-toggle="tooltip" data-placement="left" title="8 Wochen">
    <label class="form-check-label" for="woechentlich">Wöchentliche LVA</label>
  </div>
			</div>
			<button type="submit" class="btn btn-outline-secondary btn-sm">Einfügen</button>

		</form>
		<%
			} else {
					out.println("Bitte eine gültige AK-Nummer eingeben!");
				}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				if (rs != null) {
					try {
						rs.close();
					} catch (SQLException e) {
						;
					}
					rs = null;
				}
				if (conn != null) {
					try {
						conn.close();
					} catch (SQLException e) {
						;
					}
					conn = null;
				}
			}
		%>

		<br> <br>




	</div>

</body>
</html>