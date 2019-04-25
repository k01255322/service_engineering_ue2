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
<title>LVA Abmeldung</title>
</head>
<body>

	<%
		String lva_nummer = request.getParameter("lva_nummer");
		String matrikelnummer = request.getParameter("matrikelnummer");
	%>

	<div class="container">

		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<a class="navbar-brand" href="index.html">Hauptmenü</a> <a
				class="navbar-brand" href="lva_service.html">LVA Service</a> <a
				class="navbar-brand" href="prüfungsservice.html">Prüfungsservice</a>
			<a class="navbar-brand" href="raumservice.html">Raumservice</a> <a
				class="navbar-brand" href="veranstaltungsservice.html">Veranstaltungsservice</a>
			<a class="navbar-brand"
				href="lva_overview_student.jsp?matrikelnummer=<%=matrikelnummer%>">Zurück</a>

		</nav>
		<br>


		<%
			//Datenbankverbindung
			Connection conn = sqliteConnection.dbConnector();

			String query = "DELETE FROM studenten_lva_anmeldungen WHERE matrikelnummer=? AND lva_nummer=?";

			PreparedStatement pstm = null;

			try {

				pstm = conn.prepareStatement(query);
				pstm.setString(1, matrikelnummer);
				pstm.setString(2, lva_nummer);
				pstm.executeUpdate();

				out.println("Abmeldung wurde durchgeführt!");

			} catch (SQLException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {

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

</div>
</body>
</html>