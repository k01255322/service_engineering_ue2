<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Prüfung anlegen</title>
</head>
<body>

	<table border=1>
		<tr>
			<th>LVA Titel</th>
			<th>LVA Nummer</th>
			<th>Prüfungstermin</th>
			<th>von</th>
			<th>bis</th>
			<th>Hörsaal</th>
			<th>Anzahl Plätze</th>
		</tr>

		<%
			//Datenbankverbindung
			Class.forName("org.sqlite.JDBC");
			Connection conn = DriverManager.getConnection(
					"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

			String lva_nummer = request.getParameter("lva_nummer");

			String query = "SELECT titel, lva_nummer, leiter FROM lva_service WHERE lva_nummer=?";
			
			String qRaum = "SELECT DISTINCT id FROM raeume";
			
			Statement stmt = null;
			
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ResultSet rs1 = null;

			try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, lva_nummer);
				rs = pstmt.executeQuery();
				
				stmt = conn.createStatement();
				rs1 = stmt.executeQuery(qRaum);
				while (rs.next()) {
		%>
		
		<tr>
			<form method="post" action="prüfung_insert.jsp">
				<td><input type="text" name="titel" value="<%=rs.getString(1)%>" readonly></td>
				<td><input type="text" name="lva_nummer" value="<%=rs.getString(2)%>" readonly></td>
				<td><input type="text" name="datum" placeholder="2019-12-31"></td>
				<td><input type="text" name="von" placeholder="12:30"></td>
				<td><input type="text" name="bis" placeholder="14:30"></td>
				<td><input type="text" name="raum" list ="raum" placeholder="HS 1">
					<datalist id="raum">
					<%while (rs1.next()) {%>
					<option value="<%=rs1.getString(1)%>"></option>
					<%} %>
					</datalist></td>
				<td><input type="text" name="plaetze" placeholder="100"></td>
				<td><input type="submit" value="Bestätigen"></td>
			</form>
		</tr>

</table>



		<%
			}
			} catch (SQLException e) {
				e.printStackTrace();
			} 
			finally {
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

		<br>
		<br>
		<a href="lva_overview.jsp">LVA Übersicht</a>
</body>
</html>