<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" 
integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" 
crossorigin="anonymous">
 <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta charset="ISO-8859-1">
<title>Beurteilungen eintragen</title>
</head>
<body>
<div class="container">

<h2><span class="badge badge-secondary">Beurteilungen eintragen</span></h2>
<br>
	<%
		// Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

		String query = "SELECT matrikelnummer, lva_nummer FROM studenten_pruefungsanmeldungen WHERE lva_nummer=? AND pruefung = 'angemeldet'";

		String lva_nummer = request.getParameter("lva_nummer");

		PreparedStatement pstm = null;
		ResultSet rs = null;
		try {
			pstm = conn.prepareStatement(query);
			pstm.setString(1, lva_nummer);
			rs = pstm.executeQuery();
	%>
	<table border=1>
		<tr>
			<th>LVA-Nummer</th>
			<th>Matrikelnummer</th>
			<th>Note</th>
		</tr>
		<%
			while (rs.next()) {
		%>
		<tr>
			<form method="post" action="beurteilungen_insert.jsp">
				<td><input type="text" name="lva_nummer"
					value="<%=rs.getString(2)%>" readonly></td>
				<td><input type="text" name="matrikelnummer"
					value="<%=rs.getString(1)%>" readonly></td>
				<td><select name="note"">
						<option value="" disabled selected hidden>Bitte
							auswählen...</option>
						<option value="sehr gut">Sehr Gut</option>
						<option value="gut">Gut</option>
						<option value="befriedigend">Befriedigend</option>
						<option value="genügend">Genügend</option>
						<option value="nicht genügend">Nicht Genügend</option></td>
		</tr>

		<%
			}
		%>
	</table>
	<br>
	<button type="submit" class="btn btn-outline-secondary">Bestätigen</button>
	</form>


	<%
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
	<a href="index.html">Hauptmenü</a>
	</div>
</body>
</html>