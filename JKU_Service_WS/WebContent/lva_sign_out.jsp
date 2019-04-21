<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>LVA Abmeldung</title>
</head>
<body>

	<%
		//Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

		String lva_nummer = request.getParameter("lva_nummer");
		String matrikelnummer = request.getParameter("matrikelnummer");

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

	<br>
	<br>
	<a href="lva_overview_student.html">Zurück</a>
	<a href="main_page.html">Hauptmenü</a>


</body>
</html>