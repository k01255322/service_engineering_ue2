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
			<th>Datum</th>
			<th>Uhrzeit von</th>
			<th>Uhrzeit bis</th>
		</tr>

		<%
			// Datenbankverbindung
			Class.forName("org.sqlite.JDBC");
			Connection conn = DriverManager.getConnection(
					"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

			String query = "SELECT titel, lva_nummer, leiter, max_studierende, raum, datum, von, bis FROM lva_service";

			Statement stmt = null;
			ResultSet rs = null;

			try {
				stmt = conn.createStatement();
				rs = stmt.executeQuery(query);

				while (rs.next()) {
		%>
		<tr>
			<td><%=rs.getString(1)%><br></td>
			<td><%=rs.getString(2)%><br></td>
			<td><%=rs.getString(3)%><br></td>
			<td><%=rs.getString(4)%><br></td>
			<td><%=rs.getString(5)%><br></td>
			<td><%=rs.getString(6)%><br></td>
			<td><%=rs.getString(7)%><br></td>
			<td><%=rs.getString(8)%><br></td>
			<td><a href="lva_edit.jsp?lva_nummer=<%=rs.getString(2)%>">Bearbeiten</a></td>
			<td><a href="prüfung_erstellen.jsp?lva_nummer=<%=rs.getString(2)%>">Prüfung erstellen</a></td>
			<td><a href="beurteilungen.jsp?lva_nummer=<%=rs.getString(2)%>">Noten eintragen</a></td>
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