<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>LVA-Übersicht</title>
</head>
<body>

	<h1>Übersicht der LVAs</h1>

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
			<td><%=rs.getString(1)%><br><a href="lva_edit.jsp?lva_nummer=<%=rs.getString(2)%>&titel=<%=rs.getString(1)%>">Bearbeiten</a></td>
			<td><%=rs.getString(2)%><br><a href="lva_edit.jsp?lva_nummer=<%=rs.getString(2)%>">Bearbeiten</a></td>
			<td><%=rs.getString(3)%><br><a href="lva_edit.jsp?lva_nummer=<%=rs.getString(2)%>&leiter=<%=rs.getString(3)%>">Bearbeiten</a></td>
			<td><%=rs.getString(4)%><br><a href="lva_edit.jsp?lva_nummer=<%=rs.getString(2)%>&max_studierende=<%=rs.getString(4)%>">Bearbeiten</a></td>
			<td><%=rs.getString(5)%><br><a href="lva_edit.jsp?lva_nummer=<%=rs.getString(2)%>&raum=<%=rs.getString(5)%>">Bearbeiten</a></td>
			<td><a href="lva_delete.jsp?lva_nummer=<%=rs.getString(2)%>">Löschen</a></td>
			
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
	<a href="main_page.html">Hauptmenü</a>


</body>
</html>