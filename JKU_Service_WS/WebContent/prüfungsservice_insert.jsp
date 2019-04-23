<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Einfügen der Prüfung in die Datenbank</title>
</head>
<body>

	<%
		// Variablen
		boolean existsAnmeldung = false;
		boolean abgemeldet = false;
		boolean regLva = false;

		//Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

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
					out.println("Du bist bereits für diese Prüfung angemeldet.");
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
							"Du bist nicht für diese LVA angemeldet! Eine Prüfungsanmeldung ist daher nicht möglich!");
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
						"Die Anmeldung zu der Prüfung in " + lva_bezeichnung + " wurde erfolgreich durchgeführt!");
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
						"Die Anmeldung zu der Prüfung in " + lva_bezeichnung + " wurde erfolgreich durchgeführt!");
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
	<a href="index.html">Hauptmenü</a>
</body>
</html>