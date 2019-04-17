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
		</tr>

		<%		
			// Datenbankverbindung
			Class.forName("org.sqlite.JDBC");
			Connection conn = DriverManager.getConnection(
					"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

			String lva_bezeichnung = request.getParameter("titel");
			String lva_nummer = request.getParameter("lva_nummer");
			String lva_leiter = request.getParameter("leiter");
			String max_studierende = request.getParameter("max_studierende");
			String raum = request.getParameter("raum");
			
			String queryBezeichnung = "SELECT titel FROM lva_service WHERE lva_nummer=?";
			String queryNummer = "SELECT lva_nummer FROM lva_service WHERE lva_nummer=?";
			String queryLeiter = "SELECT lva_leiter FROM lva_service WHERE lva_nummer=?";
			String queryMaxStudierende = "SELECT max_studierende FROM lva_service WHERE lva_nummer=?";
			String queryRaum = "SELECT raum FROM lva_service WHERE lva_nummer=?";
			
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				if(lva_bezeichnung != null) {
					out.println(lva_bezeichnung);
				}
				pstmt = conn.prepareStatement(queryBezeichnung);
				pstmt.setString(1, lva_nummer);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					
		%>
			<tr>
				<td><%=rs.getString(1)%></td>
				<td><%=rs.getString(2)%></td>
				<td><%=rs.getString(3)%></td>
				<td><%=rs.getString(4)%></td>
				<td><%=rs.getString(5)%></td>
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
<tr>
	<form method="post" action ="">
			<td>Bezeichnung</td>
			<td>LVA Nummer</td>
			<td>LVA Leiter</td>
			<td>Max. Anzahl Studierender</td>
			<td>Raum</td>
			</form>
		</tr>
</body>
</html>