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

<table border=1>
	<tr>
		<th>LVA-Nummer</th>
		<th>Note</th>
	</tr>
<%
// Datenbankverbindung
Class.forName("org.sqlite.JDBC");
Connection conn = DriverManager.getConnection(
		"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

	String query = "SELECT lva, note FROM beurteilung WHERE matrikelnummer =?";
	
	String matrikelnummer = request.getParameter("matrikelnummer");
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	try {
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, matrikelnummer);
		rs = pstmt.executeQuery();

		while (rs.next()) {
			
			%>
		<tr>
			<td><%=rs.getString(1)%><br></td>
			<td><%=rs.getString(2)%><br></td>
		</tr>
		<%
			
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