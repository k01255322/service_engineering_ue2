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

		//Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

		/**
		To-Do Seite erstellen zum eintragen der Studenten in Kurse
			Die Prüfungsanmeldung muss dann mit dem Kurs und der MAtrikelnummer abgestimmt werden
		**/
		String matrikelnummer = request.getParameter("matrikelnummer");
		String lva_nummer = request.getParameter("lva_nummer");
		String lva_bezeichnung = request.getParameter("lva_titel");

		String queryStudent = "SELECT matrikelnummer, pruefung FROM studenten_liste WHERE matrikelnummer = ? AND lva_nummer=?";

		String query = "UPDATE studenten_liste SET pruefung='angemeldet' WHERE matrikelnummer=? AND lva_nummer=?";

		String queryAnmeldungen = "UPDATE pruefungs_service SET anmeldungen = anmeldungen + 1 WHERE lva_nummer=?";

		PreparedStatement pstm = null;
		ResultSet rs = null;

		try {
			pstm = conn.prepareStatement(queryStudent);
			pstm.setString(1, matrikelnummer);
			pstm.setString(2,lva_nummer);
			rs = pstm.executeQuery();
			while (rs.next()) {
				if (rs.getString(2).equals("angemeldet")) {
					out.println("Du bist bereits für diese Prüfung angemeldet.");
					existsAnmeldung = true;
					break;
				}
			}

			pstm.close();

			if (existsAnmeldung == false) {

				pstm = conn.prepareStatement(query);
				pstm.setString(1, matrikelnummer);
				pstm.setString(2, lva_nummer);
				pstm.executeUpdate();

				pstm.close();

				pstm = conn.prepareStatement(queryAnmeldungen);
				pstm.setString(1, lva_nummer);
				pstm.executeUpdate();

				out.println(
						"Die Anmeldung zu der Prüfung in " + lva_bezeichnung + " wurde erfolgreich durchgeführt!");
			}

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
	<a href="main_page.html">Hauptmenü</a>
</body>
</html>