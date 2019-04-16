
<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>JKU LVA Service - Verwalten</title>
</head>
<body>



	<%
		// Variablen
		boolean exists = false;

		// Abfrage der eingegebenen Daten
		String bezeichnung = request.getParameter("titel");
		String lva_nummer = request.getParameter("lva_nummer");

		// Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

		PreparedStatement pst = conn.prepareStatement("select * from lva_service WHERE titel=? AND lva_nummer=?");
		pst.setString(1, bezeichnung);
		pst.setString(2, lva_nummer);

		ResultSet rs = pst.executeQuery();

		while (rs.next()) {
			if (rs.getString("lva_nummer").equals(lva_nummer)) {
				exists = true;
			}
			out.println("<tr>");
			out.println("<td>" + rs.getString("lva_nummer") + "</td>");
			out.println("<td>" + rs.getString("titel") + "</td>");
			out.println("<td>" + rs.getString("leiter") + "</td>");
			out.println("<td>" + rs.getString("max_studierende") + "</td>");
			out.println("<td>" + rs.getString("raum") + "</td>");
			out.println("</tr><br>");
	%>
	<a href="lva_bearbeiten.html">Bearbeiten</a>
	<a href="delete_lva.jsp">Löschen</a>
	<a href="jku_lva_service.html">Zurück</a>
	<%
		}

		if (exists == false) {
			out.println("LVA existiert nicht");
			exists = true;
		} else {

		}

		rs.close();
		conn.close();
	%>


</body>
</html>