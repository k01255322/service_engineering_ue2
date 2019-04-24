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
<title>LVAs abrufen</title>
</head>
<body>
<div class="container">

<h2><span class="badge badge-secondary">LVA-�bersicht</span></h2>
<br>
	
		<%
			// Variablen
			boolean exists = false;

			// Datenbankverbindung
			Class.forName("org.sqlite.JDBC");
			Connection conn = DriverManager.getConnection(
					"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

			String qMatr = "SELECT matrikelnummer FROM studenten_liste";

			String query = "SELECT l.titel, l.lva_nummer, l.leiter, l.raum, l.datum, l.von, l.bis FROM lva_service l INNER JOIN studenten_lva_anmeldungen USING(lva_nummer) "
							+ "WHERE studenten_lva_anmeldungen.matrikelnummer=?";
							 
			

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
						<th>LVA Leiter</th>
						<th>Raum</th>
						<th>Datum</th>
						<th>Von</th>
						<th>Bis</th>
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
			<td><%=rs.getString(7)%><br></td>
			<td><a
				href="lva_sign_out.jsp?lva_nummer=<%=rs.getString(2)%>
				&matrikelnummer=<%=matrikelnummer%>">Abmelden</a></td>
		</tr>
	

		<%
			}
				} else {
					out.println("Bitte eine g�ltige Matrikelnummer eingeben!");
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
	<a href="lva_service.html">Zur�ck</a>
	<a href="index.html">Hauptmen�</a>
</div>
</body>
</html>