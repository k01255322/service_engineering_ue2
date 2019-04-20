<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Student einfügen</title>
</head>
<body>

	<%
		// Variablen
		boolean exists = false;

		// Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

		String qExists = "SELECT matrikelnummer FROM studenten_liste";

		String qInsert = "INSERT INTO studenten_liste (vorname, nachname, matrikelnummer) VALUES (?,?,?)";

		String matrikelnummer = request.getParameter("matrikelnummer");
		String vorname = request.getParameter("vorname");
		String nachname = request.getParameter("nachname");

		Statement stm = null;
		ResultSet rs = null;

		PreparedStatement pstm = null;

		try {
			stm = conn.createStatement();
			rs = stm.executeQuery(qExists);
			while (rs.next()) {
				if (rs.getString(1).equals(matrikelnummer)) {
					out.println("Matrikelnummer (" + matrikelnummer + ") ist bereits vergeben.");
					exists = true;
					break;
				}
			}
			if (exists == false) {

				pstm = conn.prepareStatement(qInsert);
				pstm.setString(1, vorname);
				pstm.setString(2, nachname);
				pstm.setString(3, matrikelnummer);
				pstm.executeUpdate();

				out.println("Student wurde eingefügt!");

			}
			exists = false;
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
			if (stm != null) {
				try {
					stm.close();
				} catch (SQLException e) {
					;
				}
				stm = null;
			}
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					;
				}
				rs = null;
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

