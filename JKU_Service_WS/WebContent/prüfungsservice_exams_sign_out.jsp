<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Pr�fungen abrufen</title>
</head>
<body>

	<h1>Pr�fungs�bersicht</h1>

	<%
		// Variablen
		boolean exists = false;
		;

		// Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

		String qMatr = "SELECT matrikelnummer FROM studenten_liste";

		String query = "SELECT p.lva_titel, p.lva_nummer, p.datum, p.von, p.bis, p.ort FROM pruefungs_service p INNER JOIN studenten_pruefungsanmeldungen USING(lva_nummer) "
				+ "WHERE studenten_pruefungsanmeldungen.matrikelnummer=?";

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
			<th>LVA Titel</th>
			<th>LVA Nummer</th>
			<th>Datum</th>
			<th>Von</th>
			<th>Bis</th>
			<th>Raum</th>
		</tr>
		<%
			while (rs.next()) {
		%>
		<tr>
			<td><%=rs.getString(1)%><br></td>
			<td><%=rs.getString(2)%><br></td>
			<td><%=rs.getString(3)%><br></td>
			<td><%=rs.getString(4)%><br></td>
			<td><%=rs.getString(5)%><br></td>
			<td><%=rs.getString(6)%><br></td>
			<td><a
				href="pr�fung_sign_out.jsp?lva_nummer=<%=rs.getString(2)%>
				&matrikelnummer=<%=matrikelnummer%>">Abmelden</a></td>
		</tr>
		<%
			}
				} else {
					out.println("Die eingegebene Matrikelnummer existiert nicht!");
				}
				exists = true;
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
	<a href="pr�fungsservice.html">Zur�ck</a>
	<a href="index.html">Hauptmen�</a>

</body>
</html>