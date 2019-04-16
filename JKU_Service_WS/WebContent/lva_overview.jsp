<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>LVA-�bersicht</title>
</head>
<body>

	<h1>�bersicht der LVAs</h1>

	<table border=1>
		<tr>
			<th>Bezeichnung</th>
			<th>LVA Nummer</th>
			<th>LVA Leiter</th>
			<th>Max. Anzahl Studierender</th>
			<th>Raum</th>
		</tr>

		<%
			// Datenbankverbindung
			Class.forName("org.sqlite.JDBC");
			Connection conn = DriverManager.getConnection(
					"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

			String query = "SELECT titel, lva_nummer, leiter, max_studierende, raum FROM lva_service";

			Statement stmt = null;
			ResultSet rs = null;

			try {
				stmt = conn.createStatement();
				rs = stmt.executeQuery(query);

				while (rs.next()) {
		%>
		<tr>
			<td><%=rs.getString(1)%></td>
			<td><%=rs.getString(2)%></td>
			<td><%=rs.getString(3)%></td>
			<td><%=rs.getString(4)%></td>
			<td><%=rs.getString(5)%></td>
			<td><a href="lva_delete.jsp?titel=<%=rs.getString(1)%>">L�schen</a></td>
			<td><a href="lva_edit.jsp?titel=<%=rs.getString(1)%>">Bearbeiten</a></td>
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
				if (stmt != null) {
					try {
						stmt.close();
					} catch (SQLException e) {
						;
					}
					stmt = null;
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
	<a href="main_page.html">Hauptmen�</a>


</body>
</html>