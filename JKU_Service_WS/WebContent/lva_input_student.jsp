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
<title>LVA-Anmeldung</title>
</head>
<body>
<div class="container">

<h2><span class="badge badge-secondary">LVA-Anmeldung</span></h2>

	<br>

<%


//Variablen
			boolean exists = false;

			// Datenbankverbindung
			Class.forName("org.sqlite.JDBC");
			Connection conn = DriverManager.getConnection(
					"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

			String qMatr = "SELECT matrikelnummer FROM studenten_liste";
			

			String query = "SELECT titel, lva_nummer, leiter, raum, datum, von, bis FROM lva_service";
							 
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
					stmt = conn.createStatement();
					rs = stmt.executeQuery(query);
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
			<td>
			<a
				href="lva_insert_student.jsp?lva_nummer=<%=rs.getString(2)%>
				&matrikelnummer=<%=matrikelnummer%>">Anmelden</a></td>
		</tr>
		

		<%
			}
				} else {
					out.println("Bitte eine gültige Matrikelnummer eingeben!");
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
<a href="lva_service.html">Zurück</a>
<a href="index.html">Hauptmenü</a>



</div>
</body>
</html>