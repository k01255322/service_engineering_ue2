<%@page import="sqliteConnector.sqliteConnection"%>
s<%@ page import="java.sql.*"%>
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
<title>Prüfungsabmeldung</title>
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

	<%
		// Variablen
		boolean existsAbmeldung = false;
		//Datenbankverbindung
		Connection conn = sqliteConnection.dbConnector();

		String lva_nummer = request.getParameter("lva_nummer");
		String matrikelnummer = request.getParameter("matrikelnummer");
		
		String query = "DELETE FROM studenten_pruefungsanmeldungen WHERE matrikelnummer = ? AND lva_nummer =?";

		String queryAbmeldungen = "UPDATE pruefungs_service SET anmeldungen = anmeldungen - 1 WHERE lva_nummer=?";
		PreparedStatement pstm = null;
		ResultSet rs = null;
		
		

		try {
			
			
			
				
				pstm = conn.prepareStatement(query);
				pstm.setString(1, matrikelnummer);
				pstm.setString(2, lva_nummer);
				pstm.executeUpdate();

				pstm.close();

				pstm = conn.prepareStatement(queryAbmeldungen);
				pstm.setString(1, lva_nummer);
				pstm.executeUpdate();

				out.println("Abmeldung wurde durchgeführt!");
			

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



</div>
</body>
</html>