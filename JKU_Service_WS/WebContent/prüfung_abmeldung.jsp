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
//Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

		String lva_nummer = request.getParameter("lva_nummer");
		String matrikelnummer = request.getParameter("matrikelnummer");
		
		String query = "UPDATE studenten_liste SET pruefung='abgemeldet' WHERE matrikelnummer=? AND lva_nummer=?";
		
		String queryAbmeldungen = "UPDATE pruefungs_service SET anmeldungen = anmeldungen - 1 WHERE lva_nummer=?";
		PreparedStatement pstm = null;
		
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

		}catch (SQLException e) {
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
		
		<br>
		<br>
		<a href="main_page.html">Hauptmenü</a>

</body>
</html>