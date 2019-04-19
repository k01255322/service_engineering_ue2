<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Prüfungsservice</title>
</head>
<body>

	<h1>Prüfungsanmeldung</h1>

	<%
		// Variablen
		boolean existsMatrikel = false;
		boolean existsPrüfung = false;

		//Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

		String matrikelnummer = request.getParameter("matrikelnummer");
		String lva_bezeichnung = request.getParameter("titel");

		String qStudent = "SELECT matrikelnummer, pruefung FROM studenten_liste";
		String qPrüfung = "SELECT lva_titel FROM pruefungs_service";
		String qAnmeldung = "SELECT lva_titel, lva_nummer, datum, zeit, ort, anzahl_plaetze, anmeldungen FROM pruefungs_service WHERE lva_titel=?";
		Statement stm = null;
		PreparedStatement pstm = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;

		try {
			stm = conn.createStatement();
			rs1 = stm.executeQuery(qStudent);
			while (rs1.next()) {
				if (rs1.getString(1).equals(matrikelnummer)) {
					existsMatrikel = true;
					break;
				}
			}

			stm = conn.createStatement();
			rs2 = stm.executeQuery(qPrüfung);
			while (rs2.next()) {
				if (rs2.getString("lva_titel").equals(lva_bezeichnung)) {
					existsPrüfung = true;
					break;
				}
			}

			if (existsMatrikel == true && existsPrüfung == true) {
				pstm = conn.prepareStatement(qAnmeldung);
				pstm.setString(1, lva_bezeichnung);
				rs = pstm.executeQuery();
	%>
	<table border=1>
		<tr>
			<th>LVA Bezeichnung</th>
			<th>LVA Nummer</th>
			<th>Prüfungsdatum</th>
			<th>Prüfungszeit</th>
			<th>Raum</th>
			<th>max. Teilnehmerzahl</th>
			<th>Anmeldungen</th>
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
			
			<% if(rs.getString(6).equals(rs.getString(7))) {
				%>
				<td>Anmeldung geschlossen</td>
				<%} else { %>
			
			
			<td><a
				href="prüfungsservice_insert.jsp?lva_nummer=<%=rs.getString(2)%>
				&matrikelnummer=<%=rs1.getString(1)%>
				&lva_titel=<%=rs2.getString(1)%>">Anmelden</a></td>
				<%} 
				
				%>
			<td><a
				href="prüfung_abmeldung.jsp?lva_nummer=<%=rs.getString(2)%>
				&matrikelnummer=<%=rs1.getString(1)%>">Abmelden</a></td>
		</tr>

		<%
				
				}
				} else if (existsMatrikel == false) {
					out.println("Die eingegebene Matrikelnummer existiert nicht!");
				} else {
					out.println("Die eingegebene LVA existiert nicht!");
				}
				existsMatrikel = false;
				existsPrüfung = false;

			} catch (SQLException e) {
				e.printStackTrace();
			} catch (Exception e) {
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
				if (rs1 != null) {
					try {
						rs1.close();
					} catch (SQLException e) {
						;
					}
					rs1 = null;
				}
				if (rs2 != null) {
					try {
						rs2.close();
					} catch (SQLException e) {
						;
					}
					rs2 = null;
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
	</table>
	<br>
	<br>
	<a href="prüfungsservice.html">Zurück</a>
	<a href="main_page.html">Hauptmenü</a>
</body>
</html>