<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Student einfügen</title>

<h1>LVA-Übersicht</h1>

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
<a href="index.html">Hauptmenü</a>


</head>
<body>

</body>
</html>