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
<title>Einf�gen der Pr�fung in die Datenbank</title>
</head>
<body>

<div class="container">

		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<a class="navbar-brand" href="index.html">Hauptmen�</a> <a
				class="navbar-brand" href="lva_service.html">LVA Service</a> <a
				class="navbar-brand" href="pr�fungsservice.html">Pr�fungsservice</a>
			<a class="navbar-brand" href="raumservice.html">Raumservice</a> <a
				class="navbar-brand" href="veranstaltungsservice.html">Veranstaltungsservice</a>

		</nav>
		
		<br>

	<%
		// Variablen
		boolean existsAnmeldung = false;
		boolean abgemeldet = false;
		boolean regLva = false;

		//Datenbankverbindung
		Connection conn = sqliteConnection.dbConnector();

		String matrikelnummer = request.getParameter("matrikelnummer");
		String lva_nummer = request.getParameter("lva_nummer");
		String lva_bezeichnung = request.getParameter("lva_titel");

		String qLva = "SELECT matrikelnummer FROM studenten_lva_anmeldungen";

		String queryAngemeldet = "SELECT pruefung FROM studenten_pruefungsanmeldungen WHERE matrikelnummer = ? AND lva_nummer=?";

		String query = "INSERT INTO studenten_pruefungsanmeldungen(matrikelnummer, lva_bezeichnung, lva_nummer, pruefung) VALUES (?,?,?, 'angemeldet')";

		//String qUpdate = "UPDATE studenten_pruefungsanmeldungen SET pruefung = 'angemeldet' WHERE matrikelnummer =? AND lva_nummer=?";

		String queryAnmeldungen = "UPDATE pruefungs_service SET anmeldungen = anmeldungen + 1 WHERE lva_nummer=?";

		Statement stm = null;
		PreparedStatement pstm = null;
		ResultSet rs = null;

		try {
			pstm = conn.prepareStatement(queryAngemeldet);
			pstm.setString(1, matrikelnummer);
			pstm.setString(2, lva_nummer);
			rs = pstm.executeQuery();
			while (rs.next()) {
				if (rs.getString(1).equals("angemeldet")) {
					out.println("Du bist bereits f�r diese Pr�fung angemeldet.");
					existsAnmeldung = true;
					break;
				}
			}

			pstm.close();
			rs.close();
			/**
			pstm = conn.prepareStatement(queryAngemeldet);
			pstm.setString(1, matrikelnummer);
			pstm.setString(2,lva_nummer);
			rs = pstm.executeQuery();
			while (rs.next()) {
				if (rs.getString(1).equals("abgemeldet")) {
					abgemeldet = true;
					break;
				}
			}**/

			//pstm = conn.prepareStatement(qLva);
			//pstm.setString(1, matrikelnummer);
			stm = conn.createStatement();
			rs = stm.executeQuery(qLva);

			while (rs.next()) {

				if (rs.getString(1).equals(matrikelnummer)) {
					regLva = true;

				} else {
					out.println(
							"Du bist nicht f�r diese LVA angemeldet! Eine Pr�fungsanmeldung ist daher nicht m�glich!");
				}

			}

			pstm.close();

			if (existsAnmeldung == false && regLva == true) {

				pstm = conn.prepareStatement(query);
				pstm.setString(1, matrikelnummer);
				pstm.setString(2, lva_bezeichnung);
				pstm.setString(3, lva_nummer);

				pstm.executeUpdate();

				pstm.close();

				pstm = conn.prepareStatement(queryAnmeldungen);
				pstm.setString(1, lva_nummer);
				pstm.executeUpdate();

				out.println(
						"Die Anmeldung zu der Pr�fung in " + lva_bezeichnung + " wurde erfolgreich durchgef�hrt!");
			} /** if(existsAnmeldung == false && abgemeldet == true && regLva == true) {
				pstm = conn.prepareStatement(qUpdate);
				pstm.setString(1, matrikelnummer);
				pstm.setString(2, lva_nummer);
				
				pstm.executeUpdate();
				
				
				pstm.close();
				
				pstm = conn.prepareStatement(queryAnmeldungen);
				pstm.setString(1, lva_nummer);
				pstm.executeUpdate();
				
				out.println(
						"Die Anmeldung zu der Pr�fung in " + lva_bezeichnung + " wurde erfolgreich durchgef�hrt!");
				}**/

			existsAnmeldung = false;

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

	<br>
	<br>
	</div>
</body>
</html>