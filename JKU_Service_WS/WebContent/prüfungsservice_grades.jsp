<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Noten abrufen</title>
</head>
<body>



	<h1>Notenauskunft</h1>


	<%
		// Variablen
		boolean exists = false;

		// Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

		String query = "SELECT lva, note FROM beurteilung WHERE matrikelnummer =?";

		String qMatr = "SELECT matrikelnummer FROM studenten_liste";

		String matrikelnummer = request.getParameter("matrikelnummer");

		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(qMatr);
			while (rs.next()) {
				if (rs.getString(1).equals(matrikelnummer)) {
					exists = true;
					break;
				}
			}
			rs.close();

			if (exists == true) {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, matrikelnummer);
				rs = pstmt.executeQuery();
	%>
	<table border=1>
		<tr>
			<th>LVA-Nummer</th>
			<th>Note</th>
		</tr>
		<%
			while (rs.next()) {
		%>
		<tr>
			<td><%=rs.getString(1)%><br></td>
			<td><%=rs.getString(2)%><br></td>
		</tr>
		<%
			}
				} else {
					out.println("Die eingegebene Matrikelnummer existiert nicht!");
				}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				if (rs != null) {
					try {
						rs.close();
					} catch (SQLException e) {
						;
					}
					rs = null;
				}
				if (pstmt != null) {
					try {
						pstmt.close();
					} catch (SQLException e) {
						;
					}
					pstmt = null;
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
	</table>
	<br>
	<br>
	<a href="prüfungsservice.html">Zurück</a>
	<a href="index.html">Hauptmenü</a>

</body>
</html>