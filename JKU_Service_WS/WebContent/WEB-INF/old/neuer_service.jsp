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
		// Variablen
		boolean exists = false;

		// Abfrage der eingegebenen Daten
		String lva_bezeichnung = request.getParameter("lva_bezeichnung");
		String lva_nummer = request.getParameter("lva_nummer");
		String leiter = request.getParameter("lva_leiter");
		String max_studierende = request.getParameter("max_studierende");
		String raum = request.getParameter("raum");

		// Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");
		Statement stat = conn.createStatement();

		// Prüfung, ob LVA bereits vorhanden	
		ResultSet rs = stat.executeQuery("SELECT lva_nummer FROM lva_service");
		while (rs.next()) {
			if (rs.getString("lva_nummer").equals(lva_nummer)) {
				exists = true;
				break;
			}
		}

		if (exists == true) {
			out.println("LVA ist bereits vorhanden und wurde nicht erneut angelegt!");
			exists = false;
		} else {
			PreparedStatement pst = conn.prepareStatement(
					"INSERT INTO lva_service(titel, lva_nummer, leiter, max_studierende, raum) VALUES (?,?,?,?,?)");
			pst.setString(1, lva_bezeichnung);
			pst.setString(2, lva_nummer);
			pst.setString(3, leiter);
			pst.setString(4, max_studierende);
			pst.setString(5, raum);

			pst.executeUpdate();

			out.println("LVA mit der Nummer " + lva_nummer + " und der Bezeichnung " + lva_bezeichnung
					+ " wurde erfolgreich angelegt!");
			
			pst.close();
		}

		// Schließen der Verbindung
		rs.close();
		conn.close();
	%>
	
	<a href ="MainPage.html">Hauptmenü</a>
</body>
</html>