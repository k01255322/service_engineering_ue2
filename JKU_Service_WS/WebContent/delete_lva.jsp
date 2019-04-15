<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

	<%
		//Abfrage der eingegebenen Daten
		String bezeichnung = request.getParameter("titel");
		String lva_nummer = request.getParameter("lva_nummer");

		// Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

		String sql = "delete from lva_service where lva_nummer=266.004";
		Statement stm = conn.createStatement();
		stm.executeUpdate(sql);
		
		
		
		
		//PreparedStatement pst = conn.prepareStatement("DELETE FROM lva_service WHERE lva_nummer=?");
		//pst.setString(1, lva_nummer);
		
		//pst.executeUpdate();

		// Schließen der Verbindung
		//pst.close();
		conn.close();
	%>


	<p>LVA wurde erfolgreich gelöscht!</p>

	<a href="main_page.html">Hauptmenü</a>

</body>
</html>