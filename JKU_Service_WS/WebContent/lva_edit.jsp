<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>LVA bearbeiten</title>
</head>
<body>
	<h1>LVA bearbeiten</h1>

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
					"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\UE2\\ue2.db");

			String lva_nummer = request.getParameter("lva_nummer");

			String query = "SELECT titel, lva_nummer, leiter, max_studierende, raum, datum, von, bis FROM lva_service WHERE lva_nummer=?";

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
			<form method="post" action="lva_edit_update.jsp">
				<td><input type="text" name="titel"
					value="<%=rs.getString(1)%>"></td>
				<td><input type="text" name="lva_nummer"
					value="<%=rs.getString(2)%>"></td>
				<td><input type="text" name="leiter"
					value="<%=rs.getString(3)%>"></td>
				<td><input type="text" name="max_studierende"
					value="<%=rs.getString(4)%>"></td>
				<td><input type="text" name="raum" list="raum" value="<%=rs.getString(5)%>">
				<datalist id="raum">
					<%while (rs1.next()) {%>
					<option value="<%=rs1.getString(1)%>"></option>
					<%} %>
					</datalist>
				</td>
				<td><input type="text" name="datum"
					value="<%=rs.getString(6)%>"></td>
				<td><input type="text" name="von" value="<%=rs.getString(7)%>"></td>
				<td><input type="text" name="bis" value="<%=rs.getString(8)%>"></td>
				<td><input type="submit" value="Bestätigen"></td>
			</form>
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

	</table>
	<br>
	<br>
	<a href="lva_overview.jsp">Zurück</a>


</body>
</html>