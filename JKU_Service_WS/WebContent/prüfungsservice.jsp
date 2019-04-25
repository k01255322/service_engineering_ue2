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
<title>Prüfungsservice</title>
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
			<span class="badge badge-secondary">Prüfungsanmeldung</span>
		</h3>

	<%
		// Variablen
		boolean existsMatrikel = false;
		boolean existsPrüfung = false;

		//Datenbankverbindung
		Connection conn = sqliteConnection.dbConnector();

		String matrikelnummer = request.getParameter("matrikelnummer");

		String qStudent = "SELECT matrikelnummer FROM studenten_liste";

		String test = "SELECT p.lva_titel, p.lva_nummer, p.datum, p.von, p.bis, p.ort, p.anzahl_plaetze, p.anmeldungen FROM pruefungs_service p"
				+ " LEFT JOIN studenten_lva_anmeldungen ON p.lva_nummer=studenten_lva_anmeldungen.lva_nummer WHERE studenten_lva_anmeldungen.matrikelnummer=?";

		Statement stm = null;
		PreparedStatement pstm = null;
		ResultSet rs = null;
		ResultSet rs1 = null;

		try {
			stm = conn.createStatement();
			rs1 = stm.executeQuery(qStudent);
			while (rs1.next()) {
				if (rs1.getString(1).equals(matrikelnummer)) {
					existsMatrikel = true;
					break;
				}
			}
			/**
						stm = conn.createStatement();
						rs2 = stm.executeQuery(qPrüfung);
						while (rs2.next()) {
							if (rs2.getString("lva_titel").equals(lva_bezeichnung)) {
								existsPrüfung = true;
								break;
							}
						}**/

			if (existsMatrikel == true) {

				pstm = conn.prepareStatement(test);
				pstm.setString(1, matrikelnummer);
				rs = pstm.executeQuery();
	%>
		<table class="table">
			<thead>
				<tr>
					<th scope="col">LVA Bezeichnung</th>
					<th scope="col">LVA Nummer</th>
					<th scope="col">Prüfungsdatum</th>
					<th scope="col">Von</th>
					<th scope="col">Bis</th>
					<th scope="col">Raum</th>
					<th scope="col">max. Teilnehmerzahl</th>
					<th scope="col">Anmeldungen</th>
				</tr>
			</thead>

			<%
			while (rs.next()) {
		%>
			<tr>
			<tbody>
				<td><%=rs.getString(1)%><br></td>
				<td><%=rs.getString(2)%><br></td>
				<td><%=rs.getString(3)%><br></td>
				<td><%=rs.getString(4)%><br></td>
				<td><%=rs.getString(5)%><br></td>
				<td><%=rs.getString(6)%><br></td>
				<td><%=rs.getString(7)%><br></td>
				<td><%=rs.getString(8)%><br></td>


				<%
				if (rs.getString(6).equals(rs.getString(7))) {
			%>
				<td>Anmeldung geschlossen</td>
				<%
				} else {
			%>

				<td><a class="btn btn-outline-secondary btn-sm"
					href="prüfungsservice_insert.jsp?lva_nummer=<%=rs.getString(2)%>
				&matrikelnummer=<%=matrikelnummer%>
				&lva_titel=<%=rs.getString(1)%>"
					role="button">Anmelden</a></td>
				<%
				}

						}

					} else {
						out.println("Die eingegebene Matrikelnummer existiert nicht!");
					}
				} catch (SQLException e) {
					e.printStackTrace();
				} catch (Exception e) {
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
					if (rs1 != null) {
						try {
							rs1.close();
						} catch (SQLException e) {
							;
						}
						rs1 = null;
					}

					if (pstm != null) {
						try {
							pstm.close();
						} catch (SQLException e) {
							;
						}
						pstm = null;
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
			
			<tbody>
		</table>
		<br>
	<br>
	</div>
</body>
</html>