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
			
			String matrikelnummer = request.getParameter("matrikelnummer");
			String lva_nummer = request.getParameter("lva_nummer");
			int beurteilung = Integer.parseInt(request.getParameter("note"));
			
			PreparedStatement pstm = null;
			try {
				pstm = conn.prepareStatement(query);
				if(beurteilung > 5 || beurteilung < 1) {
					out.println("Ungültiger Wert im Feld Note!");
				} else {
				pstm.setInt(2, beurteilung);
				if (beurteilung > 0 && beurteilung < 5) {
					pstm.setString(1, "bestanden");
				} else {
					pstm.setString(1, "nicht bestanden");
				} 
				pstm.setString(3, matrikelnummer);
				pstm.setString(4, lva_nummer);
				pstm.executeUpdate();
				
				out.println("Noten wurden erfolgreich eingetragen!");
				}

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
		<a href = "main_page.html">Hauptmenü</a>

</body>
</html>