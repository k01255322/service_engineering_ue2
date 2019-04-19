<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Beurteilungen in Datenbank speichern</title>
</head>
<body>

	<%
		// Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

		String query = "UPDATE studenten_liste SET pruefung=?, beurteilung=? WHERE matrikelnummer=? AND lva_nummer=?";

		String[] matrikelnummer = request.getParameterValues("matrikelnummer");
		String lva_nummer = request.getParameter("lva_nummer");
		String[] beurteilung = request.getParameterValues("note");

		PreparedStatement pstm = null;
		try {

			pstm = conn.prepareStatement(query);

			for (int i = 0; i < beurteilung.length; i++) {

				if (beurteilung[i].equals("nicht genügend")) {
					pstm.setString(1, "nicht bestanden");
				} else {
					pstm.setString(1, "bestanden");
				}
				pstm.setString(2, beurteilung[i]);
				pstm.setString(3, matrikelnummer[i]);
				pstm.setString(4, lva_nummer);
				pstm.executeUpdate();
			}
			out.println("Noten wurden erfolgreich eingetragen!");

		} catch (SQLException e) {
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

	<br>
	<br>
	<a href="lva_overview.jsp">LVA-Übersicht</a>
	<a href="main_page.html">Hauptmenü</a>

</body>
</html>