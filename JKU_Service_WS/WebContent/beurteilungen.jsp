<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Beurteilungen eintragen</title>
</head>
<body>

<table border=1>
		<tr>
			<th>Vorname</th>
			<th>Nachname</th>
			<th>Matrikelnummer</th>
			<th>Note</th>
		</tr>

<%
			// Datenbankverbindung
			Class.forName("org.sqlite.JDBC");
			Connection conn = DriverManager.getConnection(
					"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");
			
			String query = "SELECT vorname, nachname, matrikelnummer FROM studenten_liste WHERE lva_nummer=? AND pruefung = 'angemeldet'";
			
			String lva_nummer = request.getParameter("lva_nummer");
			
			PreparedStatement pstm = null;
			ResultSet rs = null;
			try {
				pstm = conn.prepareStatement(query);
				pstm.setString(1, lva_nummer);
				rs = pstm.executeQuery();

				while (rs.next()) {
		%>
		<tr>
			<form method="post" action="beurteilungen_insert.jsp">
				<td><input type="text" name="vorname" value="<%=rs.getString(1)%>" readonly></td>
				<td><input type="text" name="nachname" value="<%=rs.getString(2)%>" readonly></td>
				<td><input type="text" name="matrikelnummer" value="<%=rs.getString(3)%>" readonly></td>
				<td><input type="text" name="note"></td></tr>
				</table>
				<input type="submit" value="Bestätigen">
			</form>
			
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
				if (pstm != null) {
					try {
						pstm.close();
					} catch (SQLException e) {
						;
					}
					pstm = null;
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