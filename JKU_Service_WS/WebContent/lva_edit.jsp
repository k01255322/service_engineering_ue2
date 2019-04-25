<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
	integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
	crossorigin="anonymous">
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta charset="ISO-8859-1">
<title>LVA bearbeiten</title>
</head>
<body>

	<div class="container">

		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<a class="navbar-brand" href="index.html">Hauptmenü</a> <a
				class="navbar-brand" href="lva_service.html">LVA Service</a> <a
				class="navbar-brand" href="prüfungsservice.html">Prüfungsservice</a>
			<a class="navbar-brand" href="raumservice.html">Raumservice</a> <a
				class="navbar-brand" href="veranstaltungsservice.html">Veranstaltungsservice</a>

		</nav>


		<h3>
			<span class="badge badge-secondary">LVA bearbeiten</span>
		</h3>

		

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
			
			<table class="table">
			<thead>
			<tr>
				<th scope="col">LVA Bezeichnung</th>
				<th scope="col">LVA Nummer</th>
				<th scope="col">LVA Leiter</th>
				<th scope="col">Max. Anzahl Studierender</th>
				<th scope="col">Raum eintragen</th>
				<th scope="col">Datum eintragen</th>
				<th scope="col">Uhrzeit von</th>
				<th scope="col">Uhrzeit bis</th>
			</tr>
			</thead>
			
			<tr>
			<tbody>
				<form method="post" action="lva_edit_update.jsp">	
				<div class="form-group">
				<td><input type="text" class="form-control" name="titel" value="<%=rs.getString(1)%>">
				</td>
				<td><input type="text" class="form-control" name="lva_nummer" value="<%=rs.getString(2)%>">
				</td>
				<td><input type="text" class="form-control" name="leiter" value="<%=rs.getString(3)%>">
				</td>
				<td><input type="text" class="form-control" name="max_studierende" value="<%=rs.getString(4)%>">
				</td>
				<td><select
					class="form-control" name="raum" value="<%=rs1.getString(1)%>">
					<%
						while (rs1.next()) {
					%>
					<option><%=rs1.getString(1)%></option>
					<%
						}
					%>
					</select>
				</td>
				<td><input type="text" class="form-control" name="datum" value="<%=rs.getString(6)%>">
				</td>
				<td><input type="text" class="form-control" name="von" value="<%=rs.getString(7)%>">
				</td>
				<td><input type="text" class="form-control" name="bis" value="<%=rs.getString(8)%>">
				</td>
				<td>
				<button type="submit" class="btn btn-outline-secondary btn-sm">Bestätigen</button>
				</td>
				</div>
				</form>
				</tbody>


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

	</div>
</body>
</html>