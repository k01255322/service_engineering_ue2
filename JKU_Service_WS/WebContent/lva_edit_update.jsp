<%@ page import="java.sql.*"%>
<%@ page import="org.sqlite.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Bearbeitete LVA updaten</title>
</head>
<body>

	<%
		//Datenbankverbindung
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection(
				"jdbc:sqlite:c:\\Users\\sSTBXg2nYT\\Desktop\\GoogleDrive\\JKU\\Wirtschaftsinformatik\\5. - SS 19\\KV - Service Engineering\\ue2.db");

		String query = "UPDATE lva_service SET titel =?, lva_nummer=?, leiter=?, max_studierende=?, raum=? WHERE lva_nummer=?";

		PreparedStatement pstmt = null;

		String lva_titel = request.getParameter("titel");
		String lva_nummer = request.getParameter("lva_nummer");
		String leiter = request.getParameter("leiter");
		int max_studierende = Integer.parseInt(request.getParameter("max_studierende"));
		String raum = request.getParameter("raum");

		Date datum = null; //Date.valueOf(request.getParameter("datum"));
		Time von = null;//Time.valueOf(request.getParameter("von"));
		Time bis = null;//Time.valueOf(request.getParameter("bis"));
		/**
		if (request.getParameter("datum") != null && !request.getParameter("datum").equals("")) {
			out.println(request.getParameter("datum"));
			//datum = Date.valueOf(request.getParameter("datum"));
		}
		
		if (request.getParameter("von") != null && !request.getParameter("von").equals("")) {
			von = Time.valueOf(request.getParameter("von"));
		}
		
		if (request.getParameter("bis") != null && !request.getParameter("bis").equals("")) {
			bis = Time.valueOf(request.getParameter("bis"));
		}
		**/
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, lva_titel);
			pstmt.setString(2, lva_nummer);
			pstmt.setString(3, leiter);
			pstmt.setInt(4, max_studierende);
			pstmt.setString(5, raum);
			/**
			pstmt.setDate(6, datum);
			pstmt.setTime(7, von);
			pstmt.setTime(8, bis);**/
			pstmt.setString(6, lva_nummer);

			pstmt.executeUpdate();

			out.println("LVA wurde erfolgreich aktualisiert!");

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
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