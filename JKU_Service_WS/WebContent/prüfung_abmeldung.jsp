<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Prüfungsabmeldung</title>
</head>
<body>

	<%
		// Variablen
		boolean existsAbmeldung = false;
		//Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

		String lva_nummer = request.getParameter("lva_nummer");
		String matrikelnummer = request.getParameter("matrikelnummer");

		String queryStudent = "SELECT matrikelnummer, pruefung FROM studenten_liste WHERE matrikelnummer = ? AND lva_nummer =?";

		String query = "UPDATE studenten_liste SET pruefung='abgemeldet' WHERE matrikelnummer=? AND lva_nummer=?";

		String queryAbmeldungen = "UPDATE pruefungs_service SET anmeldungen = anmeldungen - 1 WHERE lva_nummer=?";
		PreparedStatement pstm = null;
		ResultSet rs = null;

		try {
			pstm = conn.prepareStatement(queryStudent);
			pstm.setString(1, matrikelnummer);
			pstm.setString(2, lva_nummer);
			rs = pstm.executeQuery();
			while (rs.next()) {
				if (rs.getString(2).equals("abgemeldet")) {
					out.println("Du bist bereits von dieser Prüfung abgemeldet.");
					existsAbmeldung = true;
					break;
				}
			}

			pstm.close();
			
			if (existsAbmeldung == false) {
				pstm = conn.prepareStatement(query);
				pstm.setString(1, matrikelnummer);
				pstm.setString(2, lva_nummer);
				pstm.executeUpdate();

				pstm.close();

				pstm = conn.prepareStatement(queryAbmeldungen);
				pstm.setString(1, lva_nummer);
				pstm.executeUpdate();

				out.println("Abmeldung wurde durchgeführt!");
			}
			existsAbmeldung = false;
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

	<br>
	<br>
	<a href="main_page.html">Hauptmenü</a>


</body>
</html>