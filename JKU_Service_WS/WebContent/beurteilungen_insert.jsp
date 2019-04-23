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
	// Variablen
	boolean exists = false;
	
		// Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");
		
		String queryPruefung = "UPDATE studenten_pruefungsanmeldungen SET pruefung=? WHERE matrikelnummer=? AND lva_nummer=?";

		String qInsert = "INSERT INTO beurteilung (matrikelnummer, lva, note) VALUES (?,?,?)";
		
		String[] matrikelnummer = request.getParameterValues("matrikelnummer");
		String lva_nummer = request.getParameter("lva_nummer");
		String[] beurteilung = request.getParameterValues("note");
		
		Statement stm = null;
		ResultSet rs = null;

		PreparedStatement pstm = null;
		try {
			
			for (int i = 0; i < beurteilung.length; i++) {
				
				pstm = conn.prepareStatement(qInsert);
				pstm.setString(1, matrikelnummer[i]);
				pstm.setString(2, lva_nummer);
				pstm.setString(3, beurteilung[i]);
				pstm.executeUpdate();
				
				pstm.close();
				
				pstm = conn.prepareStatement(queryPruefung);

				if (beurteilung[i].equals("nicht genügend")) {
					pstm.setString(1, "nicht bestanden");
				} else {
					pstm.setString(1, "bestanden");
				}
				pstm.setString(2, matrikelnummer[i]);
				pstm.setString(3, lva_nummer);
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
	<a href="lva_service.html">Zurück</a>
	<a href="index.html">Hauptmenü</a>

</body>
</html>