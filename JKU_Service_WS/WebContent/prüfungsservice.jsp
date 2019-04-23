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
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

		String matrikelnummer = request.getParameter("matrikelnummer");

		String qStudent = "SELECT matrikelnummer FROM studenten_liste";

		String test = "SELECT p.lva_titel, p.lva_nummer, p.datum, p.von, p.bis, p.ort, p.anzahl_plaetze, p.anmeldungen FROM pruefungs_service p"
				+ " LEFT JOIN studenten_lva_anmeldungen ON p.lva_nummer=studenten_lva_anmeldungen.lva_nummer WHERE studenten_lva_anmeldungen.matrikelnummer=?";

		Statement stm = null;
		PreparedStatement pstm = null;
		ResultSet rs = null;
		ResultSet rs1 = null;

		try {
			stm = conn.createStatement();
			rs1 = stm.executeQuery(qStudent);
			while (rs1.next()) {
				if (rs1.getString(1).equals(matrikelnummer)) {
					existsMatrikel = true;
					break;
				}
			}
			/**
						stm = conn.createStatement();
						rs2 = stm.executeQuery(qPrüfung);
						while (rs2.next()) {
							if (rs2.getString("lva_titel").equals(lva_bezeichnung)) {
								existsPrüfung = true;
								break;
							}
						}**/

			if (existsMatrikel == true) {

				pstm = conn.prepareStatement(test);
				pstm.setString(1, matrikelnummer);
				rs = pstm.executeQuery();
	%>
	<table border=1>
		<tr>
			<th>LVA Bezeichnung</th>
			<th>LVA Nummer</th>
			<th>Prüfungsdatum</th>
			<th>Von</th>
			<th>Bis</th>
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
			<td><%=rs.getString(8)%><br></td>


			<%
				if (rs.getString(6).equals(rs.getString(7))) {
			%>
			<td>Anmeldung geschlossen</td>
			<%
				} else {
			%>


			<td><a
				href="prüfungsservice_insert.jsp?lva_nummer=<%=rs.getString(2)%>
				&matrikelnummer=<%=matrikelnummer%>
				&lva_titel=<%=rs.getString(1)%>">Anmelden</a></td>
			<%
				}

						}

					} else {
						out.println("Die eingegebene Matrikelnummer existiert nicht!");
					}
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
	<a href="index.html">Hauptmenü</a>
</body>
</html>